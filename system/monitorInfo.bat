@echo off

del ~.txt /q /f >nul 2>nul
dxdiag /t ~
w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:3  >nul 2>&1
setlocal enableDelayedExpansion
set currmon=1 
for /f "tokens=2 delims=:" %%a in ('find "Current Mode:" ~.txt') do (
	echo Monitor !currmon! : %%a
	set /a currmon=currmon+1
	
)
endlocal
del ~.txt /q /f >nul 2>nul
