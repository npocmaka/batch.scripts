:: ===============================================================================================
:: @file            W32TMSleep.bat
:: @brief           Yet another sleep emulator working on everything from NT and above
:: @syntax          W32TMSleep.bat <delay in millisecond>
:: @usage           W32TMSleep.bat 10
:: @description     The above call provides a 10 second delay.
:: @see             https://github.com/sebetci/batch.script/[02].DateAndTime/W32TMSleep.bat
:: @reference       https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/ff799054(v=ws.11)
:: @reference       https://en.wikipedia.org/wiki/W32tm   
:: @todo
:: ===============================================================================================

@ECHO OFF

:: If there isn't first parameter, exit the script.
IF "%~1"=="" GOTO :HELP

:: If the first parameter isn't a number, exit the script.
ECHO.%*| FINDSTR /R /X /C:"[0-9][0-9]*" >NUL 2>NUL || GOTO :HELP

:: If the first parameter is less than 0, exit the script.
IF %~1 LSS  0 GOTO :HELP
 
SETLOCAL
    SET /A VAdjust=%~1/2+1

    :: In computing, W32TM is a command-line tool of Microsoft Windows operating systems used
    :: to diagnose problems occurring with time setting or to troubleshoot any problems that might 
    :: occur during or after the configuration of the Windows Time service.
    W32TM /STRIPCHART /COMPUTER:LOCALHOST /PERIOD:1 /DATAONLY /SAMPLES:%VAdjust% >NUL 2>&1
ENDLOCAL
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function prints the help menu on the screen.
:: @parameter  None
:: @return     None
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:HELP
    ECHO Program Name: %~N0
    ECHO Description: Wait for a specifier number of seconds
    ECHO Syntax: W32TMSleep.bat ^<delay^>
    EXIT /B 0