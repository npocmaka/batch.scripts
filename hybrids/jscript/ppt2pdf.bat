@if (@X)==(@Y) @end /* JScript comment
    @echo off

    cscript //E:JScript //nologo "%~f0" %*

    exit /b %errorlevel%

@if (@X)==(@Y) @end JScript comment */

function printHelp(){ 
    WScript.Echo(WScript.ScriptName  + " - converts power point presentation to pdf.Requires installed MS Office."); 
    WScript.Echo("Usage:"); 
    WScript.Echo("[call] " + WScript.ScriptName  + " pptFile pdfFile");
}

if(WScript.Arguments.Item(0).toLowerCase()=="-h" || WScript.Arguments.Item(0).toLowerCase()=="-help" || WScript.Arguments.Item(0).toLowerCase()=="-?") {
	printHelp();
}
 
if(WScript.Arguments.Length < 2) {
	printHelp();
	WScript.Quit(1);
}

FSOObj = new ActiveXObject("Scripting.FileSystemObject");

var source=WScript.Arguments.Item(0);
var target=WScript.Arguments.Item(1);

// no checks for directories.
if(!FSOObj.FileExists(source)){
	WScript.Echo("File " + source + "does not exists");
	WScript.Quit(2);
}

if(FSOObj.FileExists(target)){
	WScript.Echo("File " + target + "already exists");
	WScript.Quit(3);
}

PP = new ActiveXObject("PowerPoint.Application");
PRSNT = PP.presentations.Open(source,0,0,0)
//PRSNT.SaveCopyAs(target,32);
//https://msdn.microsoft.com/en-us/vba/powerpoint-vba/articles/ppsaveasfiletype-enumeration-powerpoint
PRSNT.SaveAs(target,32);
PRSNT.Close();
PP.Quit();
