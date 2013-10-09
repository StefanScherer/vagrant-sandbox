$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\install-qt5-and-compile-static.lnk")
$Shortcut.TargetPath = '\\VBOXSVR\vagrant\shell\Qt5\install-qt5-compile-again.bat'
$Shortcut.Save()
