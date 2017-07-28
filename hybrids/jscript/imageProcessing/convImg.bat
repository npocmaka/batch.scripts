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

var source=WScript.Arguments.Item(0);
var target=WScript.Arguments.Item(1);

var targetFormat=target.split(".")[target.split(".").length-1].toUpperCase();

var imageFile = new ActiveXObject("WIA.ImageFile"); 
var imageProcess = new ActiveXObject("WIA.ImageProcess"); 

//WScript.Echo(imageProcess.FilterInfos.Count); 
var count=imageProcess.FilterInfos.Count; 



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
	imageProcess.Filters(1).Properties("Quality").Value = 100;
	
	return imageProcess.Apply(image);
}

loadImage(imageFile,source);
var converted=convert(imageFile,targetFormat);
converted.SaveFile(target);
