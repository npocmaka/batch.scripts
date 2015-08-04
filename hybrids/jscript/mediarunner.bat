@if (@X)==(@Y) @end /* JScript comment
	@echo off

	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%	
@if (@X)==(@Y) @end JScript comment */


if (WScript.Arguments.Length == 0) {
	WScript.Echo(WScript.ScriptName + " file_to_play");
	WScript.Quit(0)
}
var file=WScript.Arguments.Item(0);
var fso= new ActiveXObject("Scripting.FileSystemObject");

if (!fso.FileExists(file)){
	WScript.Echo(file + " does not exist");
	WScript.Echo("usage:");
	WScript.Echo(WScript.ScriptName + " file_to_play");
	WScript.Quit(1);
}

var player = new ActiveXObject("WMPlayer.OCX");
player.URL=fso.GetAbsolutePathName(file);
player.controls.play();

while(player.playState!=1){
	WScript.Sleep(100);
}
player.close();
