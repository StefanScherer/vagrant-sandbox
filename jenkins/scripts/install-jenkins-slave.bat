rem @echo off
echo Ensuring .NET 4.0 is installed
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/StefanScherer/arduino-ide/install/InstallNet4.ps1'))"
echo Installing Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%SystemDrive%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst
call cinst git
call cinst javaruntime
call cinst wget
set JENKINSHOST=192.168.33.214
call wget http://%JENKINSHOST%:8080/jnlpJars/slave.jar
where java

java -jar slave.jar -jnlpUrl http://%JENKINSHOST%:8080/computer/slave1/slave-agent.jnlp
where javaws
rem javaws http://%JENKINSHOST%:8080/computer/slave1/slave-agent.jnlp

