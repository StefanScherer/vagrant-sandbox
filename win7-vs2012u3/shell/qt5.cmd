

if not exist "c:\vagrant\resources\QtCommercial\Qt5.1.1\DistLicenseFile.txt" goto QTDONE
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\Qt5\Set-ShortCut.ps1"

call c:\vagrant\shell\Qt5\install-qt5.bat -schedule 5.1.1 msvc2012


:QTDONE
