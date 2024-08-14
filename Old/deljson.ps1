$folderPath = Read-Host "Ingrese la ruta del directorio a procesar:"

# Get all JSON files in the folder
$jsonFiles = Get-ChildItem -Path $folderPath -Filter "*.json" -File

# Delete each JSON file
foreach ($file in $jsonFiles) {
    Remove-Item -Path $file.FullName -Force
}