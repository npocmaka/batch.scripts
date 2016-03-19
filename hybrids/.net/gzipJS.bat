@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /w:0 /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe %*

endlocal & exit /b %errorlevel%


*/


import System;
import System.Collections.Generic;
import System.IO;
import System.IO.Compression;


	
	function CompressFile(source,destination){
		var sourceFile=File.OpenRead(source);
		var destinationFile=File.Create(destination);
		var output = new  GZipStream(destinationFile,CompressionMode.Compress);
		Console.WriteLine("Compressing {0} to {1}.", sourceFile.Name,destinationFile.Name, false);
		var byteR = sourceFile.ReadByte();
		while(byteR !=- 1){
			output.WriteByte(byteR);
			byteR = sourceFile.ReadByte();
		}
		sourceFile.Close();
		output.Flush();
		output.Close();
		destinationFile.Close();
	}

	function UncompressFile(source,destination){
		var sourceFile=File.OpenRead(source);
		var destinationFile=File.Create(destination);
		
		var input = new GZipStream(sourceFile,
            CompressionMode.Decompress, false);
		Console.WriteLine("Decompressing {0} to {1}.", sourceFile.Name,
                destinationFile.Name);
		
		var byteR=input.ReadByte();
		while(byteR !== -1){
			destinationFile.WriteByte(byteR);
			byteR=input.ReadByte();
		}
		destinationFile.Close();
		input.Close();
		
		
	}
	
	function isGzip(source,errorlevel){
		var sourceFile=File.OpenRead(source);
		
		var input = new GZipStream(sourceFile,
            CompressionMode.Decompress, false);
		var onSuccess;
		try{
			onSuccess=Int32.Parse(errorlevel);
		}catch(err){
			Console.WriteLine('Invalid Number passed');
			onSuccess=0;
		}
		try {
			var b=input.ReadByte();
			input.Close();
			Console.WriteLine('valid');
			Environment.Exit(onSuccess);
		}catch(err){
			Console.WriteLine('invalid');
		}
			
	}
	
var arguments:String[] = Environment.GetCommandLineArgs();

	function printHelp(){
		Console.WriteLine("Compress and uncompress gzip files:");
		Console.WriteLine("Compress:");
		Console.WriteLine(arguments[0]+" -c source destination");
		Console.WriteLine("Uncompress:");
		Console.WriteLine(arguments[0]+" -u source destination");
		Console.WriteLine("Check gzip file:");
		Console.WriteLine(arguments[0]+" -k source errorlevelOnSuccess");
			
	}

if (arguments.length!=4){
	Console.WriteLine("Wrong arguments");
	printHelp();
	Environment.Exit(1);
}

switch (arguments[1]){
	case "-c":
		CompressFile(arguments[2],arguments[3]);
		break;
	case "-u":
		UncompressFile(arguments[2],arguments[3]);
		break;
	case "-k":
		isGzip(arguments[2],arguments[3]);
		break;
	default:
		Console.WriteLine("Wrong arguments");
		printHelp();
		Environment.Exit(1);
}
