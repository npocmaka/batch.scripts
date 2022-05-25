:: ===============================================================================================
:: @file            GetTime.bat
:: @brief           Gets time using typeperf command with put some effort to be made fast and 
::                  maximum compatible.
:: @usage           GetTime.bat
:: @see             https://github.com/sebetci/batch.script/[02].DateAndTime/GetTime.bat
:: @reference       https://www.progress.com/blogs/understanding-iso-8601-date-and-time-format
:: @reference       https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/typeperf
:: @todo
:: ===============================================================================================

@ECHO OFF
SETLOCAL 
   :: Check if Windows is XP and use XP valid counter for UDP performance
   :: In Windows 10 the variable "USERDOMAIN_ROAMINGPROFILE" returns the device name.
   IF DEFINED USERDOMAIN_ROAMINGPROFILE (SET "V=V4" & ECHO Device Name: %USERDOMAIN_ROAMINGPROFILE%) ELSE (SET "V=")

   :: The "typeperf" command writes performance counter data to the command window or to a supported log file format.
   FOR /F "SKIP=2 DELIMS=," %%# IN ('TYPEPERF "\UDP%V%\*" -SI 0 -SC 1') DO ( 
      IF NOT DEFINED VMonth (
         FOR /F "TOKENS=1-7 DELIMS=.:/ " %%A IN (%%#) DO (
         SET VMonth=%%A
         SET VDate=%%B
         SET VYear=%%C
         SET VHour=%%D
         SET VMinute=%%E
         SET VSecond=%%F
         SET VMillisecond=%%G
         )
      )
   )

   :: ISO 8601 Date and Time Format
   ECHO %VYear%-%VMonth%-%VDate% %VHour%:%VMinute%:%VSecond%.%VMillisecond%
ENDLOCAL