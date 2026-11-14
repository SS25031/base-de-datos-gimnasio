# backup.ps1
# Script de Respaldo Lógico

#Configuración
$nombreContenedor = "db_gimnasio"
$dbUser = "admin_gimnasio"
$dbName = "db_gimnasio"
$carpetaDestino = "./backups_locales"

#Crear la carpeta si no existe
if (-Not (Test-Path $carpetaDestino)) {
    New-Item -ItemType Directory -Path $carpetaDestino | Out-Null
}

#Nombre del archivo con fecha
$fecha = Get-Date -Format "yyyyMMdd_HHmmss"
$nombreArchivo = "$carpetaDestino/${dbName}_$fecha.dump"

#Ejecutar pg_dump a través de Docker
Write-Host "Iniciando respaldo de $dbName..." -ForegroundColor Cyan

# Copia el comando a una ruta temporal dentro del contenedor y luego lo trae a la compu
docker exec $nombreContenedor pg_dump -U $dbUser -Fc -b -f /tmp/backup.dump $dbName
docker cp "${nombreContenedor}:/tmp/backup.dump" $nombreArchivo
docker exec $nombreContenedor rm /tmp/backup.dump

#Verificar resultado
if (Test-Path $nombreArchivo) {
    Write-Host "Respaldo completado exitosamente en: $nombreArchivo" -ForegroundColor Green
} else {
    Write-Host "Error al realizar el respaldo." -ForegroundColor Red
}