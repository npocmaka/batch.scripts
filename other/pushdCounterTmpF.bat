@echo off
pushd >%temp%\temp.temp
type %temp%\temp.temp | find /c "\"
rem find /c "\" %temp%\temp.temp
del %temp%\temp.temp /q >nul
