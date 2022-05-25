:: ===============================================================================================
:: @file            W32DOW.bat
:: @brief           Prints the day of the week 
:: @syntax          W32DOW.bat
:: @usage           
:: @description     
:: @see             https://github.com/sebetci/batch.script/[02].DateAndTime/W32DOW.bat
:: @reference       https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/ff799054(v=ws.11)
:: @reference       https://en.wikipedia.org/wiki/W32tm
:: @todo
:: ===============================================================================================

@ECHO OFF
SETLOCAL
    :: Getting ANSI Date (Days passed from 1st Jan 1601), Timer Server Hour and Current Hour
    :: In computing, W32TM is a command-line tool of Microsoft Windows operating systems used
    :: to diagnose problems occurring with time setting or to troubleshoot any problems that might 
    :: occur during or after the configuration of the Windows Time service.
    FOR /F "SKIP=16 TOKENS=4,5 DELIMS=:(" %%D IN ('W32TM /STRIPCHART /COMPUTER:LOCALHOST  /SAMPLES:1  /PERIOD:1 /DATAONLY /PACKETINFO') DO (
        SET "VANSIDate=%%D"
        ECHO [DEBUG:MAIN] ANSI Date: %VANSIDate%

        SET "VTimeServerHours=%%E"
        ECHO [DEBUG:MAIN] Time Server Hours: %VTimeServerHours%

        GOTO :FENDFOR
    )

:FENDFOR
    ECHO [DEBUG:ENDFOR] Time: %TIME%
    SET  "VLocalHours=%TIME:~0,2%"

    IF "%VTimeServerHours:~0,1%0" EQU "00" SET VTimeServerHours=%VTimeServerHours:~1,1%
    ECHO [DEBUG:ENDFOR] Time Server Hours: %VTimeServerHours%

    IF "%VLocalHours:~0,1%0" EQU "00" SET VLocalHours=%VLocalHours:~1,1%
    ECHO [DEBUG:ENDFOR] Local Hours: %VLocalHours%

    SET /A VOffset=VTimeServerHours-VLocalHours
    ECHO [DEBUG:ENDFOR] Offset: %VOffset%

    :: Day of the week will be the modulus of 7 of local ANSI date +1.
    :: We need +1 because monday will be calculated as 0. 1st Jan 1601 was monday.
    :: If ABS(VOffset)>12 we are in different days with the time server.
    IF %VOffset%0 GTR 120 SET /A DOW=(VANSIDate+1)%%7+1
    IF %VOffset%0 LSS -120 SET /A DOW=(VANSIDate-1)%%7+1
    IF %VOffset%0 LEQ 120 IF %VOffset%0 GEQ -120 SET /A DOW=VANSIDate%%7+1

    ECHO DAY OF THE WEEK: %DOW%
    EXIT /B 2147483648
ENDLOCAL