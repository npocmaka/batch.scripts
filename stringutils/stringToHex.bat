@echo off
:stringToHex
del tmp.hex >nul 2>nul
del tmp.str >nul 2>nul
(echo|set /p=%~1)>tmp.str

certutil -encodehex tmp.str tmp.hex >nul
setlocal enableDelayedExpansion
set "hex_str="
for /f "usebackq tokens=2 delims=	" %%A in ("tmp.hex") do (
    set "line=%%A"
    set hex_str=!hex_str!!line:~0,48!
    set hex_str=!hex_str: =!

)
echo !hex_str!
exit /b %errorlevel%
