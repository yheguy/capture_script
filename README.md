# capture_script

Ce script a pour but de rentre le rangement de mes captures plus efficace et d'optimiser ma prise de note.
Ce script s'inspire du script TriCapture, ce script à été codé par un collègue mais ne répondant pas exactement a mes besoins j'ai décidé de le retravailler.

# Prérequis

Il faut exécuter sur PowerShell uniquement ! 
Pas sur windows powershell !

Prendre le script dans \\\ddc\SAS\TEMP\Yannis\Capture_script

# Exécution

Se placer dans le même dossier que le script.
Bien penser à changer les chemins des variables pour les adapter à vos besoins.

.\capture_script.ps1

# Latest version

## V 0.1

Déplacer les captures d'écran vers un dossier choisi.

| $global:sourceCapturePath            | Le dossier où les captures sont stockées (il est possible de changer ce dossier dans les paramètre de l'application "outil de capture"). |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| $global:captureDestinationDirectoryPath | Le dossier dans lequel je veux mettre tous mes dossiers (tickets) qui contiendront les photos.                                           |