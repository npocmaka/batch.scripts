@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

//TODO - add unpin

//gets an information that normally is acquired by right click-details 
// can get image dimensions , media file play time and etc.
 
////// 
FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;
if (ARGS.Length < 1 ) {
 WScript.Echo("No file passed");
 WScript.Echo("Usage:");
 WScript.Echo(WScript.ScriptName + " file [taskbar|startmenu]");
 WScript.Echo("default is taskbar");
 WScript.Quit(1);
}
var filename=ARGS.Item(0);
var objShell=new ActiveXObject("Shell.Application");

var verb="taskbar";
if (ARGS.Length > 1) {
	verb=ARGS.Item(1).toLowerCase();
	switch(verb){
		case "taskbar":
			verb="taskbar";
			break;
		case "startmenu":
			verb="startmenu";
			break;
		default:
			WScript.Echo("invalid verb "+verb);
			WScript.Quit(5);
	}
}
/////


//fso
ExistsItem = function (path) {
	return FSOObj.FolderExists(path)||FSOObj.FileExists(path);
}

getFullPath = function (path) {
    return FSOObj.GetAbsolutePathName(path);
}
//

//paths
getParent = function(path){
	var splitted=path.split("\\");
	var result="";
	for (var s=0;s<splitted.length-1;s++){
		if (s==0) {
			result=splitted[s];
		} else {
			result=result+"\\"+splitted[s];
		}
	}
	return result;
}


getName = function(path){
	var splitted=path.split("\\");
	return splitted[splitted.length-1];
}
//

function main(){
	if (!ExistsItem(filename)) {
		WScript.Echo(filename + " does not exist");
		WScript.Quit(2);
	}
	var fullFilename=getFullPath(filename);
	var namespace=getParent(fullFilename);
	var name=getName(fullFilename);
	var objFolder=objShell.NameSpace(namespace);
	var objItem=objFolder.ParseName(name);
	//https://msdn.microsoft.com/en-us/library/windows/desktop/bb787870(v=vs.85).aspx
	//https://msdn.microsoft.com/en-us/library/windows/desktop/bb774170(v=vs.85).aspx
	//WScript.Echo(fullFilename + " : ");
	//WScript.Echo(objFolder.GetDetailsOf(objItem,-1));
	
	var verbs=objItem.Verbs();
	
	if (verbs != null) {
		//WScript.Echo(verbs.Count);
		for (var i=0;i<verbs.Count;i++){
			if ( verb === "taskbar" && verbs.Item(i).Name === "Pin to Tas&kbar") {
				WScript.Echo("pinning "  + name + " to taskbar ");
				//objItem.InvokeVerb(verbs.Item(i));
				verbs.Item(i).DoIt();
				return;
			}
			if ( verb === "startmenu" && verbs.Item(i).Name === "Pin to Start Men&u") {
				WScript.Echo("pinning "  + name + " to start menu ");
				//objItem.InvokeVerb(verbs.Item(i));
				verbs.Item(i).DoIt();
				return;
			}
		}
		
		WScript.Echo("the item " + filename + "does not support selected action");
		return;
	}	
}
main();
