@echo off
setlocal
rem :: prints the day of the week
rem :: works on Vista and above
rem :: by Vasil "npocmaka" Arnaudov
 
        rem :: getting ansi date ( days passed from 1st jan 1601 ) , timer server hour and current hour
        FOR /F "skip=16 tokens=4,5 delims=:( " %%D in ('w32tm /stripchart /computer:localhost  /samples:1  /period:1 /dataonly /packetinfo') do (
         set "ANSI_DATE=%%D"
         set  "TIMESERVER_HOURS=%%E"
         goto :end_for  )
        :end_for
        set  "LOCAL_HOURS=%TIME:~0,2%"
        if "%TIMESERVER_HOURS:~0,1%0" EQU "00" set TIMESERVER_HOURS=%TIMESERVER_HOURS:~1,1%
        if "%LOCAL_HOURS:~0,1%0" EQU "00" set LOCAL_HOURS=%LOCAL_HOURS:~1,1%
        set /a OFFSET=TIMESERVER_HOURS-LOCAL_HOURS
 
        rem :: day of the week will be the modulus of 7 of local ansi date +1
        rem :: we need need +1 because Monday will be calculated as 0
        rem ::  1st jan 1601 was Monday
       
        rem :: if abs(offset)>12 we are in different days with the time server
 
        IF %OFFSET%0 GTR 120 set /a DOW=(ANSI_DATE+1)%%7+1
        IF %OFFSET%0 LSS -120 set /a DOW=(ANSI_DATE-1)%%7+1
        IF %OFFSET%0 LEQ 120 IF %OFFSET%0 GEQ -120 set /a DOW=ANSI_DATE%%7+1
 
 
        echo Day of the week: %DOW%
        exit /b 2147483648
endlocal
