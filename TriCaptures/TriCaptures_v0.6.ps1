<#
Description : Script permettant de copier en continue les captures d'écran, présentes dans "C:\Users\...\Pictures\Screenshots",
dans un dossier correspondant à la date de création de ces dernières
Le script créé un dossier daté du jour d'exécution, ainsi qu'un dossier "Backup" dans lequel les dossiers datés de 30 jours ou plus sont déplacés
Les dossiers datés de 60 jours ou plus dans "Backup" sont supprimés
Usage : Voir le fichier PDF joint : TriCapture_v0.6.pdf
Auteur : Aymeric S.
Version : 0.6
Révisions :
    -0.6 (19/09/2024) : Correction d'une erreur "DirectoryNotFoudException" 
    -0.5 (18/09/2024) : Ajout de l'option de sélection copier/déplacer
                        Ajout de la fonction LastFoldersCreation permettant la création des dossiers des 30 jours précédents
                        Ajout d'une condition dans la fonction SortScreenshots pour avoir la possibilité de choisir le dossier de captures, lui-même, comme destination
                        Ajout d'une section "Paramètres"
    -0.4 (13/09/2024) : Ecriture d'une fonction de suppression de captures présentes dans la corbeille
                        Remplacement des occurrences "C:" par "$env:SystemDrive"
                        Correction de commentaire
                        Ecriture d'une fonction de nettoyage de dossier
    -0.3 (11/09/2024) : Ajout d'une boucle infinie
                        Ajout de la fonction SortScreenshots permettant le triage des fichiers présents dans le dossier de captures
                        Ajout de la fonction CleanBackup permettant le nettoyage du dossier "Backup"
                        Ajout de la fonction ToBackup permettant la création du dossier "Backup" et le déplacement des dossiers de 30 jours ou plus vers celui-ci
                        Ajout de la fonction FolderAgeCheck permettant la vérification de l'âge du dossier
                        Ajout de la fonction FolderCreation permettant la création de dossier
                        Suppression des fonctions permettant la création de dossiers datant du mois dernier et du mois d'avant
    -0.2 (03/09/2024) : Ajout de fonctions permettant la création de dossiers datant du mois dernier et du mois d'avant
    -0.1 (02/09/2024) : Version initiale
#>

<#------PARAMETRES------#>

#Copier/Déplacer
$global:moveOrCopy = 'C' #Modifier la valeur dans <<''>> : 'C' pour copier les fichiers, 'D' pour déplacer les fichiers

#Chemin absolu source du dossier de captures
$global:sourceFolderPath = "$env:SystemDrive\Users\$env:USERNAME\Pictures\Screenshots" #Modifier le chemin du dossier de captures après "$env:USERNAME\"

#Chemin absolu cible
$global:targetFolderPath = "$env:SystemDrive\Users\$env:USERNAME\Documents\DossiersDuMois" #Modifier le chemin du dossier souhaité après "$env:USERNAME\"
#$global:targetFolderPath = "$env:SystemDrive\Users\$env:USERNAME\Pictures\Screenshots" #Modifier le chemin du dossier souhaité après "$env:USERNAME\"

#Délai
$global:delay = 0 #Changer la fréquence à la valeur souhaitée, en seconde (utiliser '.' pour séparer les secondes, des millisecondes ex. : 1.5), pour instaurer un délai d'exécution

<#----------------------#>

#Date du jour au format de Text
$global:currentDateText = (Get-Date).ToString("yyyy-MM-dd")

#Fonction de création de dossier
function FolderCreation {

    #2 paramètres
    param (
        #Chemin absolu cible
        [string]$parentPath,
        #Nom du dossier
        [string]$folderName
    )

    #Chemin absolu cible + nom du dossier
    $pathAndFolder = Join-Path -Path $parentPath -ChildPath $folderName

    #Si le dossier n'existe pas :
    if (-not(Test-Path -Path $pathAndFolder)) {
        #Création du dossier
        New-Item -Path $pathAndFolder -ItemType Directory -Force
    }
}

#Fonction de test de l'âge du dossier
Function FolderAgeCheck {

    #1 paramètre
    param (
        #Nom du dossier
        [string]$folderName
    )

    #Si le nom du dossier est différent de la date du jour et est différent de "Bakcup"
    if ($folderName.ToString() -ne $currentDateText.ToString() -And $folderName.ToString() -ne "Backup") {
        #Essai
        try {
            #Renvoie l'âge en jours du dossier
            return (New-TimeSpan -Start $folderName -End $currentDateText).ToString("dd")
        #Ignore l'erreur
        } catch {}
    }
}

#Fonction de déplacement vers "Backup"
Function ToBackup {

    #2 paramètres
    param (
        #Chemin absolu cible
        [string]$parentPath
    )

    #Création du dossier "Backup"
    FolderCreation $targetFolderPath "Backup"

    #Pour chaque dossier du dossier parent
    Get-ChildItem -Path $parentPath -Directory | ForEach-Object {
        #Si l'âge du dossier est plus grand que 30
        if (([int](FolderAgeCheck $_)) -gt 30) {
            #Déplacement du dossier dans "Backup"
            Move-Item -Path $targetFolderPath\$_ -Destination $targetFolderPath\Backup
        }
    }
}

#Fonction de nettoyage du dosser "Backup"
Function CleanBackup {
    #Pour chaque dossier du dossier "Backup"
    Get-ChildItem -Path $targetFolderPath\Backup -Directory | ForEach-Object {
        #Si l'âge du dossier est plus grand que 60
        if (([int](FolderAgeCheck $_)) -gt 60) {
            #Suppression du dossier
            Remove-Item -Recurse $targetFolderPath\Backup\$_
        }
    }
}

#Fonction de triage des captures d'écran du dossier de captures
Function SortScreenshots {
    #Pour chaque fichier du dossier de captures
    Get-ChildItem -Path $sourceFolderPath | ForEach-Object {
        #Si le fichier n'est pas un dossier
        if (-not(Test-Path $_ -PathType Container)) {
            #Si le nom du fichier contient une date au format AAAA-MM-JJ
            if ($_ -match "\d{4}-\d{2}-\d{2} ") {
                #Récupère la date (sans l'espace)
                $date = $matches[0].Substring(0, $matches[0].Length - 1)
                #Si l'option 'C' a été séléctionnée
                if ($moveOrCopy -eq 'C') {
                    #Copie le fichier depuis le dossier de captures dans le dossier correspondant
                    Copy-Item $sourceFolderPath\$_ -Destination $targetFolderPath\$date
                #Sinon, si l'option 'D' a été séléctionnée
                } elseif ($moveOrCopy -eq 'D') {
                    #Si le fichier n'existe pas déjà dans le dossier correspondant
                    if (-not(Test-Path -Path $targetFolderPath\$date\$_)) {
                        #Déplace le fichier depuis le dossier de captures dans le dossier correspondant
                        Move-Item $sourceFolderPath\$_ -Destination $targetFolderPath\$date
                    }
                }
            }
        }
    }
}

#Fonction de nettoyage du dossier de captures
<#Function CleanScreenshotFolder {
    if (-not(Test-Path -Path $targetFolderPath\Nettoyer.sponge)) {
        #Création du dossier
        New-Item -Path $targetFolderPath\Nettoyer.sponge -ItemType "File"
    }

    #Pour chaque dossier du dossier "DossierDuMois"
    Get-ChildItem -Path $targetFolderPath -Directory | ForEach-Object {
        #Si le dossier contient "Nettoyer.sponge"
        if (Test-Path -Path $_\Nettoyer.sponge) {
            #
            Write-Host $_.ToString()
        }
    }

}#>

#Fonction de suppression des captures d'écran à supprimer
<#Function ToTrash {
    #Pour chaque fichier de la corbeille
    Get-ChildItem -Path $env:SystemDrive\'$Recycle.Bin' -Recurse | ForEach-Object {
        Write-Host $_
        $fileInRecycleBin = $_
        #Pour chaque fichier du dossier de captures
        Get-ChildItem -Path $sourceFolderPath | ForEach-Object {
            #Si le nom du fichier présent dans la corbeille est le même que celui dans le dossier de captures
            Write-Host $_.Name
            if ($fileInRecycleBin.Name -eq $_.Name) {
                #Suppression du fichier dans le dossier de caputres
                Remove-Item $sourceFolderPath\$_
            }
        }
    }
}#>

#Fonction de création des dossier des 30 derniers jours
function LastFoldersCreation {
    
    #2 paramètres
    param (
        #Chemin absolu cible
        [string]$parentPath,
        #Nom du dossier
        [string]$folderName
    )

    #Conversion de la date texte en objet DateTime
    $startDate = [datetime]::ParseExact($currentDateText, "yyyy-MM-dd", $null)
    #Pour chaque itération : de 1 à 30
    1..30 | ForEach-Object {
        #Date du jour moins i(1,2,3,...) jours
        $lastDate = $startDate.AddDays(-$_).ToString("yyyy-MM-dd")
        #Création du dossier du ième jour avant
        FolderCreation $targetFolderPath $lastDate
    }
}

<#---MAIN---#>

#Boucle infinie
while($true) {
    #Création du dossier du jour
    FolderCreation $targetFolderPath $currentDateText

    #Création des dossier des 30 derniers jours
    LastFoldersCreation $targetFolderPath $currentDateText

    #Déplacement des dossiers de 30 jours ou plus vers "Backup"
    ToBackup $global:targetFolderPath

    #Suppression des dossiers de 60 jours ou plus dans "Backup"
    CleanBackup

    #Triage des captures d'écran
    SortScreenshots

    #Suppression des captures d'écran à supprimer
    #ToTrash

    #Nettoyage du dossier de capture
    #CleanScreenshotFolder

    #Instaure un délai de X secondes
    Start-Sleep -Seconds $delay
}