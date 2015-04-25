@echo off
:checkNet

::
:: checks if a network interface with given name is connected
:: or not through ipconfig command
::

setlocal

if "%~1" equ "" echo no network name passed & exit /b 1

set "network_to_check=%~1"
if "%network_to_check:~-1,1%" NEQ ":" set "network_to_check=%network_to_check%:"

set nt=0
setlocal enableDelayedExpansion
for /f "skip=3 delims=" %%$ in ('ipconfig') do (
    set "line=%%$"
    ! echo %%$ >&2

    if "!line:~0,1!" neq " " (
        set /a nt=nt+1
        set _nt!nt!=!line!

    ) else (
        ! echo ----
        for /f %%# in ("!nt!") do (
            ! echo a:%%#
            ! echo --- %%# ---

            set "_nt!nt!=!_nt%%#!  !line!" 

        )   
    )
)

set _nt|find /i "%network_to_check%" >nul 2>nul||(
    echo network not found
    exit /b 1
)

set _nt| find /i "%network_to_check%"|find /i "Media disconnected" >nul 2>nul&&(
    echo disconnected
    exit /b 1
) 

echo connected

endlocal
endlocal
