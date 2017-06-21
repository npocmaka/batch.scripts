:startsWith [%1 - string to be checked;%2 - string for checking ] 
@echo off
rem :: sets errorlevel to 1 if %1 starts with %2 else sets errorlevel to 0

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
 		set "var=!string:%%~R=#%%L!"
 	)
)
for /f "delims=" %%P in (""!var!"") DO (
	if "%%~P" EQU "#" (
		endlocal & exit /b 1
	) else (
		endlocal & exit /b 0
	)
)
