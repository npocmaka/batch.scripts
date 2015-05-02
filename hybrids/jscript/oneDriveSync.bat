@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" "%~nx0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

//gets an information that normally is acquired by right click-details 
// can get image dimensions , media file play time and etc.
 
////// 
FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var objShell=new ActiveXObject("Shell.Application");
var ARGS = WScript.Arguments;

//fso
ExistsItem = function (path) {
	return FSOObj.FolderExists(path)||FSOObj.FileExists(path);
}

getFullPath = function (path) {
    return FSOObj.GetAbsolutePathName(path);
}
//

if ( (ARGS.Length>1) && (ARGS.Item(1).toLowerCase()=="-help")) {
	WScript.Echo(ARGS.Item(0)+" [oneDriveLocation|OneDriveShortcut]");
	WScript.Echo("If location not defined default will be taken");
	WScript.Quit(0);
}



if ( ARGS.Length > 1 && ARGS.Item(1).toLowerCase!=="-help") {
	var filename=ARGS.Item(1);
} else {
	var wshShell = new ActiveXObject( "WScript.Shell" );
	var up=wshShell.ExpandEnvironmentStrings( "%USERPROFILE%" );
	var filename=up+"\\"+"OneDrive";
	
	//WScript.Echo(oneD);
	if(!ExistsItem(filename)){
		try {
			filename=wshShell.RegRead( "HKCU\\Software\\Microsoft\\SkyDrive\\UserFolder");
		}catch (err){
			WScript.Echo("OneDrive probably not installed");
			WScript.Echo(err.message);
			WScript.Quit(5);
		}
		
		if((!ExistsItem(filename))) {
			WScript.Echo("OneDrive not found where it should be");
			WScript.Quit(6);
		}	
	}
}

/////

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
		WScript.Echo("Check if OneDrive is installed");
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
			if(verbs.Item(i).Name === "Sync"){
				verbs.Item(i).DoIt();
				WScript.Echo("Sync started");
				return;
			}
			//WScript.Echo(verbs.Item(i).Name);
		}
		
		WScript.Echo("The Sync is not active.Check your OneDrive settings");
		WScript.Quit(3);
		return;
	}	
}
main();
WScript.Quit(0);
