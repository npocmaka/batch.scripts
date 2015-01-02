@echo off
setlocal enableExtensions
 
rem ------ validate parameters ------
:: parametrized version of batch.scripts/fileUtils/firstLiles.bat
for %%H in ("/h" "-h" "-help" "/help") do if /I "%~1" EQU "%%~H" goto :help
if "%~2" EQU "" goto :help
if not exist "%~1" echo file does not exist && exit /b 3
set /a "lines=%~2"
if not defined lines echo pass a number bigger than 0 for the lines to be shown&&exit /b 1
if defined lines if %lines%0 equ 0 echo pass a number bigger than 0 for the lines to be shown&&exit /b 2
rem ---------------------------------
 
;break>"%temp%\empty"
@@fc "%temp%\empty" "%~1" /lb  %lines% /t |more +4 | findstr /B /E /V "*****"
;del /q /f "%temp%\empty"
 
goto :eof
endlocal
 
:help
echo Displays first lines of a given file
echo.
echo %~n0 file lines
echo.
echo.
echo  lines     Number of lines to display.Must be bigger than 0.
echo  file      Specifies the file.
::
:: by Vasil "npocmaka" Arnaudov
::
