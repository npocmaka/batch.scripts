;:: uses AppLaunched and ShowInstallProgramWindow options in iexpress sed files
;:: to start a hidden process
;:: requires admin privileges 
;::http://www.dostips.com/forum/viewtopic.php?f=3&t=5901
;:: check the read.me file


;@echo off
;setlocal
;set hid_executable=hid.exe
;echo %hid_executable:~0,-4%
;
;set "app_to_launch="%windir%\notepad.exe""
;
;del /q /f %tmp%\yes >nul 2>&1
; 
;copy /y "%~f0" "%temp%\hid.sed" >nul 2>&1
;setlocal enableDelayedExpansion
;(echo(AppLaunched=!app_to_launch!)>>"%temp%\hid.sed"
;
;(echo(TargetName=%cd%\%hid_executable%)>>"%temp%\hid.sed";
;
;
;iexpress /n /q /m %temp%\hid.sed
;%hid_executable%
;del /q /f %hid_executable% >nul 2>&1
;rem if exist "%tmp%\zzz" (set check=executed) else (set check=not_executed)
;rem echo %check%
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

FILE0="subst.exe"

[SourceFiles]
SourceFiles0=C:\Windows\System32\
[SourceFiles0]
%FILE0%=

[Strings]
InstallPrompt=
DisplayLicense=
FinishMessage=
FriendlyName=.
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=

FILE0="subst.exe"


