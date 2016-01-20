@echo off

del ~.txt /q /f >nul 2>nul
start "" /w dxdiag /t ~
setlocal enableDelayedExpansion
set currmon=1 
for /f "tokens=2 delims=:" %%a in ('find "Current Mode:" ~.txt') do (
	echo Monitor !currmon! : %%a
	set /a currmon=currmon+1
	
)
endlocal
del ~.txt /q /f >nul 2>nul
