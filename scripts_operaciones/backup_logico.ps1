# backup.ps1 - Script de Respaldo Lógico Automatizado
$nombreContenedor = "db_gimnasio"
$dbUser = "admin_gimnasio"
$dbName = "db_gimnasio"

# Ruta absoluta relativa al script (evita que task scheduler guarde en system32)
$carpetaDestino = Join-Path $PSScriptRoot "..\backups_locales"

if (-Not (Test-Path $carpetaDestino)) {
    New-Item -ItemType Directory -Path $carpetaDestino | Out-Null
}

$fecha = Get-Date -Format "yyyyMMdd_HHmmss"
$nombreArchivo = Join-Path $carpetaDestino "${dbName}_$fecha.dump"

Write-Host "Iniciando respaldo automático de $dbName..." -ForegroundColor Cyan

docker exec $nombreContenedor pg_dump -U $dbUser -Fc -b -f /tmp/backup.dump $dbName
docker cp "${nombreContenedor}:/tmp/backup.dump" $nombreArchivo
docker exec $nombreContenedor rm /tmp/backup.dump

if (Test-Path $nombreArchivo) {
    Write-Host "Respaldo completado exitosamente en: $nombreArchivo" -ForegroundColor Green
    # politica de retencion: esto va a eliminar respaldos lógicos con más de 7 días de antiguedad
    Get-ChildItem -Path $carpetaDestino -Filter "*.dump" |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
        Remove-Item -Force
} else {
    Write-Host "Error al realizar el respaldo." -ForegroundColor Red
}