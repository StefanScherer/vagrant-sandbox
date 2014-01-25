rem Reboot if windows hostname does not begin with SLAVE
if "%COMPUTERNAME:~0,5%"=="SLAVE" goto renamed
shutdown /r /t 5 /c "Reboot to rename slave"
:renamed

