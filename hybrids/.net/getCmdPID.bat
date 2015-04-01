@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)


if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0" 
)

%~n0.exe

::pause
endlocal & exit /b %errorlevel%

*/

//http://stackoverflow.com/questions/2531837/how-can-i-get-the-pid-of-the-parent-process-of-my-application
import  System;
import  System.Diagnostics;
import  System.ComponentModel;
import  System.Management;

var myId = Process.GetCurrentProcess().Id;
var query = String.Format("SELECT ParentProcessId FROM Win32_Process WHERE ProcessId = {0}", myId);
var search = new ManagementObjectSearcher("root\\CIMV2", query);
var results = search.Get().GetEnumerator();
if (!results.MoveNext()) {
	Console.WriteLine("Error");
	Environment.Exit(-1);
}
var queryObj = results.Current;
var parentId = queryObj["ParentProcessId"];
var parent = Process.GetProcessById(parentId);
Console.WriteLine(parent.Id);
Environment.Exit(parent.Id);
