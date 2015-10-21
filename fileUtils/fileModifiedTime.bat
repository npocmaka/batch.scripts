@echo off
setlocal
for %%# in (/h /help -h -help) do (
	if "%~1" equ "%%#" (
		(echo()
		echo %~nx0 [rtnVar] - gets last modified time of a file in YYYY/MM/DD HH:mm:SS format
		echo rtnVar - optional variable name where the result will be stored
		(echo()
		echo example:
		echo call %~nx0 C:\file.ext lastModified 
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
for %%# in ("%file_loc%") do set file_dir=%%~dp#
for %%# in ("%file_loc%") do set file_name=%%~nx#
pushd %file_dir%

for /f "skip=2 tokens=1,2" %%a in ('robocopy  "." "%temp%" /l /fat /ts /LEV:1 /NP /NC /NS /NJS /NJH /IF "%file_name%"') do (
    echo last modified date of "%~f1" :
	echo %%a %%b
	set "fdate_time=%%a %%b"
)
popd

endlocal && (
	if "%~2" neq "" set "%2=%fdate_time%"
	exit /b %errorlevel%
)
