@if (@X)==(@Y) @end /* JScript comment
	@echo off
	cscript //E:JScript //nologo "%~nx0" %*
	exit /b %errorlevel%
@if (@X)==(@Y) @end JScript comment */

if (WScript.Arguments.Count() == 0) {
	WScript.Echo();
	WScript.Echo(WScript.ScriptName + " writes a passed script to the console with a certain delay");
	WScript.Echo();
	WScript.Echo("Usage:");
	WScript.Echo();
	WScript.Echo(WScript.ScriptName + " string delay-in-ms");
	WScript.Quit(0);
}

if (WScript.Arguments.Count()<2) {
	WScript.Echo("not enough arguments");
	WScript.Quit(1);
}

var string = WScript.Arguments.Item(0);
var delay;
try {
	delay = parseInt(WScript.Arguments.Item(1));
}catch(err){
	WScript.Echo("cannot parse to number: " + WScript.Arguments.Item(1));
	WScript.Quit(2);
}

if(isNaN(delay)) {
	WScript.Echo("cannot parse to number: " + WScript.Arguments.Item(1));
	WScript.Quit(2);
}

for (var i = 0; i < string.length; i++) {
	WScript.Sleep(delay);
	WScript.StdOut.Write(string.charAt(i));
}
