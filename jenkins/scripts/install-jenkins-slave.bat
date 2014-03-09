rem @echo off


rem set timezone to Berlin
tzutil /s "W. Europe Standard Time"

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
if ERRORLEVEL 1 call cinst java.jdk

where wget
if ERRORLEVEL 1 call cinst wget

if not exist c:\jenkins mkdir c:\jenkins

if exist c:\vagrant\resources\jenkins-host (
  type c:\vagrant\resources\jenkins-host.txt >> c:\Windows\System32\drivers\etc\hosts
  for /f "tokens=2" %%i in ('findstr 1 c:\vagrant\resources\jenkins-host.txt') do set jenkinshost=%%i

  rem set Internet Explorer start page to jenkins
  reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://%jenkinshost%" /f
)

if not exist c:\jenkins\swarm-client.jar (
  if exist c:\vagrant\resources\swarm-client.jar (
    copy c:\vagrant\resources\swarm-client.jar c:\jenkins\swarm-client.jar
  ) else (
    call wget -O c:\jenkins\swarm-client.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.15/swarm-client-1.15-jar-with-dependencies.jar
  )
)

rem Schedule start of swarm client at start of the machine (after next reboot)
schtasks /CREATE /TN JenkinsSwarmClient /RU vagrant /RP vagrant /XML "c:\vagrant\scripts\JenkinsSwarmClient.xml"
