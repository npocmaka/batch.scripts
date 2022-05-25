:: ===============================================================================================
:: @file            DateParts.bat
:: @brief           Gets date parts
:: @usage           DateParts.bat
:: @see             https://github.com/sebetci/batch.script/[02].DateAndTime/DateParts.bat
:: @reference       https://stackoverflow.com/a/28250863/15032688
:: @reference       https://www.dostips.com/forum/viewtopic.php?f=3&t=4555
:: @todo
:: ===============================================================================================

@ECHO OFF
PUSHD "%TEMP%"
MAKECAB /D RPTFILENAME=~.RPT /D INFFILENAME=~.INF /F NUL >NUL

FOR /F "TOKENS=3-7" %%A IN ('FIND /I "MAKECAB"^<~.RPT') DO (
    SET "VWeekDay=%%A"
    SET "VCurrentDate=%%E-%%B-%%C"
    SET "VCurrentTime=%%D"
)
DEL ~.*
POPD
ECHO %VWeekDay% %VCurrentDate% %VCurrentTime%
GOTO :EOF