@echo off
setlocal enableExtensions

rem --- requires admin permissions ---
 
echo.
echo.
echo INSTALLED BROWSERS
echo.
echo.
 
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: exporting registry values for installed browsers
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::
 
rem for 64 bit systems
START /W REGEDIT /E "%Temp%\BROW3.reg" HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Clients\StartMenuInternet
rem for 32 bit systems
if not exist "%Temp%\BROW3.reg" START /W REGEDIT /E "%Temp%\BROW3.reg" HKEY_LOCAL_MACHINE\SOFTWARE\Clients\StartMenuInternet
 
setLocal enableDelayedExpansion
for /f "tokens=*" %%B in ('type "%Temp%\BROW3.reg" ^| findstr /E "DefaultIcon]"') do (
 rem extracting browser name from icon path
  set "browser=%%B"
 rem removing \DefaultIcon] string
  set "browser=!browser:\DefaultIcon]=!"
 rem get the browser name
  for %%P in ("!browser!") do echo %%~nP
)
endLocal
 
echo.
echo.
echo EXECUTABLES PATHS
echo.
echo.
 
setLocal enableDelayedExpansion
for /f "tokens=* delims=@=" %%B in ('type "%Temp%\BROW3.reg" ^| findstr /B "@" ^| findstr /E ".exe\\\",0\"^"') do (
  set "browser=%%~B"
  set "browser=!browser:\\=\!"
  echo !browser!
 
)
setLocal enableDelayedExpansion
for /f "tokens=* delims=@=" %%B in ('type "%Temp%\BROW3.reg" ^| findstr /B "@" ^| findstr /E ".exe,0\"^"') do (
  set "browser=%%~B"
  set "browser=!browser:\\=\!"
  set "browser=!browser:,0=!"
  echo !browser!
 
)
endLocal
 
 
rem delete temp file
del /Q /F "%Temp%\BROW3.reg"
 
 
echo.
echo.
echo DEFAULT BROWSER
echo.
echo.
 
START /W REGEDIT /E "%Temp%\BROW5.reg" HKEY_CLASSES_ROOT\http\shell\open\command
setLocal enableDelayedExpansion
for /f tokens^=3^ delims^=^" %%B in ('type "%Temp%\BROW5.reg" ^| find "@"') do (
    set "default=%%B"
        rem removing double slashes
    set "default=!default:\\=\!"
        rem removing end slash
    set "default=!default:~0,-1!"
        rem get the name
    for %%D in ("!default!") do echo %%~nD
)
endLocal
del /Q /F "%Temp%\BROW5.reg"
 
echo.
echo.
echo DEFAULT .HTML VIEWER
echo.
echo.
 
START /W REGEDIT /E "%Temp%\BROW6.reg" HKEY_CLASSES_ROOT\htmlfile\shell\open\command
setLocal enableDelayedExpansion
for /f tokens^=3^ delims^=^" %%B in ('type "%Temp%\BROW6.reg" ^| find "@"') do (
    set "default=%%B"
    set "default=!default:\\=\!"
    set "default=!default:~0,-1!"
    for %%D in ("!default!") do echo %%~nD
)
endLocal
del /Q /F "%Temp%\BROW6.reg"
echo.
echo.
pause
::
:: by Vasil "npocmaka" Arnaudov
::
