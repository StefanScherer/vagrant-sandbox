rem set timezone to Berlin
tzutil /s "W. Europe Standard Time"

call :heredoc html >%TEMP%\german.xml && goto next2
<!-- from http://msdn.microsoft.com/en-ie/goglobal/bb964650(en-us).aspx -->
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend">

  <gs:UserList>
    <gs:User UserID="Current" CopySettingsToSystemAcct="true" /> 
  </gs:UserList>

  <gs:InputPreferences> 
    <gs:InputLanguageID Action="add" ID="0409:00000409"/> 
    <gs:InputLanguageID Action="add" ID="0407:00000407" Default="true"/> 
  </gs:InputPreferences> 

  <gs:LocationPreferences> 
    <gs:GeoID Value="94"/> 
  </gs:LocationPreferences>

</gs:GlobalizationServices>
:next2
echo on

control intl.cpl,, /f:"%TEMP%\german.xml"

goto :EOF


::########################################
::## Here's the heredoc processing code ##
::########################################
:heredoc <uniqueIDX>
@echo off
setlocal enabledelayedexpansion
set go=
for /f "delims=" %%A in ('findstr /n "^" "%~f0"') do (
  set "line=%%A" && set "line=!line:*:=!"
  if defined go (if #!line:~1!==#!go::=! (goto :EOF) else echo(!line!)
  if "!line:~0,13!"=="call :heredoc" (
    for /f "tokens=3 delims=>^ " %%i in ("!line!") do (
      if #%%i==#%1 (
        for /f "tokens=2 delims=&" %%I in ("!line!") do (
          for /f "tokens=2" %%x in ("%%I") do set "go=%%x"
        )
      )
    )
  )
)
goto :EOF
