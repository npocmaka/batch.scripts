@echo off
setlocal enableDelayedExpansion
:: checks if the current session has admin permissions
:: uses only internal commands (checks existence of =:: variable)
:: exist with 1 if there are
:: and with 0 if there are no

set "dv==::"
if defined !dv! ( 
   echo has NOT admin permissions
   endlocal & exit /b 0
) else (
   echo has admin permissions
   endlocal & exit /b 1
)
