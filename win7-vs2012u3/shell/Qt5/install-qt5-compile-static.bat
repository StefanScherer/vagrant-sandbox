title %~n0 %1 %2 %3 %4
if "%1x"=="x" goto NO_QT5_VERSION
if "%2x"=="x" goto NO_COMPILER_VERSION
if "%3x"=="x" goto NO_PLATFORM
if "%4x"=="x" goto NO_QT5_PREFIX

echo Qt5 %4 compile
call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" %3
echo on

if not exist C:\Qt\Qt%1\%1\Src.zip goto COMPILED
cd /D C:\Qt\Qt%1\%1

if exist C:\Qt\Qt%1\%1\%4 goto COMPILED
echo Deleting Src
del /F /S /Q Src\ >nul
echo Extracting Src.zip
call 7za x Src.zip >nul
xcopy "%~dp0\win32-%2-static" C:\Qt\Qt%1\%1\Src\qtbase\mkspecs\win32-%2\ /s /e /i /h /y
:MKSPEC_INSTALLED

cd /D C:\Qt\Qt%1\%1\Src\qtbase
if exist c:\chocolatey\lib\jom.1.0.13\content\jom.exe set PATH=c:\chocolatey\lib\jom.1.0.13\content;%PATH%
configure.exe -prefix C:\Qt\Qt%1\%1\%4 -commercial -confirm-license -nomake tests -debug-and-release -no-opengl -no-icu -no-angle -no-sql-sqlite -no-freetype -make-tool jom -no-dbus -static
call jom
rem http://qt-project.org/wiki/Building_Qt_Documentation
cd src
call jom sub-qdoc
cd ..\..\qttools
..\qtbase\bin\qmake
call jom
call jom install
if not exist C:\Qt\Qt%1\%1\%2_64\bin goto SKIP_PATCH_QHELPGEN
rem install shared version of qhelpgenerator because static build does not have SQLite plugin
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Core.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\qhelpconverter.exe "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\qhelpgenerator.exe "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Help.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5CLucene.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Widgets.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Gui.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Network.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\Qt5Sql.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\libGLESv2.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\icudt51.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\icuin51.dll "C:\Qt\Qt%1\%1\%4\bin\"
copy /Y C:\Qt\Qt%1\%1\%2_64\bin\icuuc51.dll "C:\Qt\Qt%1\%1\%4\bin\"
:SKIP_PATCH_QHELPGEN
cd ..\qtbase
call jom docs
call jom install
call jom install_mkspecs
call jom install_global_docs
call jom install_docs
echo "%~dp0\install-qt5-compile-static-patch-prf.pl"
c:\strawberry\perl\bin\perl.exe "%~dp0\install-qt5-compile-static-patch-prl.pl" "C:\Qt\Qt%1\%1\%4" %4

:COMPILED
echo Updating Registry

call :regquery HKCU\Software\Digia\Qt5VS2012 QtVersionLastSelectedPath
if not defined REGDATA call :initreg %*

call :regquery HKCU\Software\Digia\Versions\Qt%1_%4 InstallDir
if not defined REGDATA call :regadd HKCU\Software\Digia\Versions\Qt%1_%4 InstallDir REG_SZ C:\Qt\Qt%1\%1\%4

echo Done.
goto nowait


:initreg
call :regaddkey HKCU\Software\Digia
call :regaddkey HKCU\Software\Digia\Qt5VS2012
call :regadd    HKCU\Software\Digia\Qt5VS2012 QtVersionLastSelectedPath REG_SZ C:\Qt\Qt%1\%1\Qt%1_%4
call :regadd    HKCU\Software\Digia\Qt5VS2012 MocDir                    REG_SZ .\GeneratedFiles\$(ConfigurationName)
call :regadd    HKCU\Software\Digia\Qt5VS2012 MocOptions                REG_SZ ""
call :regadd    HKCU\Software\Digia\Qt5VS2012 UicDir                    REG_SZ .\GeneratedFiles
call :regadd    HKCU\Software\Digia\Qt5VS2012 RccDir                    REG_SZ .\GeneratedFiles
call :regadd    HKCU\Software\Digia\Qt5VS2012 lupdateOnBuild            REG_DWORD 00000000
call :regadd    HKCU\Software\Digia\Qt5VS2012 lupdateOptions            REG_SZ ""
call :regadd    HKCU\Software\Digia\Qt5VS2012 lreleaseOptions           REG_SZ ""
call :regadd    HKCU\Software\Digia\Qt5VS2012 askBeforeCheckoutFile     REG_DWORD 00000001
call :regadd    HKCU\Software\Digia\Qt5VS2012 disableCheckoutFiles      REG_DWORD 00000000
call :regadd    HKCU\Software\Digia\Qt5VS2012 disableAutoMocStepsUpdate REG_DWORD 00000000
call :regaddkey HKCU\Software\Digia\Versions
call :regadd    HKCU\Software\Digia\Versions DefaultQtVersion           REG_SZ Qt%1_%4
call :regadd    HKCU\Software\Digia\Versions WinCEQtVersion             REG_SZ ""
exit /b

:regaddkey
reg add %1
exit /b

:regadd
reg add %1 /v %2 /t %3 /d %4
exit /b

:regquery
set REGDATA=
for /f "tokens=2,*" %%a in ('reg query %1 /v %2 ^| findstr %2') do (
    set REGDATA=%%b
)
exit /b


:NO_QT5_VERSION
echo No Qt5 version given, eg. 5.1.0
goto wait

:NO_COMPILER_VERSION
echo No MSVC compiler version given, eg. msvc2012
goto wait

:NO_PLATFORM
echo No platform given, eg. amd64 or x86
goto wait

:NO_QT5_PREFIX
echo No Qt5 target prefix iven, eg. msvc2012_64_static
goto wait


:wait
time /t
pause

:nowait
time /t
rem pause
