@echo off
:office_ver
setlocal enableDelayedExpansion
echo %~1 | find /i "help" >nul 2>&1 && ( goto :help )

for /f "tokens=2 delims==" %%O in ('ftype ^|findstr /r /I "\\OFFICE[0-9]*" 2^>nul') do (
    set "verp=%%~O"
    goto :end_for
)
:end_for
  
for %%P in ("%verp%") do (
    set "off_path=%%~dpP"
    for %%V in ("!off_path:~0,-1!") do (
 
     set "office_version=%%~nV"
     goto :end_for2
    )
)
:end_for2

echo internal version: %office_version%
echo %office_version% | find /i "office7" >nul 2>&1&& (
        echo "Office 97"
        if "%~1" neq "" ( endlocal & set "%~1=Office 97"
        exit /b 0
        )
)
echo %office_version% | find /i "office8" >nul 2>&1 && (
        echo "Office XP"
        if "%~1" neq "" ( endlocal & set "%~1=Office XP"
        exit /b 0
        )
)
echo %office_version% | find /i "office9" >nul 2>&1 && (
        echo "Office 2000"
        if "%~1" neq "" ( endlocal & set "%~1=Office 2000"
        exit /b 0
        )
)
echo %office_version% | find /i "office10" >nul 2>&1 && (
        echo "Office XP"
        if "%~1" neq "" ( endlocal & set "%~1=Office XP"
        exit /b 0
        )
)
echo %office_version% | find /i "office11" >nul 2>&1 && (
        echo "Office 2003"
        if "%~1" neq "" ( endlocal & set  "%~1=Office 2003"
        exit /b 0
        )
)
echo %office_version% | find /i "office12" >nul 2>&1 && (
        echo "Office 2007"
        if "%~1" neq "" ( endlocal & set "%~1=Office 2007"
        exit /b 0
        )
)
echo %office_version% | find /i "office14" >nul 2>&1 && (
        echo "Office 2010"
        if "%~1" neq ""  ( endlocal & set "%~1=Office 2010"
        exit /b 0
        )
)
echo %office_version% | find /i "office15" >nul 2>&1 && (
        echo "Office 2013"
        if "%~1" neq ""  ( endlocal & set "%~1=Office 2013"
        exit /b 0
        )
)

echo %office_version% | find /i "office16" >nul 2>&1 && (
        echo "Office 2016"
        if "%~1" neq ""  ( endlocal & set "%~1=Office 2016"
        exit /b 0
        )
)

endlocal
goto :eof
rem MAPPING:
rem Office 97   -  7.0
rem Office 98   -  8.0
rem Office 2000 -  9.0
rem Office XP   - 10.0
rem Office 2003 - 11.0
rem Office 2007 - 12.0
rem Office 2010 - 14.0
rem Office 2013 - 15.0
rem Office 2016 - 16.0
:help
echo %~n0 - displays current microsoft office version
echo %~n0 [RtnVar]
echo(
RtnVar - stores result in variable RtnVar
echo(
echo by Vasil "npocmaka" Arnaudov
