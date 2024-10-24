@echo off
setlocal

:: URL és útvonalak beállítása
set "url=https://files.berniestory.org/github/batboxes.zip"
set "tempDir=%TEMP%\batboxes.zip"
set "desktopDir=%USERPROFILE%\Desktop\batboxes"

:: Üzenet megjelenítése letöltés közben
echo Downloading and extracting to the Desktop...
powershell -command "$wshell = New-Object -ComObject Wscript.Shell; $wshell.Popup('Downloading and extracting to the Desktop...', 3, 'Please wait...', 64)"

:: Fájl letöltése a temp mappába
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempDir%')"

:: Kicsomagolás az Asztalra
powershell -Command "Expand-Archive -Path '%tempDir%' -DestinationPath '%desktopDir%' -Force"

:: Zöld töltősáv megjelenítése PowerShell-ben
powershell -Command "& {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object system.Windows.Forms.Form
    $form.Text = 'Processing'
    $form.Size = New-Object System.Drawing.Size(350,150)
    $form.StartPosition = 'CenterScreen'

    $label = New-Object System.Windows.Forms.Label
    $label.Text = 'Download and extraction complete!'
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50,20)
    $form.Controls.Add($label)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(50,50)
    $progressBar.Width = 250
    $progressBar.Style = 'Continuous'
    $progressBar.Value = 100
    $form.Controls.Add($progressBar)

    $timer = New-Object system.Windows.Forms.Timer
    $timer.Interval = 3000
    $timer.Add_Tick({ $form.Close() })
    $timer.Start()

    $form.ShowDialog()
}"

:: Töröljük a letöltött zip fájlt a temp mappából
del "%tempDir%"

endlocal
exit /b
