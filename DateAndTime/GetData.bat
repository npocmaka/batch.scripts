@echo off
Rem To get month
IF %date:~3,2%==01 set month=JANUARY
IF %date:~3,2%==02 set month=FEBRUARY
IF %date:~3,2%==03 set month=MARCH
IF %date:~3,2%==04 set month=APRIL
IF %date:~3,2%==05 set month=MAY
IF %date:~3,2%==06 set month=JUNE
IF %date:~3,2%==07 set month=JULY
IF %date:~3,2%==08 set month=AUGUST
IF %date:~3,2%==09 set month=SEPTEMBER
IF %date:~3,2%==10 set month=OCTOBER
IF %date:~3,2%==11 set month=NOVEMBER
IF %date:~3,2%==12 set month=DECEMBER
Rem to get day
set Day=%date:~0,2%
Rem Day lapse
if %time:~,2% LSS 12 set lapse=Morning
if %time:~,2% GEQ 12 set lapse=Afternoon
if %time:~,2% GEQ 20 set lapse=Night
rem set year
set year=%DATE:~6,4%
Rem result
echo.Time: %time% (%lapse%)
echo.Day: %day%
echo.Month: %month%
echo.Year: %year%
pause>nul&exit /b
