;@echo off
;setlocal

;set ppopup_executable=popupe.exe
;set "message2=click OK to continue"
;
;del /q /f %tmp%\yes >nul 2>&1
;
;copy /y "%~f0" "%temp%\popup.sed" >nul 2>&1

;(echo(FinishMessage=%message2%)>>"%temp%\popup.sed";
;(echo(TargetName=%cd%\%ppopup_executable%)>>"%temp%\popup.sed";
;(echo(FriendlyName=%message1_title%)>>"%temp%\popup.sed"
;
;iexpress /n /q /m %temp%\popup.sed
;%ppopup_executable%
;rem del /q /f %ppopup_executable% >nul 2>&1

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
AppLaunched=subst.exe
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="subst.exe"
DisplayLicense=
InstallPrompt=


