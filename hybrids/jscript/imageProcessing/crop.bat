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

//default values

var top=0;
var right=0;
var bottom=0;
var left=0;

var frameIndex=0;

//image dimensions
var height=0
var width=0;

var percentage=false;
var force=false;

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

/*
The description of the Crop filter:

Left       - Set the Left property to the left margin (in pixels)
             if you wish to crop along the left, otherwise 0 [the default]
Top        - Set the Top property to the top margin (in pixels)
             if you wish to crop along the top, otherwise 0 [the default]
Right      - Set the Right property to the right margin (in pixels)
             if you wish to crop along the right, otherwise 0 [the default]
Bottom     - Set the Bottom property to the bottom margin (in pixels)
             if you wish to crop along the bottom, otherwise 0 [the default]
FrameIndex - Set the FrameIndex property to the index of a frame if you
             wish to modify a frame other than the ActiveFrame,
             otherwise 0 [the default]
*/

function fromPerc(){
	if(left>=100){
		WScript.Echo("Left percentage ("+left+") cannot be bigger or equal to 100");
		WScript.Quit(31);
	}
	if(top>=100){
		WScript.Echo("Top percentage ("+top+") cannot be bigger or equal to 100");
		WScript.Quit(35);
	}
	if(right>=100){
		WScript.Echo("Right percentage ("+right+") cannot be bigger or equal to 100");
		WScript.Quit(40);
	}
	if(bottom>=100){
		WScript.Echo("Bottom percentage ("+bottom+") cannot be bigger or equal to 100");
		WScript.Quit(45);
	}

	left=Math.round((width*left)/100);
	right=Math.round((width*right)/100);
	top=Math.round((height*top)/100);
	bottom=Math.round((height*bottom)/100);
	
}

function crop(left,top,right,bottom,height,width){
	if(top<0 || bottom <0 || left<0 || right<0){
		WScript.Echo("Crop margins cannot be negative");
		WScript.Quit(9);
	}
	
	if((left+right)>=width){
		WScript.Echo("Crop from left combined with right("+left+";"+right +") can't be bigger than the width: "+width);
		WScript.Quit(10);
	}

	if((top+bottom)>=height){
		WScript.Echo("Crop from top combined with bottom ("+top+";"+bottom +") can't be bigger than the height: "+height);
		WScript.Quit(20);
	}

	
	var ic=imageProcess.Filters.Count;
	imageProcess.Filters.Add(imageProcess.FilterInfos("Crop").FilterID);
	
	imageProcess.Filters(ic+1).Properties("Left") = left;
	imageProcess.Filters(ic+1).Properties("Right") = right;
	imageProcess.Filters(ic+1).Properties("Top") = top;
	imageProcess.Filters(ic+1).Properties("Bottom") = bottom;
	imageProcess.Filters(ic+1).Properties("FrameIndex") =frameIndex;
}

function printHelp(){

	WScript.Echo( WScript.ScriptName + " - crops image");
	WScript.Echo(" ");
	WScript.Echo( WScript.ScriptName + "-source source.file -target file.format [-percentage yes|no] [-top number] [-left number] [-right number] [-bottom number]  [-force yes|no] [-frame-index -0.5..1] ");
	WScript.Echo("-source  - the image that will flipped or rotated.");
	WScript.Echo("-target  - the file where the transformations will be saved in.If the file extension format is different than the source it will be converted to the pointed one ");
	WScript.Echo("-percentage  - whether the crop margins will be calculated in pixels or in percentages.If yes percentages will be used");
	WScript.Echo("-top  - how much will be cropped from the top.Default is 0.Combined with -bottom cannot overexceed the height of the source");
	WScript.Echo("-bottom  - how much will be cropped from the bottom.Default is 0.Combined with -top cannot overexceed the height of the source");
	WScript.Echo("-right  - how much will be cropped from the right.Default is 0.Combined with -left cannot overexceed the wifth of the source");
	WScript.Echo("-left  - how much will be cropped from the left.Default is 0.Combined with -right cannot overexceed the wifth of the source");
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
		
		if (ARGS.Item(arg).toLowerCase() == "-bottom") {
			try {
				bottom=parseInt(ARGS.Item(arg +1));				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(16);
			}
			
		}
		
		if (ARGS.Item(arg).toLowerCase() == "-right") {
			try {
				right=parseInt(ARGS.Item(arg +1));				
			} catch (err){
				WScript.Echo("Wrong argument:");
				WScript.Echo(err.message);
				WScript.Quit(17);
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

if(percentage){
	fromPerc();
}
/////----
crop(left,top,right,bottom,height,width);
/////---

if (sourceFormat !== targetFormat ){
	convert(resImg,targetFormat);
}

var resImg=imageProcess.Apply(imageFile);
resImg.SaveFile(target);
