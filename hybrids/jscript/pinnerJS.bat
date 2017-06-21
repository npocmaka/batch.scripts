@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

//gets an information that normally is acquired by right click-details 
// can get image dimensions , media file play time and etc.
 
// Thanks to help by Alexis Viala now it supports pin to start screen

////// 
FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;
if (ARGS.Length < 1 ) {
 WScript.Echo("No file passed");
 WScript.Echo("Usage(pins/unpins items to/from startmenu/taskbar):");
 WScript.Echo(WScript.ScriptName + " file [taskbar|startmenu|untaskbar|unstartmenu]");
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
		case "untaskbar":
			verb="untaskbar";
			break;
		case "unstartmenu":
			verb="unstartmenu";
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

//get windows version
var version=0;
var objWMIService = GetObject('winmgmts:').InstancesOf ("Win32_OperatingSystem") ;
//var oss = objWMIService.ExecQuery ("Select * from Win32_OperatingSystem");
var osEnum=new Enumerator(objWMIService);
for (;!osEnum.atEnd();osEnum.moveNext()) {
	version=osEnum.item().Version;
}
version=parseInt(version.replace(/\./g,''));
//WScript.Echo(version);

// if version is later than windows 7 there's pin to start screen instead pin to start menu
var startVerb1="startpin";
var startVerb2="";
if (version>619999){
	startVerb1="pintostartscreen";
}


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
	/* 
		verbs persisten handlers are {90AA3A4E-1CBA-4233-B8BB-535773D48449} and 
		{a2a9545d-a0c2-42b4-9708-a0b2badd77c8} and verbs language independent names can be seen in 
		HKEY_CLASSES_ROOT\CLSID\
		
		
		the language dependable version is commented out along with replaceAll function.
		To use it you need to add the && conditions in if statements and use DoIt() function instead of
		invokeVerb.
		
		The good thing in it is that it checks if the verbs are supported by the passed file.
		Though it will not work properly on not english language settings.
		
	*/
	if (verbs != null) {
		
		for (var i=0;i<verbs.Count;i++){
			//WScript.Echo(verbs.Item(i).Name);
			if ( verb === "taskbar") {
			//&& replaceAll("&","",verbs.Item(i).Name).indexOf("Pin to Taskbar") > -1 ) {
				WScript.Echo("pinning "  + name + " to taskbar ");
				objItem.InvokeVerb("TaskbarPin");
				//verbs.Item(i).DoIt();
				return;
			}
			
			if ( verb === "startmenu" ) {
			// &&  replaceAll("&","",verbs.Item(i).Name).indexOf("Pin to Start") > -1) {
				WScript.Echo("pinning "  + name + " to start menu ");
				objItem.InvokeVerb(startVerb1);
				//verbs.Item(i).DoIt();
				return;
			}
			if ( verb === "unstartmenu"){
			//	&&	replaceAll("&","",verbs.Item(i).Name).indexOf("Unpin from Start") > -1) {
				WScript.Echo("unpinning "  + name + " from start menu ");
				objItem.InvokeVerb("startunpin");
				//verbs.Item(i).DoIt();
				return;
			}
			if ( verb === "untaskbar"  ) {
			//&& replaceAll("&","",verbs.Item(i).Name).indexOf("Unpin from Taskbar") > -1 ) {
				WScript.Echo("unpinning "  + name + " from taskbar ");
				objItem.InvokeVerb("TaskbarUnPin");
				//verbs.Item(i).DoIt();
				return;
			}
		}
		
		WScript.Echo("the item " + filename + "does not support selected action("+verb+")");
		return;
	}	
}
main();

//function replaceAll(find, replace, str) {
//  return str.replace(new RegExp(find, 'g'), replace);
//}
