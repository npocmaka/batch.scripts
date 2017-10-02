@if (@X)==(@Y) @end /* JScript comment 
        @echo off 
        
        cscript //E:JScript //nologo "%~f0" %* 
		::pause
        exit /b %errorlevel% 
        
@if (@X)==(@Y) @end JScript comment */ 


/*
https://msdn.microsoft.com/en-us/library/windows/desktop/ms630826(v=vs.85).aspx#SharedSample007
https://msdn.microsoft.com/en-us/library/windows/desktop/ms630819(v=vs.85).aspx 
https://msdn.microsoft.com/en-us/library/windows/desktop/ms630829(v=vs.85).aspx
*/

////////////////////////////
////                      //
/**/     var QUALITY=100; //
////                      //
////////////////////////////

function printHelp(){
	WScript.Echo( WScript.ScriptName + " converts image from one format to another.Supported formats are BPM,JPG,PNG,GIF,TIFF");
	WScript.Echo( "");
	WScript.Echo( WScript.ScriptName + " source.file target.format [force]");
	WScript.Echo( "");
	WScript.Echo("source.file path to the file to be converted");
	WScript.Echo("target.format path to the fresult file.The extension of the file will be taken as the needed format in the result.");
	WScript.Echo("force - if argument given the target file will be overwritten if exists.");
}

if (WScript.Arguments.Length==0){
	printHelp();
}

if (WScript.Arguments.Length<2){
	WScript.Echo("Invalid arguments");
	printHelp();
	Wscript.Quit(1);
}

var force=false;
var source=WScript.Arguments.Item(0);
var target=WScript.Arguments.Item(1);
if(WScript.Arguments.Length==3){
	force=true;
}


var targetFormat=target.split(".")[target.split(".").length-1].toUpperCase();

var imageFile = new ActiveXObject("WIA.ImageFile"); 
var imageProcess = new ActiveXObject("WIA.ImageProcess");
var fileSystem = new ActiveXObject("Scripting.FileSystemObject");

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


if(!existsFile(source)){
	WScript.Echo("Source image: " + source +" does not exists");
	WScript.Quit(40);
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

//WScript.Echo(imageProcess.FilterInfos.Count); 
//var count=imageProcess.FilterInfos.Count; 



function ID2Format(id){
    var ids={};
    ids["{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}"]="BPM";
    ids["{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}"]="PNG";
    ids["{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}"]="GIF";
    ids["{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}"]="JPG";
    ids["{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}"]="TIFF";
    
    return ids[id];
}

function format2ID(format){
	formats={};
	formats["BMP"]="{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}";
	formats["PNG"]="{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}";
	formats["GIF"]="{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}";
	formats["JPG"]="{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}";
	formats["TIFF"]="{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}";
	
	return formats[format];
}

function loadImage(image,imageFile){
    try{
        image.LoadFile(imageFile);
    }catch(err){
       WScript.Echo("Probably "+imageFile+" is not a valid image file");
       WScript.Quit(3);
    }
}

function convert(image,format){
	var filterFormat=format2ID(format);
	if(filterFormat==null){
		WScript.Echo("not supported target format "+format);
		WScript.Quit(9);
	}
	
	imageProcess.Filters.Add(imageProcess.FilterInfos("Convert").FilterID);
	imageProcess.Filters(1).Properties("FormatID").Value = filterFormat;
	imageProcess.Filters(1).Properties("Quality").Value = QUALITY;
	
	return imageProcess.Apply(image);
}

loadImage(imageFile,source);
var sourceFormat=ID2Format(imageFile.FormatID);
if(sourceFormat!== targetFormat) {
	var converted=convert(imageFile,targetFormat);
	converted.SaveFile(target);
} else {
	fileSystem.CopyFile(source,target,force); 
}
