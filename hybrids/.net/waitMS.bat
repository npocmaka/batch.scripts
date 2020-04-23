@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal
::del %~n0.exe /q /f
::
:: For precision better call this like
:: call waitMS 500
:: in order to skip compilation in case there's already built .exe
:: as without pointed extension first the .exe will be called due to the ordering in PATEXT variable
::
::
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /w:0 /out:"%~n0.exe" "%~dpsfnx0"
)


%~n0.exe %*

endlocal & exit /b %errorlevel%


*/


import System;
import System.Threading;

var arguments:String[] = Environment.GetCommandLineArgs();
function printHelp(){
	Console.WriteLine(arguments[0]+" N");
	Console.WriteLine(" N - milliseconds to wait");
	Environment.Exit(0);	
}

if(arguments.length<2){
	printHelp();
}

try{
	var wait:Int32=Int32.Parse(arguments[1]);
	System.Threading.Thread.Sleep(wait);
}catch(err){
	Console.WriteLine('Invalid Number passed');
	Environment.Exit(1);
}

