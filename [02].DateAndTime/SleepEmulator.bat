:: ===============================================================================================
:: @file            SleepEmulator.bat
:: @brief           Yet another sleep emulator working on everything from NT and above
:: @syntax          SleepEmulator.bat <delay>
:: @usage           SleepEmulator.bat 10
:: @description     The above call provides a 10 second delay.
:: @see             https://github.com/sebetci/batch.script/[02].DateAndTime/SleepEmulator.bat
:: @reference       https://www.robvanderwoude.com/wait.php   
:: @todo
:: ===============================================================================================

@ECHO OFF

:: If there isn't first parameter, exit the script.
IF "%~1"=="" GOTO :HELP

:: If the first parameter isn't a number, exit the script.
ECHO.%*| FINDSTR /R /X /C:"[0-9][0-9]*" >NUL 2>NUL || GOTO :HELP

:: If the first parameter is less than 0, exit the script.
IF %~1 LSS  0 GOTO :HELP
         
:: The "typeperf" command writes performance counter data to the command window or to a supported log file format.
TYPEPERF "\SYSTEM\PROCESSOR QUEUE LENGTH" -SI %~1 -SC 1 >NUL
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function prints the help menu on the screen.
:: @parameter  None
:: @return     None
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:HELP
    ECHO Program Name: %~N0
    ECHO Description: Wait for a specifier number of seconds
    ECHO Syntax: SleepEmulator.bat ^<delay^>
    EXIT /B 0