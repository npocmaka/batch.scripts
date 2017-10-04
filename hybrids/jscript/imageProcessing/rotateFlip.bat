@if (@X)==(@Y) @end /* JScript comment 
        @echo off 
        
        cscript //E:JScript //nologo "%~f0" %* 
		::pause
        exit /b %errorlevel% 
        
@if (@X)==(@Y) @end JScript comment */ 

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms630819(v=vs.85).aspx

var imageFile = new ActiveXObject("WIA.ImageFile"); 
var imageProcess = new ActiveXObject("WIA.ImageProcess");
var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
var ARGS=WScript.Arguments;



var flipVertical=false;
var flipHorizontal=false;
var frameIndex=0;
var rotation=0;

var force=false;

var source="";
var target="";
imageProcess.Filters.Add(imageProcess.FilterInfos("RotateFlip").FilterID);

/*
Rotates, in 90 degree increments, and Flips, horizontally or vertically.

RotationAngle  - Set the RotationAngle property to 90, 180, or 270 if you wish
                 to rotate, otherwise 0 [the default]
FlipHorizontal - Set the FlipHorizontal property to True if you wish to flip
                 the image horizontally, otherwise False [the default]
FlipVertical   - Set the FlipVertical property to True if you wish to flip
                 the image vertically, otherwise False [the default]
FrameIndex     - Set the FrameIndex property to the index of a frame if you
                 wish to modify a frame other than the ActiveFrame,
                 otherwise 0 [the default]


*/


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

function printHelp(){

	WScript.Echo( WScript.ScriptName + " rotates or flips image");
	WScript.Echo(" ");
	WScript.Echo( WScript.ScriptName + " -source source.file -target target.file [-flip-vertical yes|no] [-flip-horizontal yes|no] [-force yes|no] [-rotation-angle 0|90|180|270] [-frame-index -0.5 - 1]");
	WScript.Echo(" ");
	WScript.Echo("-source  - the image that will flipped or rotated.");
	WScript.Echo("-target  - the file where the transformations will be saved in.If the file extension format is different than the source it will be converted to the pointed one ");
	WScript.Echo("-flip-vertical  - Will the image be flipped vertically.Default is no.");
	WScript.Echo("-flip-horizontal  - Will the image be flipped horizontally.Default is no.");
	WScript.Echo("-rotation-angle   - The angle image will be rotated with.Default is 0.Accpeted values are 0,90,180,270.");
	WScript.Echo("-force  - If yes and the target file already exists , it will be overwritten");
	WScript.Echo("-frame-index - Have no idea what this is used for , but it is pressented in the rotation filter capabilities.Images with this and without looks the same.Accepted values are from -0.5 to 1");
	
}

function parseArguments(){
	if (WScript.Arguments.Length<4 || ARGS.Item(1).toLowerCase() == "-help" ||  ARGS.Item(1).toLowerCase() == "-h" ) {
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
		if (ARGS.Item(arg).toLowerCase() == "-flip-vertical" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			flipVertical=true;
		}
		if (ARGS.Item(arg).toLowerCase() == "-flip-horizontal" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			flipHorizontal=false;
		}
		if (ARGS.Item(arg).toLowerCase() == "-force" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			force=true;
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-rotation-angle") {
			try {
				rotation=(parseInt(ARGS.Item(arg +1)))%360;
				if(!(rotation==0 || rotation==90 || rotation==180 || rotation==270)){
					WScript.Echo("Wrong argument - accepted values for the roation angle are : 0,90,180,270");
					WScript.Quit(15);
				}
				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(10);
			}
			
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
}

function loadImage(image,imageFile){
    try{
       image.LoadFile(imageFile);
    }catch(err){
       WScript.Echo("Probably "+imageFile+" is not a valid image file");
       WScript.Quit(30);
    }
}

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

function convert(image,format){
	var ic=imageProcess.Filters.Count;
	var filterFormat=format2ID(format);
	if(filterFormat==null){
		WScript.Echo("not supported target format "+format);
		WScript.Quit(90);
	}
	imageProcess.Filters.Add(imageProcess.FilterInfos("Convert").FilterID);
	imageProcess.Filters(ic+1).Properties("FormatID").Value = filterFormat;
	imageProcess.Filters(ic+1).Properties("Quality").Value = 100;
	
	//return imageProcess.Apply(image);
}

// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
parseArguments();
var targetFormat=target.split(".")[target.split(".").length-1].toUpperCase();

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

loadImage(imageFile,source);
var sourceFormat=ID2Format(imageFile.FormatID);


imageProcess.Filters(1).Properties("RotationAngle") = rotation;
imageProcess.Filters(1).Properties("FlipHorizontal") = flipHorizontal;
imageProcess.Filters(1).Properties("FlipVertical") = flipVertical;
imageProcess.Filters(1).Properties("FrameIndex") = frameIndex;


if (sourceFormat !== targetFormat ){
	convert(resImg,targetFormat);
}
var resImg=imageProcess.Apply(imageFile);
resImg.SaveFile(target);
// -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
