; @echo off
;;goto :end_help
;:fileinf
;;setlocal DsiableDelayedExpansion
;;;
;;;
;;; fileinf /l list of full file paths separated with ; and surrounded with quotes
;;; fileinf /f text file with a list of files to be processed ( one on each line )
;;; fileinf /? prints the help
;;;
;;; Batch/MakeCab hybrid file that gets property information about binary files
;;; by Vasil "npocmaka" Arnaudov
;;;
;;  the ;s are standard delimtiers in batch and remark symbols for makecab 
;;  directive files which allows to combine them both in one file
;;  http://stackoverflow.com/questions/20535473/how-can-i-determined-the-version-of-windows-installer-in-a-bat-file
;;  http://stackoverflow.com/questions/1706892/how-do-i-retrieve-the-version-of-a-file-from-a-batch-file-on-windows-vista
;;  alternative of FILEVER from windows 2003 res tool kit
;;:end_help

; REM Creating a Newline variable (the two blank lines are required!)
; set NLM=^


; set NL=^^^%NLM%%NLM%^%NLM%%NLM%
; if "%~1" equ "/?" type "%~f0" | find ";;;" | find /v "find" && exit /b 0
; if "%~2" equ "" type "%~f0" | find ";;;" | find /v "find" && exit /b 0
; setlocal enableDelayedExpansion
; if "%~1" equ "/l" (
;  set "_files=%~2"
;  echo !_files:;=%NL%!
;  echo !_files:;=%NL%!>"%TEMP%\file.paths"
;  set _process_file="%TEMP%\file.paths"
;  goto :get_info
; )

; if "%~1" equ "/f" if exist "%~2" (
;  set _process_file="%~2"
;  goto :get_info
; )

; echo incorect parameters & exit /b 1
; :get_info
; set "file_info="

; rem :: check if all passed files exist
; for /f "useback tokens=* delims=" %%f in ("%TEMP%\file.paths") do (
; if not exist "%%~f" (
;   echo file %%~f does not exist
;   exit /b 5
; )
;)

; makecab /d InfFileName=%TEMP%\file.inf /d "DiskDirectory1=%TEMP%" /f "%~f0"  /f %_process_file% /v0>nul
; for /f "usebackq skip=4 delims=" %%f in ("%TEMP%\file.inf") do (
;  set "file_info=%%f"
;  echo !file_info:,=%nl%!
; )

; endlocal
;endlocal
; del /q /f %TEMP%\file.inf 2>nul
; del /q /f %TEMP%\file.path 2>nul
; exit /b 0

.set DoNotCopyFiles=on
.set DestinationDir=;
.set RptFileName=nul
.set InfFooter=;
.set InfHeader=;
.Set ChecksumWidth=8
.Set InfDiskLineFormat=;
.Set Cabinet=off
.Set Compress=off
.Set GenerateInf=ON
.Set InfDiskHeader=;
.Set InfFileHeader=;
.set InfCabinetHeader=;
.Set InfFileLineFormat=",file:*file*,date:*date*,size:*size*,csum:*csum*,time:*time*,vern:*ver*,vers:*vers*,lang:*lang*"
