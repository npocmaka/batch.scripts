@echo off
:detect_encoding
setLocal
if "%1" EQU "-?" (
    endlocal
    call :help
    exit /b 0
)
if "%1" EQU "-h" (
    endlocal
    call :help
    exit /b 0
)
if "%1" EQU "" (
    endlocal
    call :help
    exit /b 0
)


if not exist "%1" (
        echo file does not exists
    endlocal
    exit /b 54
)

if exist "%1\" (
        echo this cannot be used against directories
    endlocal
    exit /b 53
)

if "%~z1" EQU "0" (
    echo empty files are not accepted
    endlocal
    exit /b 52
)



set "file=%~snx1"
del /Q /F "%file%.hex" >nul 2>&1

certutil -f -encodehex %file% %file%.hex>nul

rem -- find the first line of hex file --

for /f "usebackq delims=" %%E in ("%file%.hex") do (
    set "f_line=%%E" > nul
        goto :enfdor
)
:enfdor
del /Q /F "%file%.hex" >nul 2>&1

rem -- check the BOMs --
echo %f_line% | find "ef bb bf"     >nul && echo utf-8     &&endlocal && exit /b 1
echo %f_line% | find "ff fe 00 00"  >nul && echo utf-32 LE &&endlocal && exit /b 5
echo %f_line% | find "ff fe"        >nul && echo utf-16    &&endlocal && exit /b 2
echo %f_line% | find "fe ff 00"     >nul && echo utf-16 BE &&endlocal && exit /b 3
echo %f_line% | find "00 00 fe ff"  >nul && echo utf-32 BE &&endlocal && exit /b 4

echo ASCII & endlocal & exit /b 6



endLocal
goto :eof

:help
echo.
echo  %~n0 file - Detects encoding of a text file
echo.
echo for each encoding you will recive a text responce with a name and a errorlevel codes as follows:

echo     1 - UTF-8
echo     2 - UTF-16 BE
echo     3 - UTF-16 LE
echo     4 - UTF-32 BE
echo     5 - UTF-32 LE
echo     6 - ASCII

echo for empty files you will receive error code 52
echo for directories  you will receive error code 53
echo for not existing file  you will receive error code 54
goto :eof
