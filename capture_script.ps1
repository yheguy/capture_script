# Initialise ce qu'on on a besoin pour gerer la pop-up qui permettra 
# de choisir dans quel dossier déplacer les capture
Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class KeyboardListener {
    [DllImport("User32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

# Initialisation des chemins
$global:sourceCapturePath = "C:\Users\YHEGUY\capture"
$global:captureDestinationDirectoryPath = "C:\Users\YHEGUY\ticket"
$global:captureDestinationPath = $global:captureDestinationDirectoryPath

# check si le dossier existe si non le créé
if (!(Test-Path -Path $global:captureDestinationPath)) {
    New-Item -ItemType Directory -Path $global:captureDestinationPath
}

# Pop-up avec un champs a remplir pour dire dans quel dossier mettre les captures
function Show-InputDialog {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Entrée de texte"
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = "CenterScreen"

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Size = New-Object System.Drawing.Size(260, 20)
    $textBox.Location = New-Object System.Drawing.Point(10, 10)
    $form.Controls.Add($textBox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(200, 40)
    $okButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $form.Controls.Add($okButton)

    if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } else {
        return $null
    }
}

# Déplace les fichiers ayant le meme format que les captures
Function Move-ScreenshotToDirectory {
    Get-ChildItem -Path $global:sourceCapturePath | ForEach-Object {
        if (-not(Test-Path $_ -PathType Container)) {
            if ($_ -match "\d{4}-\d{2}-\d{2} " -and $_.Extension -eq ".png") {
                if ($_.CreationTime -lt (Get-Date).AddSeconds(-2)) {
                    Move-Item $_ -Destination $global:captureDestinationPath
                }
            }
        }
    }
}

# Boucle à l'infini
while ($true) {
    Start-Sleep -Milliseconds 100
    # "ctrl"+"maj"+"+"
    if ([KeyboardListener]::GetAsyncKeyState(0x11) -and [KeyboardListener]::GetAsyncKeyState(0x10) -and [KeyboardListener]::GetAsyncKeyState(0xBB)) {
        $inputText = Show-InputDialog
        if ($inputText) {
            $global:captureDestinationPath = "$global:captureDestinationDirectoryPath\$inputText"
            
            # check si le dossier existe si non le créé
            if (!(Test-Path -Path $global:captureDestinationPath)) {
                New-Item -ItemType Directory -Path $global:captureDestinationPath
            }
        }
    }

    Move-ScreenshotToDirectory
}