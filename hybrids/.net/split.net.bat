@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe  %*

endlocal & exit /b %errorlevel%

*/

import System;
import System.IO;

var arguments:String[] = Environment.GetCommandLineArgs();

if (arguments.length<3){
	Console.WriteLine("Wrong arguments");
	Console.WriteLine("usage:");
	Console.WriteLine(arguments[0]+"file_to_split size_in_bytes");
	Environment.Exit(1);
}

var file=arguments[1];
var max_size=parseInt(arguments[2]);

if (max_size<=0){
	Console.WriteLine("size must be bigger than zero");
	Environment.Exit(2);
}

if (!File.Exists(file)){
	Console.WriteLine("file"+file+" does not exist");
	Environment.Exit(3);
}

function writeData(file,data:byte[]){
	Console.WriteLine(data.Length);
	var writer = new BinaryWriter(File.Open(file, FileMode.Create));
	writer.Write(data);
	writer.Close();
}

function  chunker(inputFile, chunkSize){
	
	var part=0;
	var reader= new BinaryReader(File.Open(inputFile, FileMode.Open));
	var data:byte[]=reader.ReadBytes(chunkSize);

	while(reader.BaseStream.Position !== reader.BaseStream.Length) {
		part++;
		Console.WriteLine("Processing part " + part);
		writeData(inputFile+".part."+part,data);
		data=reader.ReadBytes(chunkSize);

	}
	if (data.Length !== 0) {
		part++;
		Console.WriteLine("Processing part " + part)
		writeData(inputFile+".part."+part,data);	
	}
	reader.Close();
}

chunker(file,max_size);
