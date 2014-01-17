rem @echo off
echo Ensuring .NET 4.0 is installed
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.github.com/StefanScherer/arduino-ide/install/InstallNet4.ps1'))"
where cinst
if ERRORLEVEL 1 (
  echo Installing Chocolatey
  @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin
)

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%SystemDrive%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

call cinst vim

where java
if ERRORLEVEL 1 call cinst jdk7
rem it is reproducible that first cinst jdk7 fails, so try again if java is still not in path
where java
if ERRORLEVEL 1 call cinst jdk7
where java
if ERRORLEVEL 1 call cinst jdk7

where wget
if ERRORLEVEL 1 call cinst wget

if not exist c:\jenkins mkdir c:\jenkins

type c:\vagrant\resources\jenkins-host.txt >> c:\Windows\System32\drivers\etc\hosts
for /f "tokens=2" %%i in ('findstr 1 c:\vagrant\resources\jenkins-host.txt') do set jenkinshost=%%i

if not exist c:\jenkins\swarm-client.jar (
  copy /y c:\vagrant\resources\swarm-client.jar c:\jenkins
)

rem set Internet Explorer start page to jenkins
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://%jenkinshost%" /f

rem Due to problems with UDP broadcast, use the -master switch at the moment
rem Schedule start of swarm client at start of the machine (after next reboot)
schtasks /CREATE /SC ONSTART /RU vagrant /RP vagrant /TN JenkinsSwarmClient /TR "java.exe -jar c:\jenkins\swarm-client.jar -master http://%jenkinshost% -labels windows -fsroot c:\jenkins"

