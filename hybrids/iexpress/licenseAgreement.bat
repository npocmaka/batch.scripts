;::Uses DisplayLicense option in express sed file
;:: It requires a path to the text file with the license agreement which will
;:: be built-in produced exe file and later can be deleted if
;:: the .exe will be reused


;@echo off
;setlocal

;set "message1_title=Are you agree?"
;set "license_file=%windir%\win.ini"
;set ppopup_executable=popupe.exe

;
;del /q /f %tmp%\yes >nul 2>&1
;
;copy /y "%~f0" "%temp%\popup.sed" >nul 2>&1
;(echo(DisplayLicense=%license_file%)>>"%temp%\popup.sed"
;(echo(TargetName=%cd%\%ppopup_executable%)>>"%temp%\popup.sed";
;(echo(FriendlyName=%message1_title%)>>"%temp%\popup.sed"
;
;iexpress /n /q /m %temp%\popup.sed
;%ppopup_executable%
;del /q /f %ppopup_executable% >nul 2>&1

;if exist "%tmp%\yes" (set ans=yes) else (set ans=no)
;echo %ans%
;pause

;endlocal
;exit /b 0


[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=1
HideExtractAnimation=1
UseLongFileName=0
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles
[SourceFiles]
SourceFiles0=C:\Windows\System32\
[SourceFiles0]
%FILE0%=


[Strings]
AppLaunched=cmd.exe /c "break>%tmp%\yes"
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="subst.exe"
InstallPrompt=
FinishMessage=


