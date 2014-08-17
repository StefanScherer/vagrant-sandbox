echo 'Ensuring .NET 4.0 is installed'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallNet4.ps1"

echo 'Ensuring Chocolatey is Installed'
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallChocolatey.ps1"

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%ALLUSERSPROFILE%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

call cinst sysinternals


schtasks /Delete /F /TN InstLanguages
schtasks /Create /SC ONCE /TN InstLanguages /TR "c:\vagrant\shell\install-win-languages.bat" /ST 00:00
schtasks /Run /TN InstLanguages

rem schtasks /Query /FO list /TN InstLanguages
rem ...
rem Status:    Running
rem ...

