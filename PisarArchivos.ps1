# Definir las rutas de los directorios A (Viejos) y B (Nuevos)
$dirA = Read-Host "Ingrese la ruta del directorio A (Viejos) ej. C:\Viejos"
$dirB = Read-Host "Ingrese la ruta del directorio B (Nuevos) ej. C:\Nuevos"
$tolerancia = Read-Host "Ingrese la tolerancia en porcentaje para el tamaño de los archivos (ej. 10 para +/-10%):"
$cantProcesados = 0
$cantReemplazados = 0
$cantNoReemplazados = 0

# Validar que los directorios sean distintos
if ($dirA -eq $dirB) {
    Write-Host "Los directorios deben ser distintos. Por favor, ingrese rutas diferentes."
    # Pausar 10 segundos
    Start-Sleep -Seconds 10
    return
}

# Validar que los directorios existan
if (-not (Test-Path $dirA) -or -not (Test-Path $dirB)) {
    Write-Host "Uno o ambos directorios no existen. Por favor, ingrese rutas válidas."
    # Pausar 10 segundos
    Start-Sleep -Seconds 10
    return
}

# Obtener la lista de archivos en el directorio B y sus subcarpetas
$filesB = Get-ChildItem -Path $dirB -File -Recurse

# Procesar cada archivo en el directorio B
foreach ($fileB in $filesB) {
    # Buscar en el directorio A y sus subcarpetas si existe un archivo con el mismo nombre
    $fileA = Get-ChildItem -Path $dirA -File -Recurse | Where-Object { $_.Name -eq $fileB.Name }
    Write-Host "Procesando $($fileB.FullName)..."
    $cantProcesados++

    # Si el archivo A existe, reemplaza el archivo A por el archivo B cortando B en A
    if ($fileA) {
        # Compara si el tamaño de los archivos es +/-10% del tamaño del archivo A
        $toleranciaPorcentaje = [int]$tolerancia
        $toleranciaMinima = $fileB.Length * (1 - ($toleranciaPorcentaje / 100))
        $toleranciaMaxima = $fileB.Length * (1 + ($toleranciaPorcentaje / 100))
        
        if ($fileA.Length -gt $toleranciaMinima -and $fileA.Length -lt $toleranciaMaxima) {
            Write-Host "El archivo $($fileB.Name) coincide un $([int]($fileA.Length / $fileB.Length * 100))% con el archivo $($fileA.Name)."
            # Eliminar el archivo A
            Remove-Item -Path $fileA.FullName -Force
            # Mover el archivo B al directorio A
            Move-Item -Path $fileB.FullName -Destination $fileA.DirectoryName
            Write-Host "El archivo $($fileB.Name) ha sido reemplazado por el archivo $($fileA.Name)."
            $cantReemplazados++
        }
    } else {
        Write-Host "El archivo $($fileB.Name) no tiene un archivo correspondiente en el directorio A."
        $cantNoReemplazados++
    }
}

Write-Host "Procesados: $cantProcesados"
Write-Host "Reemplazados: $cantReemplazados"
Write-Host "No reemplazados: $cantNoReemplazados"
Write-Host "Validacion (Reemplazados + No reemplazados): $($cantReemplazados + $cantNoReemplazados)"
Write-Host "Proceso finalizado."