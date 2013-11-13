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

if exist c:\chocolatey\bin\7za.bat goto ZIP_INSTALLED
call cinst 7zip.commandline
:ZIP_INSTALLED

if exist c:\chocolatey\bin\autoit3.bat goto AUTOIT_INSTALLED
call cinst autoit.commandline
call cinst autoit
:AUTOIT_INSTALLED

@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallNet351.ps1"
set SealSetupInstaller=\\roettfs1.sealsystems.local\share\fm\frozen\complete.1.3.1.15_4.4.2\sealsetup.exe
if exist "%SealSetupInstaller%" (
  @if not exist c:\vagrant\resources\license.ini @echo No Inifile for PLOSSYS license.exe found at C:\vagrant\resources\license.ini, so you have to enter the password manually.
  schtasks /Delete /F /TN SealSetup
  schtasks /Create /SC ONCE /TN SealSetup /TR "C:\Chocolatey\bin\AutoIt3.bat C:\vagrant\shell\InstallSealSetup.au3 %SealSetupInstaller%" /ST 00:00
  schtasks /Run /TN SealSetup
)
