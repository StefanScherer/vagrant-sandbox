rem Rename the slave to slave1 and reboot windows
if "%COMPUTERNAME%"=="slave1" goto renamed
netdom renamecomputer . /NewName:slave1  /force
shutdown /r /t 5
:renamed

