powershell -NoProfile -ExecutionPolicy unrestricted -file %~dp0install-win-languages.ps1

net user bg vagrant /add
call psexec -accepteula -u bg -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "bg-BG" /f

net user da vagrant /add
call psexec -accepteula -u da -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "da-DK" /f

net user de vagrant /add
call psexec -accepteula -u de -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "de-DE" /f

net user es vagrant /add
call psexec -accepteula -u es -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "es-ES" /f

net user en vagrant /add
call psexec -accepteula -u en -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "en-US" /f

net user fr vagrant /add
call psexec -accepteula -u fr -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "fr-FR" /f

net user it vagrant /add
call psexec -accepteula -u it -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "it-IT" /f

net user nl vagrant /add
call psexec -accepteula -u nl -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "nl-NL" /f

net user pl vagrant /add
call psexec -accepteula -u pl -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "pl-PL" /f

net user ro vagrant /add
call psexec -accepteula -u ro -p vagrant reg add "HKCU\Control Panel\Desktop" /v PreferredUILanguages /t REG_MULTI_SZ /s , /d "ro-RO" /f

