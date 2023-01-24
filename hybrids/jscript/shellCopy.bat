@if (@x)==(@y) @end /***** jscript comment ******
     @echo off
     cscript //E:JScript //nologo "%~f0" "%~nx0" %* 
     exit /b %errorlevel%

***** end comment *********/
 
var FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ShellObj=new ActiveXObject("Shell.Application");  

var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);
var move = false;

if (ARGS.Length == 0 ) {
 WScript.Echo("Uses shell.application to move/copy files. Usage:");	
 WScript.Echo(scriptName + "source destinationDirectory [move]");
 WScript.Echo("Example:");	
 WScript.Echo("call " + scriptName + "\"C:\\file.txt\" \"D:\\folder\" ");
 WScript.Echo("To move files:");	
 WScript.Echo("call " + scriptName + "\"C:\\*.txt\" \"D:\\folder\" yes");
 WScript.Quit(0);
}

if (ARGS.Length < 3 ) {
 WScript.Echo("ERROR: not enough arguments");
 WScript.Quit(1);
}


if (ARGS.Length > 3 ) {
  if (ARGS.Item(3).toLowerCase() == "true") {
	move = true;
  }
}

var source = ARGS.Item(1);
var destination = ARGS.Item(2);

//options values
var YES_TO_ALL=16;
var YESTA_NEW_NAMES=312


getFullPath = function (path) {
    return FSOObj.GetAbsolutePathName(path);
}

destination = getFullPath(destination);

if (!FSOObj.FolderExists(destination)) {
 WScript.Echo("ERROR: directory " + destination + " does not exists");
 WScript.Quit(1);
}

var folder = ShellObj.NameSpace(destination);

if (move) {
	folder.MoveHere(source,YESTA_NEW_NAMES);
} else {
    folder.CopyHere(source,YESTA_NEW_NAMES);
}
