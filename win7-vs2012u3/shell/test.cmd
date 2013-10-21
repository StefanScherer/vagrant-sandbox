if exist "%SystemDrive%\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe" goto provisioned

powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadFile('http://download.microsoft.com/download/4/1/5/41524F91-4CEE-416B-BB70-305756373937/rtools_setup_x64.exe','%Temp%\rtools_setup_x64.exe'))"

%Temp%\rtools_setup_x64.exe /install /passive /quiet /norestart /log %Temp%\log.txt

cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="Remote Debugger (x64)" dir=in action=allow program="%SystemDrive%\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe" enable=yes
cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="Remote Debugger (x86)" dir=in action=allow program="%SystemDrive%\Program Files\Microsoft Visual Studio 11.0\Common7\IDE\Remote Debugger\x86\msvsmon.exe" enable=yes

:provisioned
sc config "msvsmon110" start= auto

net start msvsmon110

