@echo off
:: yet another sleep emulator working on everything from NT and above
if   "%~1"=="" goto :help
ECHO.%*| FINDSTR /R /X /C:"[0-9][0-9]*" >NUL 2>NUL || goto :help
IF %~1 LSS  0 goto :help
         
typeperf "\System\Processor Queue Length" -si %~1 -sc 1 >nul

goto :eof
:help
echo.
echo %~n0
echo Sleep emulator
echo Wait for a specified number of seconds.
echo.
echo Usage:  CALL  %~n0  seconds
echo.
echo seconds  -  seconds to wait
