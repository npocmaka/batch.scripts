:folderOwner
@echo off

set "folder=%%~1"

for /f "tokens=* delims=" %%a in ("%folder%") do (
     set "fpath=%%~pa"
     set "fname=%%~na"
     set "fdrive=%%~da"
)

set "fpath=%fpath:\=\\%"

for /f "usebackq tokens=* delims=" %%a in (`wmic path Win32_Directory where "path='%fpath%' and drive='%fdrive%' and filename='%fname%'" get  CSName /format:value`) do (
    for /f "tokens=* delims=" %%z in  ("%%a") do (

        if "%%z" neq "" (
            set "%%z"
        )
    )
)

echo %CSName%
exit /b 0
