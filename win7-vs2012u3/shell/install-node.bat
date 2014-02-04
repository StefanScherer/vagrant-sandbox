rem call cinst nodejs.commandline
call cinst nodejs.install
call cinst curl
call cinst Yeoman
call cinst SublimeText3
call cinst GoogleChrome
powershell powershell -NoProfile -ExecutionPolicy Bypass -File %~dp0\PinChrome.ps1
call cinst gb.MongoDB 
