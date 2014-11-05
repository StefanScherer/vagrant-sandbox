powershell -STA -file %~dp0setusertile.ps1 vagrant %~dp0..\images\vagrant.jpg

powershell -NoProfile -ExecutionPolicy unrestricted -file %~dp0install-win-languages.ps1

call :addUser bg vagrant bg-BG bg.jpg
call :addUser da vagrant da-DK da.jpg
call :addUser de vagrant de-DE de.jpg
call :addUser es vagrant es-ES es.jpg
call :addUser en vagrant en-US en-US.jpg
call :addUser fr vagrant fr-FR fr.jpg
call :addUser it vagrant it-IT it.jpg
call :addUser nl vagrant nl-NL nl.jpg
call :addUser pl vagrant pl-PL pl.jpg
call :addUser ro vagrant ro-RO ro.jpg

:addUser
net user %1 %2 /add
psexec -accepteula -u %1 -p %2 reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "%3" /f
echo  %~dp0..\images\%4
powershell -STA -file %~dp0setusertile.ps1 %1 %~dp0..\images\%4
goto :eof
