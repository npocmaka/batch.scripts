:: http://www.dostips.com/forum/viewtopic.php?f=3&t=3803&start=15
:: http://stackoverflow.com/questions/31987023/why-call-prints-the-goto-help-message-in-this-scriptand-why-command-after-that
::
:: In the link to the stackoverflow question I've accidentally found that when CALL is used
:: against label it internaly uses GOTO function (and thanks to the jeb's analysis)
::
:: With double expansion and ':/?' argument I'm able to mislead the CALL command that a function /? is called without
:: actually such label exists.I've submited the technique in the dostips forum and it was refined by dbenham.
:: The technique pretty well covers the definition of anonymous function.
::
:: With bigger scripts (over 50 lines) this can be performance booster as the GOTO does not parse the script.


@echo off
setlocal 
set "anonymous=/?"

rem simpliest case
call :%%anonymous%% a b c 3>&1 >nul
if "%0" == ":%anonymous%" (
  echo Anonymous called
  exit /b 0
)>&3


rem example with code block ecnlosed with brackets
echo Before anonymous call:
echo %%1=%1 %%2=%2 %%3=%3 

for /l %%N in (1 1 5) do (
  set /a N=%%N*2
  call :%%anonymous%% a b c 3>&1 >nul
  echo ---
)
if "%0" == ":%anonymous%" (
  echo(
  echo Anonymous call:
  echo %%1=%1 %%2=%2 %%3=%3  N=%N% 
  exit /b 0
)>&3

echo(
echo After anonymous call:
echo %%1=%1 %%2=%2 %%3=%3 


