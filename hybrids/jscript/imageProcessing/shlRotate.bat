@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */


FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;
if (ARGS.Length < 2 ) {
 WScript.Echo("insufficient arguments:");
 WScript.Quit(1);
}
var filename=ARGS.Item(0);
var action=ARGS.Item(1).toLowerCase();
var objShell=new ActiveXObject("Shell.Application");

//////
//
var useLanguageDependantVervs=false;
//
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
		verbs persisten handlers are described in HKEY_CLASSES_ROOT\CLSID\{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}
		and can be used independently from the language settings:
		
		[HKEY_CLASSES_ROOT\CLSID\{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}]
		@="Windows Photo Viewer Image Verbs"
		"ContextMenuOptIn"=""
		"ImplementsVerbs"="printto;rotate90;rotate270;setwallpaper;slideshow"
		
		language dependent verbs
		
		Set as desktop &background
		Rotate righ&t
		Rotate &left
		
	*/
	if(!useLanguageDependantVervs){
		switch(action){
			case 'rotateleft':
				objItem.InvokeVerb("rotate270");
				break;
			case 'rotateright':
				WScript.Echo('Rotating "'+fullFilename+'" right')
				objItem.InvokeVerb("rotate90");
				break;
			case 'setwallpaper':
				objItem.InvokeVerb("setwallpaper");
				break;
			default:
				WScript.Echo("not supported: "+ARGS.Item(1));
				WScript.Quit(3);
				break;
		}
	}
	
	if(useLanguageDependantVervs && verbs != null){
		
		for (var i=0;i<verbs.Count;i++){
			if( action=='rotateleft' &&
			replaceAll("&","",verbs.Item(i).Name).indexOf("Rotate left") > -1 ){
				WScript.Echo('Rotating "'+fullFilename+'" left');
				verbs.Item(i).DoIt();
				return;
			}
			
			if( action=='rotateright' &&
			replaceAll("&","",verbs.Item(i).Name).indexOf("Rotate right") > -1 ){
				WScript.Echo('Rotating "'+fullFilename+'" right');
				verbs.Item(i).DoIt();
				return;
			}
			
			if( action=='setwallpaper' &&
			replaceAll("&","",verbs.Item(i).Name).indexOf("desktop background") > -1 ){
				WScript.Echo('Setting "'+fullFilename+'" as wallpaper');
				verbs.Item(i).DoIt();
				return;
			}
		}
	}
	
}
main();

function replaceAll(find, replace, str) {
  return str.replace(new RegExp(find, 'g'), replace);
}
