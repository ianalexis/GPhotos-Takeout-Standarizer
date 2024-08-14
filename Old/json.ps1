$folderPath = Read-Host "Ingrese la ruta del directorio a procesar:"
$extensions = "*.jpg", "*.jpeg", "*.gif", "*.mp4", "*.png", "*.webp"

# Get all the files with the specified extensions in the folder
$files = Get-ChildItem -Path $folderPath -Include $extensions -File -Recurse

# Process each file
foreach ($file in $files) {
    # Construct the path for the corresponding .json file
    $jsonFilePath = $file.FullName + ".json"

    # Check if the .json file exists
    if (Test-Path -Path $jsonFilePath) {
        # Read the contents of the .json file
        $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

        # Extract the photoTakenTime timestamp
        if ($jsonContent.photoTakenTime) {
            $timestamp = [long]$jsonContent.photoTakenTime.timestamp
            $newDate = Get-Date -Date ([datetime]::FromFileTimeUtc($timestamp * 10000000 + 116444736000000000))

            # Change the file's creation, modification, and access times
            $file.CreationTime = $newDate
            $file.LastWriteTime = $newDate
            $file.LastAccessTime = $newDate

            Write-Host "Fecha de $($file.Name) cambiada a $($newDate)"
        }

    }

}