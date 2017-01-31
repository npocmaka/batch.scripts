@echo off
:checkCountOf string countOf [rtnrVar]
:: checks count of a substring  in a string 
setlocal EnableDelayedExpansion
set "string=aa"

set "string=%~1"
set "checkCountOf=%~2"

if "%~1" equ "" (
	if "%~3" neq "" (
		endlocal & (
		   echo 0
		   set "%~3=0"
		   exit /b 0
		)
	) else (
		endlocal & (
		   echo 0
		   exit /b 0
		)
)


)

if "!checkCountOf!" equ "$" (
	set "string=#%string%#"
	set "string=!string:%checkCountOf%%checkCountOf%=#%checkCountOf%#%checkCountOf%#!"
) else (
	set "string=$%string%$"
	set "string=!string:%checkCountOf%%checkCountOf%=$%checkCountOf%$%checkCountOf%$!"
)


set LF=^


rem ** Two empty lines are required
set /a counter=0


for %%L in ("!LF!") DO (
	for /f "delims=" %%R in ("!checkCountOf!") do ( 
        set "var=!string:%%~R%%~R=%%~L!"
        set "var=!var:%%~R=%%~L!"
		
		for /f "tokens=* delims=" %%# in ("!var!") do (
		 	set /a counter=counter+1
		)
	)
)

if !counter! gtr 0 (
	set /a counter=counter-1
)

if "%~3" neq "" (
	endlocal & (
	   echo %counter%
	   set "%~3=%counter%"
	)
) else (
	endlocal & (
	   echo %counter%
	)
)
