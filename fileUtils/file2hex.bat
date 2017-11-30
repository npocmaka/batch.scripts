@echo off
:stringToHex
del tmp.hex >nul 2>nul

if "%~2" equ "" (
	echo destination not given
	exit /b 10
)

set "source=%~f1"
set "destination=%~2"
del "%destination%" >nul 2>&1

if  not exist "%source%" (
	echo source file "%source%" does not exist
	exit /b 11
)

certutil -encodehex "%source%" tmp.hex >nul
setlocal enableDelayedExpansion
set "hex_str="
for /f "usebackq tokens=2 delims=	" %%A in ("tmp.hex") do (
    set "line=%%A"
    set line=!line:~0,48!
)>>"%destination%"
del tmp.hex >nul 2>nul
