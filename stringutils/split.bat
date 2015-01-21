:split [%1 - string to be splitted;%2 - split by;%3 - possition to get; %4 - if defined will store the result in variable with same name]
::http://ss64.org/viewtopic.php?id=1687

setlocal EnableDelayedExpansion

set "string=%~2%~1"
set "splitter=%~2"
set /a position=%~3

set LF=^


rem ** Two empty lines are required
echo off
for %%L in ("!LF!") DO (
	for /f "delims=" %%R in ("!splitter!") do ( 
		set "var=!string:%%~R%%~R=%%~L!"
		set "var=!var:%%~R=%%~L!"
		if "!var!" EQU "!string!" (
		 	echo "%~1" does not contain "!splitter!" >&2
		 	exit /B 1
		)
	)
)

if "!var!" equ "" (
	endlocal & if "%~4" NEQ "" ( set "%~4=")
)
if !position! LEQ 0 ( set "_skip=" ) else (set  "_skip=skip=%position%")

for /f  "eol= %_skip% delims=" %%P in (""!var!"") DO (
	
	if "%%~P" neq "" ( 
		set "part=%%~P" 
		goto :end_for 
	)
)
set "part="
:end_for
if not defined part (
 endlocal
 echo Index Out Of Bound >&2 
 exit /B 2
)
endlocal & if "%~4" NEQ "" (set %~4=%part%) else echo %part%
exit /b 0
