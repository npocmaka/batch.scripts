@echo off
:: checks if the current session has admin permissions
:: exist with 1 if there are
:: and with 0 if there are no
fltmc >nul 2>&1 && (
  echo has admin permissions
  exit /b 1
) || (
  echo has NOT admin permissions
  exit /b 0
)
