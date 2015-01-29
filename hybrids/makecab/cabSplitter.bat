;@echo off

;;;;; rem start of the batch part  ;;;;;
;; 
;; 
;; rem the first parameter is the file you want to split  the second is the size in bytes.
;; rem size is not guaranteed but will be not overflown 
;; rem https://github.com/npocmaka/batch.scripts/blob/master/hybrids/makecab/cabSplitter.bat
; if "%~2" equ "" (
; call :helpmessage
; exit /b 1 
;)
;if not exist "%~dpnx1" (
; call :helpmessage
; exit /b 2
;)
;if exist  "%~dpnx1\" (
; call :helpmessage
; exit /b 3
;)
; rem remove leading zeroes
; cmd /c exit /b %~2
; set /a size=%errorlevel%
; if %size% equ 0 (
; echo size must be greater than 0
; exit /b 4
;)
; rem MaxDiskSize must be multiple of 512 and closest possible to desired size.
;if %~2 LSS 512 set diskSize=512 else (
; set /a part=%~2%%512
; set /a diskSize=%~2-part
;)
;makecab /d the_file="%~1" /d diskSize=%diskSize% /d the_size="%~2" /F "%~dpfnxs0"
;exit /b %errorlevel%
;:helpmessage
; echo no existing file has been passed
; echo usage [split a file to cab parts with given size]:
; echo %~nx0 file size
; echo(
; echo size must be greater than 0
; echo (
; echo for extraction use :
; echo extrac32 /a /e file.ext_part1.cab /l .
; exit /b 0

;;
;;;; rem end of the batch part ;;;;;

;;;; directives part ;;;;;
;;
.New Cabinet
.set GenerateInf=OFF
.Set Cabinet=on
.Set Compress=on
.Set MaxDiskSize=%diskSize%;
.Set MaxCabinetSize=%the_size%
.set CabinetFileCountThreshold=1
.set CompressedFileExtensionChar=_
.Set CabinetNameTemplate=%the_file%_part*.cab
.set DestinationDir=.
.Set DiskDirectoryTemplate=; 

.set RptFileName=nul
.set UniqueFiles=ON
;.set DoNotCopyFiles=ON
;.set MaxDiskFileCount=1
.set MaxErrors=1
.set GenerateInf=OFF
%the_file% /inf=no
;;
;;;; end of directives part ;;;;;
