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

/******
Scale filter description:

Scales image to the specified Maximum Width and Maximum Height preserving
Aspect Ratio if necessary.


MaximumWidth        - Set the MaximumWidth property to the width (in pixels)
                      that you wish to scale the image to.
MaximumHeight       - Set the MaximumHeight property to the height (in pixels)
                      that you wish to scale the image to.
PreserveAspectRatio - Set the PreserveAspectRatio property to True
                      [the default] if you wish to maintain the current aspect
                      ration of the image, otherwise False and the image will
                      be stretched to the MaximumWidth and MaximumHeight
FrameIndex          - Set the FrameIndex property to the index of a frame if
                      you wish to modify a frame other than the ActiveFrame,
                      otherwise 0 [the default]
					  

******/

//defaults

var maxWidth=0;
var maxHeight=0;

var pRatio=true;
var frameIndex=0;

var source="";
var target="";

var force=false;

var height=0;
var width=0;

var percentage=false;

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

function loadImage(image,imageFile){
    try{
       image.LoadFile(imageFile);
    }catch(err){
       WScript.Echo("Probably "+imageFile+" is not a valid image file");
	   WScript.Echo(err.message);
       WScript.Quit(30);
    }
	height=image.Height;
	width=image.Width;
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
	imageProcess.Filters(ic+1).Properties("Quality").Value = QUALITY;
}

function scale(){
	if(maxHeight<=0){
		WScript.Echo("MaximumHeight ("+maxHeight+") should be bigger than 0");
		WScript.Quit(80);
	}
	
	if(maxWidth<=0){
		WScript.Echo("MaximumHeight ("+maxWidth+") should be bigger than 0");
		WScript.Quit(81);
	}
	
	var ic=imageProcess.Filters.Count;
	//var filterFormat=format2ID(format);
	imageProcess.Filters.Add(imageProcess.FilterInfos("Scale").FilterID);
	
	imageProcess.Filters(ic+1).Properties("MaximumWidth").Value = maxWidth;
	imageProcess.Filters(ic+1).Properties("MaximumHeight").Value = maxHeight;
	//WScript.Echo(pRatio+"::"+maxWidth+"::"+maxHeight+">>"+width+"++"+height);
	imageProcess.Filters(ic+1).Properties("PreserveAspectRatio").Value = pRatio;
	imageProcess.Filters(ic+1).Properties("FrameIndex").Value = frameIndex;
}

function fromPerc(){
	maxWidth=Math.round((width*maxWidth)/100);
	maxHeight=Math.round((height*maxHeight)/100);
	if(maxHeight==0)
		maxHeight=1;
	if(maxWidth==0)
		maxWidth=1;
}


function printHelp(){

	WScript.Echo( WScript.ScriptName + " - resizes an image");
	WScript.Echo(" ");
	WScript.Echo(WScript.ScriptName + "-source source.file -target file.format [-max-height height] [-max-width width] [-percentage yes|no] [-keep-ratio yes|no] [-frame-index -0.5..1] ");
	WScript.Echo("-source  - the image that will flipped or rotated.");
	WScript.Echo("-target  - the file where the transformations will be saved in.If the file extension format is different than the source it will be converted to the pointed one.Supported formats are BMp,JPG,GIF,TIFF,PNG");
	WScript.Echo("-percentage  - whether the rescale will be calculated in pixels or in percentages.If yes percentages will be used.Default is no.");
	WScript.Echo("-force  - If yes and the target file already exists , it will be overwritten");
	WScript.Echo("-max-height - max height of the image");
	WScript.Echo("-max-width - max width of the image");
	WScript.Echo("-keep-ratio - if dimensions ratio will be preserved.Default is yes");
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

		if (ARGS.Item(arg).toLowerCase() == "-force" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			force=true;
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-percentage" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			percentage=true;
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-keep-ratio" && (ARGS.Item(arg +1).toLowerCase() == "no" || ARGS.Item(arg +1).toLowerCase() == "false") ) {
			pRatio=false;
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-max-width") {
			try {
				maxWidth=parseInt(ARGS.Item(arg +1));				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(10);
			}
			
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-max-height") {
			try {
				maxHeight=parseInt(ARGS.Item(arg +1));				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(15);
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

parseArguments();

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

var targetFormat=target.split(".")[target.split(".").length-1].toUpperCase();
loadImage(imageFile,source);
var sourceFormat=ID2Format(imageFile.FormatID);


if(maxWidth==0 && !percentage){
	maxWidth=width;
}

if(maxHeight==0 && !percentage){
	maxHeight=height;
}

if(maxWidth==0 && percentage){
	maxWidth=100;
}

if(maxHeight==0 && percentage){
	maxHeight=100;
}


if(percentage){
	fromPerc();
}



///
scale();
///

if (sourceFormat !== targetFormat ){
	convert(resImg,targetFormat);
}

var resImg=imageProcess.Apply(imageFile);
resImg.SaveFile(target);
