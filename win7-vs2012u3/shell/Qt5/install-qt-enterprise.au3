If $CmdLine[0] = 0 Then
   Exit
EndIf

; CmdLine[1] = "\\VBOXSVR\vagrant\resources\QtCommercial\Qt5.1.1\qt-enterprise-5.1.1-windows-msvc2012-x86_64-offline.exe"
Run($CmdLine[1])
WinWait("Qt Enterprise")
Sleep(500)
WinActivate("Qt Enterprise")
; Welcome
Sleep(2000)
Send("!n") ; Next

; Installation Folder
Sleep(1000)
Send("!n") ; Next

; Select Components
Sleep(1000)
Send("{DOWN}{RIGHT}{DOWN}{DOWN}{SPACE}") ; Select source code
Send("!n") ; Next

; License Agreement
Sleep(1000)
Send("!a") ; Accept license
Sleep(1000)
Send("!n") ; Next

; Menu Short Cuts
Sleep(1000)
Send("!n") ; Next

; Ready For Install
Sleep(1000)
Send("!i") ; Install

; CmdLine[2] = 5.1.1  or 5.2.0 or ...
$IniFile = "C:\Qt\Qt" & $CmdLine[2] & "\MaintenanceTool.ini"
While Not FileExists($IniFile)
   Sleep(2000)
WEnd
Sleep(15000)

; Completing the Wizard
Send("{TAB}{SPACE}{TAB}{SPACE}") ; turn off "Launch Qt Creator" and "Open Qt 5.1.1 ReadMe"
Send("!f") ; Finish
