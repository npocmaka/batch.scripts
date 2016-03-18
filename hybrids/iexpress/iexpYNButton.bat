;@echo off
;
;::Creates an .exe file that produces a pop-up with yes/no buttoms
;:: the execution halts the script execution (unlike msg.exe) and prints the result of the user action
;:: has no 'toxic' output.Works on every machine since WindowsXP
;:: (ab)uses iexpress command line options - check read.me file
;
;setlocal
;:::::::::::::::: USER OPTIONS ::::::::::::::::
;::
;:::: the message of in the pop-up body
;set "message1=yes/no"
;::::: title of the pop-up
;set "message1_title=Are you agree?"
;:::: name of the produced executable
;set ppopup_executable=popupe.exe
;
;::does not accept a command line options at the moment
;::may be in a later version
;
;::
;:::::::::::::::::  END OF CHANGABLE OPTIONS ::::
;
;del /q /f %tmp%\yes >nul 2>&1
;
;copy /y "%~f0" "%temp%\popup.sed" >nul 2>&1
;(echo(InstallPrompt=%message1%)>>"%temp%\popup.sed"
;(echo(TargetName=%cd%\%ppopup_executable%)>>"%temp%\popup.sed";
;(echo(FriendlyName=%message1_title%)>>"%temp%\popup.sed"
;
;iexpress /n /q /m %temp%\popup.sed
;%ppopup_executable%
;del /q /f %ppopup_executable% >nul 2>&1
;if exist "%tmp%\yes" (set ans=yes) else (set ans=no)
;echo %ans%
;pause
;rem del %ppopup_executable%
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
DisplayLicense=
FinishMessage=


;InstallPrompt=messagee1
;DisplayLicense=F:\scriptests\sysinf
;FinishMessage=message2
;TargetName=F:\scriptests\popup1.exe
;FriendlyName=popuppkg
;

