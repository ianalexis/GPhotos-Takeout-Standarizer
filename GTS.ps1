# Leer la ruta del directorio a procesar
$folderPath = Read-Host "Ingrese la ruta del directorio a procesar:"

# Ejecutar json.ps1
$extensions = "*.jpg", "*.jpeg", "*.gif", "*.mp4", "*.png", "*.webp"

# Obtener todos los archivos con las extensiones especificadas en la carpeta
$files = Get-ChildItem -Path $folderPath -Include $extensions -File -Recurse

# Procesar cada archivo
foreach ($file in $files) {
	# Construir la ruta para el archivo .json correspondiente
	$jsonFilePath = $file.FullName + ".json"

	# Verificar si el archivo .json existe
	if (Test-Path -Path $jsonFilePath) {
		# Leer el contenido del archivo .json
		$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

		# Extraer el timestamp de photoTakenTime
		if ($jsonContent.photoTakenTime) {
			$timestamp = [long]$jsonContent.photoTakenTime.timestamp
			$newDate = Get-Date -Date ([datetime]::FromFileTimeUtc($timestamp * 10000000 + 116444736000000000))

			# Cambiar las fechas de creación, modificación y acceso del archivo
			$file.CreationTime = $newDate
			$file.LastWriteTime = $newDate
			$file.LastAccessTime = $newDate

			Write-Host "Fecha de $($file.Name) cambiada a $($newDate)"
		}
	}
}

# Obtener todos los archivos con las extensiones especificadas
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
				# Obtener la fecha y hora actual del archivo
				$currentDate = $file.LastWriteTime

				$year = $currentDate.Year
				$month = $currentDate.Month
				$day = $currentDate.Day
				$hour = $currentDate.Hour
				$minute = $currentDate.Minute
				$second = $currentDate.Second
			}

			# Crear un objeto de tipo DateTime con la fecha y hora extraída
			$newDate = Get-Date -Year $year -Month $month -Day $day -Hour $hour -Minute $minute -Second $second

			# Cambiar las fechas de creación, modificación y acceso del archivo
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

# Obtener todos los archivos JSON en la carpeta
$jsonFiles = Get-ChildItem -Path $folderPath -Filter "*.json" -File

# Eliminar cada archivo JSON
foreach ($file in $jsonFiles) {
	Remove-Item -Path $file.FullName -Force
}

# Obtener todos los archivos en la carpeta
$files = Get-ChildItem -Path $folderPath -File

# Agrupar los archivos por su nombre
$groupedFiles = $files | Group-Object -Property Name

# Iterar a través de cada grupo
foreach ($group in $groupedFiles) {
	# Si hay duplicados, eliminar todos excepto el primer archivo
	if ($group.Count -gt 1) {
		$filesToDelete = $group.Group | Select-Object -Skip 1
		$filesToDelete | Remove-Item -Force
	}
}

