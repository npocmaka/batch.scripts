@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;
if (ARGS.Length < 1 ) {
 WScript.Echo("No file passed");
 WScript.Echo("Usage:");
 WScript.Echo(" Image");
 WScript.Quit(1);
}
var filename=ARGS.Item(0);

if (!FSOObj.FileExists(filename)){
	WScript.Echo("File "+filename+" does not exists");
	WScript.Quit(2);
}

var img=new ActiveXObject("WIA.ImageFile");
try {
	img.LoadFile(filename);
}catch(err){
	WScript.Echo("Probably "+ filename + " is not an image");
	WScript.Echo(err.message);
	WScript.Quit(3);
	
}

WScript.Echo("Height:"+img.Height);
WScript.Echo("Width:"+img.Width);
WScript.Echo("HorizontalResolution:"+img.HorizontalResolution);
WScript.Echo("VerticalResolution:"+img.VerticalResolution);
WScript.Echo("Format:"+img.FormatID);
WScript.Echo("ActiveFrame:"+img.ActiveFrame);
WScript.Echo("Type:"+img.FileExtension);
WScript.Echo("FrameCount:"+img.FrameCount);
WScript.Echo("IsAnimated:"+img.IsAnimated);
WScript.Echo("PixelDepth:"+img.PixelDepth);
WScript.Echo("IsExtendedPixelFormat:"+img.IsExtendedPixelFormat);
WScript.Echo("IsAlphaPixelFormat:"+img.IsAlphaPixelFormat);
