:lastindexof [%1 - string ; %2 - find last index of ; %3 - if defined will store the result in variable with same name]
::http://ss64.org/viewtopic.php?id=1687
@echo off
setlocal enableDelayedExpansion 


set "str=%~1"
set "splitter=%~2"

set LF=^


rem ** Two empty lines are required
echo off
for %%L in ("!LF!") DO (
	for /f "delims=" %%R in ("!splitter!") do ( 
		set "var=!str:%%R=%%L!"
	)
)

for /f  delims^=^" %%P in ("!var!") DO ( 
	set "last_part=%%~P"  
)

if "!last_part!" equ ""  if "%~3" NEQ "" (
 echo "not contained" >2 
 endlocal
 set %~3=-1 
 exit
) else (
 echo "not contained" >2 
 endlocal
 echo -1 
)
setlocal DisableDelayedExpansion

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


%$strlen% strlen,str
%$strlen% plen,last_part
%$strlen% slen,splitter

set /a lio=strlen-plen-slen
endlocal & if "%~3" NEQ "" (set %~3=%lio%) else echo %lio%
exit /b 0
