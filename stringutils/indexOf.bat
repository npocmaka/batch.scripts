:indexof [%1 - string ; %2 - find index of ; %3 - if defined will store the result in variable with same name]
::http://ss64.org/viewtopic.php?id=1687
@echo off
setlocal enableDelayedExpansion

set "str=%~1"
set "s=!str:%~2=&rem.!"
set s=#%s%
if "%s%" equ "#%~1" endlocal& if "%~3" neq "" (set %~3=-1&exit /b 0) else (echo -1&exit /b 0) 

  set "len=0"
  for %%A in (2187 729 243 81 27 9 3 1) do (
	set /A mod=2*%%A
	for %%Z in (!mod!) do (
		if "!s:~%%Z,1!" neq "" (
			set /a "len+=%%Z"
			set "s=!s:~%%Z!"
			
		) else (
			if "!s:~%%A,1!" neq "" (
				set /a "len+=%%A"
				set "s=!s:~%%A!"
			)
		)
	)
  )
  endlocal & if "%~3" neq "" (set %~3=%len%) else echo %len%
exit /b 0
