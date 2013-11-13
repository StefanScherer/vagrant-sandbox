echo 'Ensuring .NET 4.0 is installed'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallNet4.ps1"

echo 'Ensuring Chocolatey is Installed'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallChocolatey.ps1"

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%SystemDrive%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

