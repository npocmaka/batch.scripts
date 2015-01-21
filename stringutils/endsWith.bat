:endsWith [%1 - string to be checked;%2 - string for checking ]
::http://ss64.org/viewtopic.php?id=1687
@echo off
rem :: sets errorlevel to 1 if %1 ends with %2 else sets errorlevel to 0

setlocal EnableDelayedExpansion

set "string=%~1"
set "checker=%~2"
rem set "var=!string:%~2=&echo.!"
set LF=^


rem ** Two empty lines are required
rem echo off
for %%L in ("!LF!") DO (
 	for /f "delims=" %%R in ("!checker!") do ( 
 		rem set "var=!string:%%~R%%~R=%%~L!"
 		set "var=!string:%%~R=%%L#!"
 	)
)
for /f "delims=" %%P in (""!var!"") DO (
	set "temp=%%~P"
)
if "%temp%" EQU "#" goto :yes
goto :no
:yes
endlocal & verify set_error 2>nul
goto :eof
:no
endlocal & ( echo | shift )
goto :eof
