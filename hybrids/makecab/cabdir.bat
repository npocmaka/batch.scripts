;@echo off

;;;;; rem start of the batch part  ;;;;;
; if "%~2" EQU "" (
;	echo invalid arguments.For help use:
;	echo %~nx0 /h
;)
;for %%a in (/h /help -h -help) do ( 
;	if "%~1" equ "%%~a" (
;		echo compressing directory to cab file	
;		echo %~nx0 directory cabfile
;     	echo to uncompress use:
;		echo EXPAND cabfile -F:* .
;	)
; )
;
; set "dir_to_cab=%~f1"
;
; set "path_to_dir=%~pn1"
; set "dir_name=%~n1" 
; set "drive_of_dir=%~d1"
; set "cab_file=%~2"
;
; if not exist %dir_to_cab%\ (
;	echo no valid directory passed
;	exit /b 1
;)

;
;break>"%tmp%\makecab.dir.ddf"
;
;setlocal enableDelayedExpansion
;for /d /r "%dir_to_cab%" %%a in (*) do (
;	
;	set "_dir=%%~pna"
;   set "destdir=%dir_name%!_dir:%path_to_dir%=!"
;	(echo(.Set DestinationDir=!destdir!>>"%tmp%\makecab.dir.ddf")
; 	for %%# in ("%%a\*") do (
;		(echo("%%~s#"  /inf=no>>"%tmp%\makecab.dir.ddf")
;	)
;)
;(echo(.Set DestinationDir=!dir_name!>>"%tmp%\makecab.dir.ddf")
; 	for %%# in ("%~f1\*") do (
;		
;		(echo("%%~s#"  /inf=no>>"%tmp%\makecab.dir.ddf")
;	)

;makecab /F "%~f0" /f "%tmp%\makecab.dir.ddf" /d DiskDirectory1=%cd% /d CabinetNameTemplate=%cab_file%.cab
;del /q /f "%tmp%\makecab.dir.ddf"
;exit /b %errorlevel%

;;
;;;; rem end of the batch part ;;;;;

;;;; directives part ;;;;;
;;
.New Cabinet
.set GenerateInf=OFF
.Set Cabinet=ON
.Set Compress=ON
.Set UniqueFiles=ON
.Set MaxDiskSize=1215751680;

.set RptFileName=nul
.set InfFileName=nul

.set MaxErrors=1
;;
;;;; end of directives part ;;;;;
