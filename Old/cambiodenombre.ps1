# Define la carpeta de destino
$folderPath = Read-Host "Ingrese la ruta del directorio a procesar:"

# Obtiene todos los archivos con las extensiones especificadas
$files = Get-ChildItem -Path $folderPath -Include *.jpg, *.jpeg, *.gif, *.mp4, *.png, *.webp -Recurse

foreach ($file in $files) {
    # Expresiones regulares para capturar la fecha y hora en diferentes formatos
    $patterns = @(
    "(\d{8})_(\d{6})-.*\.gif",
    "(\d{8})_(\d{6})-.*\.jpg",
    "(\d{8})(\d{6})\d{3}_.*\.mp4",
    "(\d{8})(\d{6})\d{3}_.*\.jpg",
    "IMG_(\d{8})_(\d{6})_\d{3}\.jpg",
    "IMG_(\d{8})_(\d{6})_\d{3}\.webp",
    "IMG_(\d{8})_(\d{6})_\d{3}\.jpg",
    "instasize_(\d{8})(\d{6})\.png",
    "VID-(\d{8})-WA\d{4}\.mp4",
    "Screenshot_(\d{8})_(\d{6})_.*\.jpg",
    "IMG-(\d{8})-WA\d{4}\.jpeg",
    "IMG-(\d{8})-WA\d{4}\.jpg",
    "VID_(\d{8})_(\d{6})_\d{3}\.mp4",
    "VID_(\d{8})_(\d{9})\.mp4",
    "IMG-(\d{8})-WA\d{4}\.jpeg",
    "IMG-(\d{8})-WA\d{4}\.jpg",
    "VID_(\d{9})_(\d{6})_\d{3}\.mp4",
    "(\d{8})_(\d{6})\.jpg",
    "VID_(\d{9})_(\d{6})_(\d{3})\.mp4" # Nuevo patrón para VID_218930601_232248_210.mp4
)

    $matched = $false

    foreach ($pattern in $patterns) {
        if ($file.Name -match $pattern) {
            $dateString = $matches[1]
            $timeString = $matches[2]

            if (-not [string]::IsNullOrEmpty($timeString)) {
                $year = [int]$dateString.Substring(0, 4)
                $month = [int]$dateString.Substring(4, 2)
                $day = [int]$dateString.Substring(6, 2)
                $hour = [int]$timeString.Substring(0, 2)
                $minute = [int]$timeString.Substring(2, 2)
                $second = [int]$timeString.Substring(4, 2)

                # Validar los valores extraídos
                if ($month -gt 12 -or $day -gt 31 -or $hour -gt 23 -or $minute -gt 59 -or $second -gt 59) {
                    Write-Host "El archivo $($file.Name) tiene una fecha u hora no valida."
                    continue
                }
            }
            else {
                # Obtiene la fecha y hora actual del archivo
                $currentDate = $file.LastWriteTime

                $year = $currentDate.Year
                $month = $currentDate.Month
                $day = $currentDate.Day
                $hour = $currentDate.Hour
                $minute = $currentDate.Minute
                $second = $currentDate.Second
            }

            # Crea un objeto de tipo DateTime con la fecha y hora extraída
            $newDate = Get-Date -Year $year -Month $month -Day $day -Hour $hour -Minute $minute -Second $second

            # Cambia la fecha de creación, de modificación y de acceso del archivo
            $file.CreationTime = $newDate
            $file.LastWriteTime = $newDate
            $file.LastAccessTime = $newDate

            Write-Host "Fecha de $($file.Name) cambiada a $($newDate)"
            $matched = $true
            break
        }
    }

    if (-not $matched) {
        Write-Host "El archivo $($file.Name) no coincide con el formato esperado."
    }
}