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

## V 0.2

1. Objectif

Déplacer les captures d'écran vers un dossier choisi dynamiquement. 
Le code est plus propre et on ajoute les logs.

2. Variable globale

| $global:sourceCapturePath            | Le dossier où les captures sont stockées (il est possible de changer ce dossier dans les paramètre de l'application "outil de capture"). |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| $global:captureDestinationDirectoryPath | Le dossier dans lequel je veux mettre tous mes dossiers (tickets) qui contiendront les photos.                                           |
| $global:captureDestinationPath       | Le dossier (ticket) dans lequel les capture vont.                                                                                        |

3. Fonction


| Test-DirectoryAndCreate           | Prend un chemin en paramètre puis regarde si le dossier existe. Si il n'existe pas il le crée.                                                                                                                                  |
| Write-Log                         | Prend le message et le niveau du log en paramètre. Permet d'uniformiser les log au format "yyyy-mm-dd hh:mm:ss - [level] - message".                                                                                            |
| Show-InputDialog                  | Permet d'afficher une pop-up qui va return ce qu'on écrit dans la textbox.                                                                                                                                                      |
| Move-ScreenshotToDirectory | Boucle dans le dossier ou arrive les capture, vérifie qu'il s'agit bien d'une capture et qu'elle a était créé récemment. Elle déplace la capture dans le dossier voulu puis met un lien markdown dans la note associé.          |

4. Déroulé

- On commence par déclarer toutes nos fonctions.
- On initialise ce dont on a besoin pour les notifications 
- On initialise ce dont a besoin la fonction "Show-InputDialog"
- On initialise les variables globales
- On boucle a l'infini
	- On attend 100 ms
	- On observe si le raccourcie clavier "ctrl"+"maj"+"+" est fait
		- On demande sur quel ticket on veut travailler (Show-InputDialog)
	- On déplace les captures d'écran dans le dossier du ticket en cours (Move-ScreenshotToNote)


# All versions
### V0.1

Déplacer les captures d'écran vers un dossier choisi.


## V 0.2

1. Objectif

Déplacer les captures d'écran vers un dossier choisi dynamiquement.

2. Variable globale

| $global:sourceCapturePath            | Le dossier où les captures sont stockées (il est possible de changer ce dossier dans les paramètre de l'application "outil de capture"). |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| $global:captureDestinationDirectoryPath | Le dossier dans lequel je veux mettre tous mes dossiers (tickets) qui contiendront les photos.                                           |
| $global:captureDestinationPath       | Le dossier (ticket) dans lequel les capture vont.                                                                                        |

3. Fonction


| Show-InputDialog                  | Permet d'afficher une pop-up qui va return ce qu'on écrit dans la textbox.                                                                                                                                                      |
| Move-ScreenshotDirectory | Boucle dans le dossier ou arrive les capture, vérifie qu'il s'agit bien d'une capture et qu'elle a était créé récemment. Elle déplace la capture dans le dossier voulu          |

4. Déroulé

- On commence par déclarer toutes nos fonctions.
- On initialise ce dont on a besoin pour les notifications 
- On initialise ce dont a besoin la fonction "Show-InputDialog"
- On initialise les variables globales
- On boucle a l'infini
	- On attend 100 ms
	- On observe si le raccourcie clavier "ctrl"+"maj"+"+" est fait
		- On demande sur quel ticket on veut travailler (Show-InputDialog)
	- On déplace les captures d'écran dans le dossier du ticket en cours (Move-ScreenshotToNote)