@if (@X)==(@Y) @end /*
	@echo off
	setlocal
	del %~n0.exe /q /s >nul 2>nul
	for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
	   set "jsc=%%v"
	)
	if not exist "%~n0.exe" (
		"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
	)
	%~n0.exe %*
	::del /q /f %~n0.exe 1>nul 2>nul 
	endlocal & exit /b %errorlevel%
*/

import System;
import System.Net.Sockets;

var arguments:String[] = Environment.GetCommandLineArgs();
if (arguments.length<3){
    Console.WriteLine("not enough arguments");
    Environment.Exit(1);
}

var host=arguments[1];
try {
	var port=Int32.Parse(arguments[2]);
} catch (err) {
	Console.WriteLine("Cannot convert " + arguments[1] + " to number");
	Environment.Exit(2);
}

Console.WriteLine("Checking host {0} and port {1}",host,port);

var client = new TcpClient();

try {
    client.Connect(host, port);
} catch(err) {
    Console.WriteLine("Closed");
	Environment.Exit(0);
}
client.Close();
Console.WriteLine("Open");
