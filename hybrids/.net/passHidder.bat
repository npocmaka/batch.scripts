@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal enableDelayedExpansion

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

for /f "tokens=* delims=" %%p in ('"%~n0.exe"') do (
    set "pass=%%p"
)

echo your password is !pass!

endlocal & exit /b %errorlevel%

*/



import System;



var pwd = "";
var key;

Console.Error.Write("Enter password: ");

        do {
           key = Console.ReadKey(true);
           
		   if ( (key.KeyChar.ToString().charCodeAt(0)) >= 20 && (key.KeyChar.ToString().charCodeAt(0) <= 126) ) {
              pwd=pwd+(key.KeyChar.ToString());
              Console.Error.Write("*");
           }
		   
		   if ( key.Key == ConsoleKey.Backspace && pwd.Length > 0 ) {
			   pwd=pwd.Remove(pwd.Length-1);
			   Console.Error.Write("\b \b");
		   }
		   
		   
        } while (key.Key != ConsoleKey.Enter);
        Console.Error.WriteLine();
        Console.WriteLine(pwd);
