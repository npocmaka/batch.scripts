@echo off

:: Copies a single file with progress bar
:: requires at least windows vista
:: uses esentutl command
:: http://ss64.org/viewtopic.php?id=1727
 
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
rem Esentutl is a command that performs some operations over a special windows database files (e.g. restore point files)
rem From Windows Vista and above it supports copy operation which has a progress bar and can be used on ordinary files:
 
rem esentutl /y "FILE.EXT" /d"DEST.EXT" /o
rem May be it is not completely reliable:
 
rem If performed on arbitrary files, this operation may fail
rem at the end of the file if its size is not sector-aligned.
 
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
:progressCopy
setlocal
echo.
for /f "skip=2 tokens=2,3 delims=. " %%V in ('esentutl /d#') do (
        echo esentutl version %%V.%%W
        set /a "version=%%V%%W"
        goto :break
)
:break
color
if defined version if %version%0 LSS 600 (
        echo UNSUPORTED VERSION
        echo Lower than 6.0
        exit /b 3
)
 
 
for %%H in ("/h" "-h" "-help" "/help") do (
        if /I "%~1" EQU "%%~H" goto :help
)
 
if "%~1" EQU "" (
        goto :help
)
set "source=%~1"
 
if not exist "%source%" (
        (echo()
        echo source file does not exist
        exit /b 2
)
 
for %%F in ("/f" "/force") do (
    if /I "%~3" EQU "%%~F" set "force=1"
        if /I "%~2" EQU "%%~F" set "force=1" && set "dest=%~nx1"
)
 
if "%~2" NEQ ""  (
 if not defined dest set "dest=%~2"
) else (
 if not defined dest set "dest=%~nx1"
)
 
if exist "%dest%" if not defined force (
    (echo()
        echo file already exist and force option is not set
        echo exit /b 1
)
 
if exist "%dest%" if defined force (
        (echo()
        echo file already exist and will be overwritten
        del /Q /F "%dest%"
)
 
esentutl /y"%source%" /d"%dest%" /o
endlocal
goto :eof
 
:help
echo.
echo Copying a file with a progress bar
echo.
echo.
echo %~nx0  source [destination] [/force^|/f]
echo.
echo.
echo source           - path to the source file
echo.
echo destination      - path to the destination file.If not
echo                    defined it will be set to the current directory.
echo.
echo /force           - overwrite the source file if exists
echo.
