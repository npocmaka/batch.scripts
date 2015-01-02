@echo off
:: yet another sleep emulator working on everything from NT and above
if   "%~1"=="" goto :help
ECHO.%*| FINDSTR /R /X /C:"[0-9][0-9]*" >NUL || goto :help
IF %~1 LSS  0 goto :help
 
setLocal
        set /a adj=%~1/2+1
        w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:%adj% >nul 2>&1
endLocal
 
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
echo.
echo.
echo  by Vasil "npocmaka" Arnaudov
