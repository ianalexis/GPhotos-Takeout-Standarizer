$folderPath = Read-Host "Ingrese la ruta del directorio a procesar:"

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Group the files by their name
$groupedFiles = $files | Group-Object -Property Name

# Iterate through each group
foreach ($group in $groupedFiles) {
    # If there are duplicates, delete all except the first file
    if ($group.Count -gt 1) {
        $filesToDelete = $group.Group | Select-Object -Skip 1
        $filesToDelete | Remove-Item -Force
    }
}