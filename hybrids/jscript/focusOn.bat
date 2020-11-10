@if (@X)==(@Y) @end /* JScript comment
	@echo off
	cscript //E:JScript //nologo "%~f0"  %*
	exit /b %errorlevel%
@if (@X)==(@Y) @end JScript comment */

var ARGS=WScript.Arguments;

if (ARGS.Length < 1 ) {
	 WScript.Echo("No window title passed");
	 WScript.Quit(1);
}

var sh=new ActiveXObject("WScript.Shell");
if(!sh.AppActivate(ARGS.Item(0))){
	WScript.Echo("Cannot find an app with window name starting with: " + ARGS.Item(0));
}
