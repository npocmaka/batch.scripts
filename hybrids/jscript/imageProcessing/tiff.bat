@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

var imageFile = new ActiveXObject("WIA.ImageFile"); 
var imageProcess = new ActiveXObject("WIA.ImageProcess");
var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
var ARGS=WScript.Arguments;

var imageList="";
//var images;
var files=[];

var source="";
var target="";

////////////////////////////
////                      //
/**/     var QUALITY=100; //
////                      //
////////////////////////////

function existsFile(path){
	if (fileSystem.FileExists(path))
		return true;
}

function existsFolder(path){
	if (fileSystem.FolderExists(path))
		return true;
}

function deleteFile(path){
	fileSystem.DeleteFile(path);
}

var force=false;
var frameIndex=0;

function createImageFiles(){
	for(var i=0;i<files.length;i++){
		eval("var page"+i +" =new ActiveXObject('WIA.ImageFile')");
		eval("page"+i +".LoadFile(files["+i+"])");
		
	}
}

function frame(){

	for(var i=0;i<files.length;i++){
		var ic=imageProcess.Filters.Count;
		imageProcess.Filters.Add(imageProcess.FilterInfos("Frame").FilterID);
		eval("imageProcess.Filters(ic+1).Properties('ImageFile')=page"+i);
	}
	ic=imageProcess.Filters.Count;
	imageProcess.Filters.Add(imageProcess.FilterInfos("Convert").FilterID);
	//imageProcess.Filters(ic+1).Properties("FormatID").Value="{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}";
	imageProcess.Filters(ic+1).Properties("FormatID").Value = "{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}";
	imageProcess.Filters(ic+1).Properties("Quality").Value = QUALITY;
}

function printHelp(){
	WScript.Echo( WScript.ScriptName + " - creates multi page tiff image");
	WScript.Echo(" ");
	WScript.Echo(WScript.ScriptName + "-source source.file -target target.tiff [-force yes|no]" +
	"-image-list \"file[;file2[;..]]\"");
	WScript.Echo("-source  - the image over which tiff pages will be set");
	WScript.Echo("-target  - file where the multi page tiff will be saves");
	WScript.Echo("-image-list  - list of files separated with \";\" which will be used as tiff pages");
	WScript.Echo("-force  - If yes and the target file already exists , it will be overwritten");
	WScript.Echo("-frame-index - Have no idea what this is used for , but it is pressented in the rotation filter capabilities.Images with this and without looks the same.Accepted values are from -0.5 to 1");
}

(function parseArguments(){
	if (WScript.Arguments.Length<6 || ARGS.Item(1).toLowerCase() == "-help" ||  ARGS.Item(1).toLowerCase() == "-h" ) {
		printHelp();
		WScript.Quit(0);
   }
   
   	if (WScript.Arguments.Length % 2 == 1 ) {
		WScript.Echo("Illegal arguments ");
		printHelp();
		WScript.Quit(1);
	}
	
	//ARGS
	for(var arg = 0 ; arg<ARGS.Length-1;arg=arg+2) {
		if (ARGS.Item(arg) == "-source") {
			source = ARGS.Item(arg +1);
		}
		if (ARGS.Item(arg) == "-target") {
			target = ARGS.Item(arg +1);
		}
		if (ARGS.Item(arg) == "-image-list") {
			imageList = ARGS.Item(arg +1);
		}

		if (ARGS.Item(arg).toLowerCase() == "-force" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			force=true;
		}
	
		
		if (ARGS.Item(arg).toLowerCase() == "-frame-index") {
			try {
				frameIndex=parseFloat(ARGS.Item(arg +1));
				if(frameIndex<-0.5 || frameIndex > 1){
					WScript.Echo("Wrong argument - frame index should be between -0.5 and 1");
					WScript.Quit(25);
				}
				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(20);
			}			
		}		
	}
	
	if (target==""){
		WScript.Echo("Target file not passed");
		WScript.Quit(5);
	}
	
	if(source==""){
		WScript.Echo("Source file not passed");
		WScript.Quit(6);
	}
	
	if(imageList==""){
		WScript.Echo("Page files not passed");
		WScript.Quit(7);
	}
	files=imageList.split(";");
	
}());


if(!existsFile(source)){
	WScript.Echo("Source image: " + source +" does not exists");
	WScript.Quit(40);
}

for(var i=0;i<files.length;i++){
	if(!existsFile(files[i])){
		WScript.Echo("page image: " + files[i] +" does not exists");
		WScript.Quit(41);
	}
}

if(existsFile(target) && !force){
	WScript.Echo("Target image: " + target +" already exists");
	WScript.Quit(45);
}

if(existsFolder(target)){
	WScript.Echo("There's existing folder with the target file  (" + target +") name");
	WScript.Quit(46);
}

if(existsFile(target) && force){
	deleteFile(target);
}
imageFile.LoadFile(source);
//createImageFiles();
//
	for(var i=0;i<files.length;i++){
		eval("var page"+i +" =new ActiveXObject('WIA.ImageFile')");
		eval("page"+i +".LoadFile(files["+i+"])");
		
	}
//

frame();
var resImg=imageProcess.Apply(imageFile);
resImg.SaveFile(target);
