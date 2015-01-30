@echo off
if "%~1" EQU "" echo parameter not entered & exit /b 1
set "parts=%~1.part"

setlocal enableDelayedExpansion
set numb=0
for /f "delims=." %%P in ('dir /b %parts%*') do (
	set /a numb=numb+1
)
rem echo !numb!


setlocal enableDelayedExpansion
set "string=%~1.part.1"
for /l %%n in (2;1;!numb!) do (
	set "string=!string!+!parts!.%%n"
)
rem echo !string!
copy /y /b !string! %~1%~x1
endlocal
