reg add "HKCU\Control Panel\Desktop" /v Wallpaper /d "" /f
reg add "HKCU\Control Panel\Desktop" /v ImageColor /t REG_DWORD /d 3305111551 /f
reg add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "70 70 70" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
