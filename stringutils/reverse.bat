:reverse [%1 - string to reverse ; %2 - if defined will store the result in variable with same name]
@echo off
setlocal disableDelayedExpansion
set "str=%~1"
set LF=^


rem ** Two empty lines are required
set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
set $strLen=for /L %%n in (1 1 2) do if %%n==2 (%\n%
      for /F "tokens=1,2 delims=, " %%1 in ("!argv!") do (%\n%
         set "str=A!%%~2!"%\n%
           set "len=0"%\n%
           for /l %%A in (12,-1,0) do (%\n%
             set /a "len|=1<<%%A"%\n%
             for %%B in (!len!) do if "!str:~%%B,1!"=="" set /a "len&=~1<<%%A"%\n%
           )%\n%
           for %%v in (!len!) do endlocal^&if "%%~b" neq "" (set "%%~1=%%v") else echo %%v%\n%
      ) %\n%
) ELSE setlocal enableDelayedExpansion ^& set argv=,

%$strLen% len,str
setlocal enableDelayedExpansion

set /a half=len/2
set "res=!str:~%half%,-%half%!"

for /L %%C in (%half%,-1,0) do (
	set /a len=%len%-1-%%C
	if %%C neq %half% (
		for  %%c in (!len!) do (			
			set "res=!str:~%%c,1!!res!!str:~%%C,1!"
		)
	)

)
endlocal & endlocal & if "%~2" NEQ "" (set %~2=%res%) else echo %res%
