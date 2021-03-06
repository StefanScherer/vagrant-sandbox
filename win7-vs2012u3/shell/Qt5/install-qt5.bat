title %~n0 %1
if "%1x"=="-schedulex" (
  set SCHEDULE=1
  shift
)
if "%1x"=="x" goto NO_QT5_VERSION
if "%2x"=="x" goto NO_COMPILER_VERSION
where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%ALLUSERSPROFILE%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst
cd /D %ChocolateyInstall%

if exist %ChocolateyInstall%\bin\7za.bat goto ZIP_INSTALLED
call cinst 7zip.commandline -force
:ZIP_INSTALLED

if exist C:\chocolatey\bin\autoit3.bat goto AUTOIT_INSTALLED
call cinst autoit.commandline -force
:AUTOIT_INSTALLED

if exist C:\strawberry goto PERL_INSTALLED
call cinst StrawberryPerl
:PERL_INSTALLED

if exist %ChocolateyInstall%\bin\jom.bat goto JOM_INSTALLED
call cinst jom
:JOM_INSTALLED

if exist %ChocolateyInstall%\bin\cmake.bat goto CMAKE_INSTALLED
call cinst cmake
:CMAKE_INSTALLED

if "%SCHEDULE%x"=="1x" (
  schtasks /Delete /F /TN InstQt5
  schtasks /Create /SC ONCE /TN InstQt5 /TR "c:\vagrant\shell\Qt5\install-qt5.bat %1 %2" /ST 00:00
  schtasks /Run /TN InstQt5
  goto :EOF
)

if exist %USERPROFILE%\.qt-license goto QTLIC_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\DistLicenseFile.txt" goto NO_QTLIC
echo Licensing Qt5
copy "%~dp0\..\..\resources\QtCommercial\Qt%1\DistLicenseFile.txt" %USERPROFILE%\.qt-license
:QTLIC_INSTALLED

if exist "%ProgramFiles(x86)%\Digia\Qt5VSAddin" goto QT5ADDIN_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-vs-addin-1.2.2.exe" goto QT5ADDIN_INSTALLED
echo Installing Qt5 VS AddIn interactively
call AutoIt3 %~dp0\install-qt-vs-addin.au3 "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-vs-addin-1.2.2.exe"
:QT5ADDIN_INSTALLED

if exist c:\Qt\Qt%1 goto QT5_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-enterprise-%1-windows-%2-x86_64-offline.exe" goto QT5_CHECK_2ND
echo Installing Qt%1 %2 interactively
call autoit3 %~dp0\install-qt-enterprise.au3 \\VBOXSVR\vagrant\resources\QtCommercial\Qt%1\qt-enterprise-%1-windows-%2-x86_64-offline.exe %1

powershell -NoProfile -ExecutionPolicy Bypass -File %~dp0\PinQtCreator.ps1 %1
goto QT5_INSTALLED
:QT5_CHECK_2ND
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-enterprise-windows-%2-x86_64-%1.exe" goto QT5_INSTALLED
echo Installing Qt%1 %2 interactively
call autoit3 %~dp0\install-qt-enterprise.au3 \\VBOXSVR\vagrant\resources\QtCommercial\Qt%1\qt-enterprise-windows-%2-x86_64-%1.exe %1

powershell -NoProfile -ExecutionPolicy Bypass -File %~dp0\PinQtCreator.ps1 %1

:QT5_INSTALLED

if not exist C:\Qt\Qt%1\%1\Src goto SRC_ZIPPED
if exist C:\Qt\Qt%1\%1\Src.zip goto SRC_ZIPPED
echo Zipping Src for faster rebuild
cd /D C:\Qt\Qt%1\%1
call 7za a Src.zip Src >nul
:SRC_ZIPPED

if exist C:\vagrant\resources\QtCommercial\Qt%1\%2_64_static.zip (
  cd /D C:\Qt\Qt%1\%1
  echo Extracting C:\vagrant\resources\QtCommercial\Qt%1\%2_64_static.zip
  call 7za x -y C:\vagrant\resources\QtCommercial\Qt%1\%2_64_static.zip >nul
) else (
  echo Starting Qt5 64bit compile in second window
  echo start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 amd64 %2_64_static >C:\Qt\Qt%1\%1\make_%2_64_static.bat
  start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 amd64 %2_64_static
)

if exist C:\vagrant\resources\QtCommercial\Qt%1\%2_32_static.zip (
  cd /D C:\Qt\Qt%1\%1
  echo Extracting C:\vagrant\resources\QtCommercial\Qt%1\%2_32_static.zip
  call 7za x -y C:\vagrant\resources\QtCommercial\Qt%1\%2_32_static.zip >nul
) else (
  echo Starting Qt5 32bit compile in second window
  echo start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 x86 %2_32_static >C:\Qt\Qt%1\%1\make_%2_32_static.bat
  start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 x86 %2_32_static
)

goto nowait

:NO_QT5_VERSION
echo No Qt5 version given, eg. 5.1.0
goto wait

:NO_COMPILER_VERSION
echo No MSVC compiler version given, eg. msvc2012
goto wait


:NO_QTLIC
@cls
@echo You need a valid Qt5 license file to install and compile Qt%1
@echo.
@echo Files needed:
@echo.
@echo C:\vagrant\resources\QtCommercial\Qt%1\DistLicenseFile.txt
@echo C:\vagrant\resources\QtCommercial\Qt%1\qt-vs-addin-1.2.2.exe
@echo C:\vagrant\resources\QtCommercial\Qt%1\qt-enterprise-%1-windows-%2-x86_64-offline.exe

:wait
time /t
pause
:nowait
schtasks /Delete /F /TN InstQt5
