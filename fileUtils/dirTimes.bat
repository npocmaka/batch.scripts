@echo off
setlocal
for %%# in (/h /help -h -help) do (
	if "%~1" equ "%%#" (
		(echo()
		echo %~nx0 - Displays LastModified,LastAccessed and DateCreated times of a given directory
		echo         in format YYYYMMDDhhmmss
		(echo()
		echo example:
		echo call %~nx0 "C:\directory\"
	)
)

if "%~1" equ "" (
	echo no directory passed
	exit /b 1
)

if not exist "%~f1" (
	echo directory "%~f1" does not exist
	exit /b 2
)

if exist "%~f1\"  if not exist "%~f1" (
	echo "%~f1" is a file but not a directory
	exit /b 3
) 

set "dirname=%~f1"
set dirname=%dirname:\=\\%
echo directory timestamps for %~f1 :
(echo()
for /f "useback delims=." %%t in (`"WMIC path Win32_Directory WHERE name="%dirname%" get LastModified,CreationDate,LastAccessed  /format:value"`) do (
    for /f %%$ in ("%%t") do if "%%$" neq "" echo %%$
)
endlocal && (
	exit /b %errorlevel%
)
