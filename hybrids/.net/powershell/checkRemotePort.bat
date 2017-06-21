@echo off
setlocal
for %%h in (/h /help -help -h "") do (
     if /I "%~1" equ "%%~h" (
        goto :printHelp
     )
 )

 if "%~2" equ ""  goto :printHelp

 set "HOST=%~1"
 set /a PORT=%~2

set "host=google.com"
set /a port=443

for /f %%a in ('powershell "$t = New-Object Net.Sockets.TcpClient;try{$t.Connect("""%HOST%""", %PORT%)}catch{};$t.Connected"') do set "open=%%a"

if "%open%" equ "true" (
  echo open
  endlocal & exit /b 0
) else (
  echo closed
  endlocal & exit /b 1
)


:printHelp
   echo Checks if port is open on a remote server
   echo(
   echo Usage:
   echo    %~nx0 host port
   echo(
   echo If the port is not accessible an errorlevel 1 is set
   endlocal & exit /b 0
