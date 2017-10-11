@if (@X)==(@Y) @end /* JScript comment 
        @echo off        
        cscript //E:JScript //nologo "%~f0" %* 
		::pause
        exit /b %errorlevel%       
@if (@X)==(@Y) @end JScript comment */ 

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms630819(v=vs.85).aspx

var imageFile = new ActiveXObject("WIA.ImageFile"); 
var imageFileStamp = new ActiveXObject("WIA.ImageFile"); 
var imageProcess = new ActiveXObject("WIA.ImageProcess");
var fileSystem = new ActiveXObject("Scripting.FileSystemObject");
var ARGS=WScript.Arguments;

/****
Stamp filter description

Stamps the specified ImageFile at the specified Left and Top coordinates.

ImageFile  - Set the ImageFile property to the ImageFile object that you wish
             to stamp
Left       - Set the Left property to the offset from the left (in pixels)
             that you wish to stamp the ImageFile at [default is 0]
Top        - Set the Top property to the offset from the top (in pixels) that
             you wish to stamp the ImageFile at [default is 0]
FrameIndex - Set the FrameIndex property to the index of a frame if you wish to
             modify a frame other than the ActiveFrame, otherwise 0
             [the default]
****/

//defaults

var maxWidth=0;
var maxHeight=0;

var pRatio=true;
var frameIndex=0;

var source="";
var target="";
var stamp="";

var force=false;

var height=0;
var width=0;

var top=0;
var left=0;

percentage=false;
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

function loadImage(image,imageFile,isSource){
    try{
       image.LoadFile(imageFile);
    }catch(err){
       WScript.Echo("Probably "+imageFile+" is not a valid image file");
	   WScript.Echo(err.message);
       WScript.Quit(30);
    }
	if(isSource){
		height=image.Height;
		width=image.Width;
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
	var formats={};
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

function stamping(stampImage) {
	var ic=imageProcess.Filters.Count;
	imageProcess.Filters.Add(imageProcess.FilterInfos("Stamp").FilterID);
	imageProcess.Filters(ic+1).Properties("ImageFile")=stampImage;
	imageProcess.Filters(ic+1).Properties("Left")=left;
	imageProcess.Filters(ic+1).Properties("Top")=top;
	imageProcess.Filters(ic+1).Properties("FrameIndex")=frameIndex;
}


function fromPerc(){
	top=Math.round((height*top)/100);
	left=Math.round((width*left)/100);
	if(left==0)
		left=1;
	if(top==0)
		top=1;
}

function printHelp(){

	WScript.Echo( WScript.ScriptName + " - samps image over another with a given offset");
	WScript.Echo(" ");
	WScript.Echo(WScript.ScriptName + "-source source.file -stamp stamp.file -target file.format [-top top] \n\r" +
	"[-left left] [-percentage yes|no]  [-frame-index -0.5..1] ");
	WScript.Echo("-source  - the image that will flipped or rotated.");
	WScript.Echo("-target  - the file where the transformations will be saved in.If the file extension format is different than the source it will be converted to the pointed one.Supported formats are BMp,JPG,GIF,TIFF,PNG");
	WScript.Echo("-stamp  - path to image that will be stamped over the source image");
	WScript.Echo("-percentage  - whether the rescale will be calculated in pixels or in percentages.If yes percentages will be used.Default is no.");
	WScript.Echo("-force  - If yes and the target file already exists , it will be overwritten");
	WScript.Echo("-top - offset from the top.Cannot be bigger than the source height.Default is 0.");
	WScript.Echo("-left - offset from the left.Cannot be bigger than the source width.Default is 0.");
	WScript.Echo("-frame-index - Have no idea what this is used for , but it is pressented in the rotation filter capabilities.Images with this and without looks the same.Accepted values are from -0.5 to 1");
	
}


//--
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
		if (ARGS.Item(arg) == "-stamp") {
			stamp = ARGS.Item(arg +1);
		}

		if (ARGS.Item(arg).toLowerCase() == "-force" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			force=true;
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-percentage" && (ARGS.Item(arg +1).toLowerCase() == "yes" || ARGS.Item(arg +1).toLowerCase() == "true") ) {
			percentage=true;
		}
		

		
		if (ARGS.Item(arg).toLowerCase() == "-top") {
			try {
				top=parseInt(ARGS.Item(arg +1));				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(10);
			}
			
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-left") {
			try {
				left=parseInt(ARGS.Item(arg +1));				
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
	
	if(stamp==""){
		WScript.Echo("Stamp file not passed");
		WScript.Quit(7);
	}
}());
//--


if(!existsFile(source)){
	WScript.Echo("Source image: " + source +" does not exists");
	WScript.Quit(40);
}

if(!existsFile(stamp)){
	WScript.Echo("Stamp image: " + stamp +" does not exists");
	WScript.Quit(41);
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

loadImage(imageFile,source,true);
loadImage(imageFileStamp,stamp,false);

if(percentage){
	fromPerc();
}


if(top>height){
	WScript.Echo("Top offset cannot be bigger than image height");
	WScript.Quit(50);
}

if(left>height){
	WScript.Echo("Left offset cannot be bigger than image width");
	WScript.Quit(55);
}


var targetFormat=target.split(".")[target.split(".").length-1].toUpperCase();
var sourceFormat=ID2Format(imageFile.FormatID);



stamping(imageFileStamp);

if (sourceFormat !== targetFormat ){
	convert(resImg,targetFormat);
}

var resImg=imageProcess.Apply(imageFile);
resImg.SaveFile(target);
