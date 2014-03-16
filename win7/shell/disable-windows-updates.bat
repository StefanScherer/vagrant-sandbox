rem http://www.windows-commandline.com/disable-automatic-updates-command-line/
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f  
sc config wuauserv start= disabled
net stop wuauserv
