@if (@X)==(@Y) @end /* JScript comment
	@echo off
	cscript //E:JScript //nologo "%~nx0" %*
	exit /b %errorlevel%
@if (@X)==(@Y) @end JScript comment */
// writes a string to the console without a new line at the end
if(WScript.Arguments.Count()>0) WScript.StdOut.Write(WScript.Arguments.Item(0));
