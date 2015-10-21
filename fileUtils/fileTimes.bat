@echo off
setlocal
for %%# in (/h /help -h -help) do (
	if "%~1" equ "%%#" (
		(echo()
		echo %~nx0 - Displays LastModified,LastAccessed and DateCreated times of a given file
		echo         in format YYYYMMDDhhmmss
		(echo()
		echo example:
		echo call %~nx0 C:\file.ext
	)
)

if "%~1" equ "" (
	echo no file passed
	exit /b 1
)

if not exist "%~f1" (
	echo file "%~f1" does not exist
	exit /b 2
)

if exist "%~f1\" (
	echo "%~f1" is a directory but not a file
	exit /b 3
) 

set "file_loc=%~f1"
set file_loc=%file_loc:\=\\%
echo file timestamps for %~f1 :
(echo()
for /f "useback delims=." %%t in (`"WMIC DATAFILE WHERE name="%file_loc%" get LastModified,CreationDate,LastAccessed  /format:value"`) do (
    for /f %%$ in ("%%t") do if "%%$" neq "" echo %%$
)
endlocal && (
	exit /b %errorlevel%
)
