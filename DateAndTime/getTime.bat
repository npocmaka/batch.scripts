@echo off

:: gets time using typePerf command
:: with put some effort to be made fast and maximum compatible

setlocal 
::check if windows is XP and use XP valid counter for UDP performance
if defined USERDOMAIN_roamingprofile (set "v=v4") else (set "v=")
set "mon="
for /f "skip=2 delims=," %%# in ('typeperf "\UDP%v%\*" -si 0 -sc 1') do ( 
   if not defined mon (
      for /f "tokens=1-7 delims=.:/ " %%a in (%%#) do (
        set mon=%%a
        set date=%%b
        set year=%%c
        set hour=%%d
        set minute=%%e
        set sec=%%f
        set ms=%%g
      )
   )
)
echo %year%.%mon%.%date%
echo %hour%:%minute%:%sec%.%ms%
endlocal
