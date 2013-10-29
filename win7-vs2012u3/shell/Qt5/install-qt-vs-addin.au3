If $CmdLine[0] = 0 Then
   Exit
EndIf

; "C:\vagrant\resources\QtCommercial\Qt5.1.1\qt-vs-addin-1.2.2.exe"
Run($CmdLine[1])
WinWaitActive("Qt5 Visual Studio Add-in")
; Welcome
Send("!n") ; Next

; License Agreement
Send("!a") ; accept license
Send("!n") ; Next

; Choose Components
Send("!n") ; Next

; Choose Install Location
Send("!i") ; Install

WinWaitActive("Qt5 Visual Studio Add-in", "Installation Complete");
Send("!n") ; Next
Send("!f") ; Finish
