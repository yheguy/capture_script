# Initialisation des chemins
$global:sourceCapturePath = "C:\Users\YHEGUY\capture"
$global:captureDestinationDirectoryPath = "C:\Users\YHEGUY\ticket"

# check si le dossier existe si non le créé
if (!(Test-Path -Path $global:captureDestinationDirectoryPath)) {
    New-Item -ItemType Directory -Path $global:captureDestinationDirectoryPath
}

# Déplace les fichiers ayant le meme format que les captures
Function Move-ScreenshotToDirectory {
    Get-ChildItem -Path $global:sourceCapturePath | ForEach-Object {
        if (-not(Test-Path $_ -PathType Container)) {
            if ($_ -match "\d{4}-\d{2}-\d{2} " -and $_.Extension -eq ".png") {
                Move-Item $_ -Destination $global:captureDestinationDirectoryPath
            }
        }
    }
}

# Boucle à l'infini
while ($true) {

    Start-Sleep -Seconds 5

    Move-ScreenshotToDirectory
}