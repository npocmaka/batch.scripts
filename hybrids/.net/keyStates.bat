@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

set "jsc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*jsc.exe") do  set "jsc=%%#"

if not exist "%jsc%" (
   echo no .net framework installed
   exit /b 10
)


::if not exist "%~n0.exe" (
	call "%jsc%"  /r:"System.Windows.Forms.dll" /nologo /out:"%~n0.exe" "%~dpsfnx0"||(
		exit /b %errorlevel%
	)
::)

"%~n0.exe"

endlocal & exit /b %errorlevel%

*/

	import System;
	import Accessibility;
	import System.Windows.Forms;
	import System.Drawing;

		var caps="CAPS LOCK : OFF";
		var num="NUM LOCK : OFF";
		var scroll="SCROLL LOCK : OFF"
		
        if (Control.IsKeyLocked(Keys.CapsLock)) {
            caps="CAPS LOCK : ON";
        }
		
		if (Control.IsKeyLocked(Keys.NumLock)) {
            caps="NUM LOCK : ON";
        }
		
		if (Control.IsKeyLocked(Keys.Scroll)) {
            caps="SCROL LLOCK : ON";
        }

		
		Console.WriteLine(caps);
		Console.WriteLine(num);
		Console.WriteLine(scroll);
		

		

