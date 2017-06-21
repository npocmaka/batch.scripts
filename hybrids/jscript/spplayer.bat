@if (@X)==(@Y) @end /* JScript comment
    @echo off

    cscript //E:JScript //nologo "%~f0" %*

    exit /b %errorlevel%

@if (@X)==(@Y) @end JScript comment */

if (WScript.Arguments.Length == 0) {
	WScript.Echo(WScript.ScriptName + " file_to_play");
	WScript.Quit(0)
}
var fso= new ActiveXObject("Scripting.FileSystemObject");
var file=WScript.Arguments.Item(0);

if (!fso.FileExists(file)){
	WScript.Echo(file + " does not exist");
	WScript.Echo("usage:");
	WScript.Echo(WScript.ScriptName + " file_to_play");
	WScript.Quit(1);
}


var spVoice = new ActiveXObject("SAPI.SpVoice");
var spFile = new ActiveXObject("SAPI.SpFileStream.1");
spFile.Open(file);
spVoice.SpeakStream(spFile);
