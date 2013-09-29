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

echo 'Installing Developer Base'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallDeveloperBase.ps1"

echo 'Installing VS2012'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallVS2012.ps1"

