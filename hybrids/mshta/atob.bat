@echo off

setlocal

if "%~1" equ "" (
	echo %~nx1 - decodes string to base 64
	echo example:
	echo %~nx1 string [rtrnVar]
	echo(
	echo	rtrnVar - variable where where the result will be stored.
	echo 		if not defined the result will be printed in console
	exit /b 0
)

set "string=%~1"



for /f "delims=" %%# in ('echo %string%^|mshta.exe "%~f0"') do (
    set dec=%%#
)

if "%~2" neq "" (
	endlocal & (
		set "%~2=%dec%"
		exit /b %errorlevel%
	)
) else (
	endlocal & (
		echo %dec%
		exit /b %errorlevel%
	)
)

exit /b %errorlevel%

<HTA:Application
   ShowInTaskbar = no
   WindowsState=Minimize
   SysMenu=No
   ShowInTaskbar=No
   Caption=No
   Border=Thin
>
<meta http-equiv="x-ua-compatible" content="ie=10" />
<script language="javascript" type="text/javascript">
    window.visible=false;
    window.resizeTo(1,1);

   var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
   var fso2= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
   var string=fso2.ReadLine();

    var encodedString = atob(string);

   fso.Write(encodedString);
   window.close();
</script>
