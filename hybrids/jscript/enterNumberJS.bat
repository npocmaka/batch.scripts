@if (@X) == (@Y) @end /* JScript comment 
    @echo off 
 	
		for /f "tokens=*" %%a in ('cscript //E:JScript //nologo "%~f0" "%~nx0" %* ') do set "number=%%a"
		echo you've entered %number%

    exit /b %errorlevel%       
@if (@X)==(@Y) @end JScript comment */


WScript.StdErr.Write("Enter a number:");
WScript.StdIn.Read(0);
var strMyName = WScript.StdIn.ReadLine();
var num=parseInt(strMyName);

while(isNaN(num)){
	WScript.StdErr.Write("Enter a number:");
	WScript.StdIn.Read(0);
	var strMyName = WScript.StdIn.ReadLine();
	var num=parseInt(strMyName);
}

WScript.StdOut.WriteLine(num);
