$nombreContenedor = "db_gimnasio"
$dbUser = "admin_gimnasio"
$fecha = Get-Date -Format "yyyyMMdd_HHmmss"
$carpetaContenedor = "/backup_data/base_fisica_$fecha"
$carpetaLocal = Join-Path $PSScriptRoot "..\backups_locales"

if (-Not (Test-Path $carpetaLocal)) {
    New-Item -ItemType Directory -Path $carpetaLocal | Out-Null
}

Write-Host "Iniciando respaldo físico en $carpetaContenedor..." -ForegroundColor Cyan

# Asegurar permisos en el volumen /backup_data
docker exec -u root $nombreContenedor bash -c "mkdir -p /backup_data && chown -R postgres:postgres /backup_data"

# Generar el respaldo físico completo junto con el historial de 2025
docker exec -u postgres $nombreContenedor pg_basebackup -U $dbUser -D $carpetaContenedor -Fp -Xs -P -c fast --tablespace-mapping=/var/lib/postgresql/tablespace_historico=$carpetaContenedor/ts_historico

# Ajustar permisos y enlace simbólico del espacio de tablas histórico
docker exec -u postgres $nombreContenedor bash -c "chmod 700 $carpetaContenedor/ts_historico && ln -sfn /var/lib/postgresql/data/base_fisica_$fecha/ts_historico $carpetaContenedor/pg_tblspc/*"

#Traer la copia física hacia tu carpeta backups_locales en la PC
docker cp "${nombreContenedor}:$carpetaContenedor" "$carpetaLocal\base_fisica_$fecha"

# Retención automática (7 días) en el volumen y en backups_locales
docker exec -u root $nombreContenedor bash -c "find /backup_data -maxdepth 1 -type d -name 'base_fisica_*' -mtime +7 -exec rm -rf {} +"
Get-ChildItem -Path $carpetaLocal -Directory -Filter "base_fisica_*" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
    Remove-Item -Recurse -Force

Write-Host "Respaldo físico guardado en: $carpetaLocal\base_fisica_$fecha" -ForegroundColor Green
