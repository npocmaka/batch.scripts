@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe  "%jsc%" %*

endlocal & exit /b %errorlevel%


*/

//https://github.com/npocmaka/batch.scripts/blob/master/hybrids/.net/bat2exe.bat
import System;
import System;
import System.IO;


var arguments:String[] = Environment.GetCommandLineArgs();
if (arguments.length<3){
	Console.WriteLine("Path to cmd\bat file not given");
	Environment.Exit(1);
}
//Console.WriteLine(arguments[2])
var binName=Path.GetFileName(arguments[2])+".exe";
var batchContent:byte[]= File.ReadAllBytes(arguments[2]);
var compilerLoc=arguments[1];
var content="["

for (var i=0;i<batchContent.length-1;i++){
	content=content+batchContent[i]+","
}
content=content+batchContent[batchContent.length-1]+"]";
var temp=Path.GetTempPath();
Console.WriteLine(temp);
var dt=(new Date()).getTime();
var tempJS=temp+"\\2exe"+dt+".js";

//File.WriteAllBytes("here",batchContent);


var toCompile="\r\n\
import System;\r\n\
import System.IO;\r\n\
var arguments:String[] = Environment.GetCommandLineArgs();\r\n\
//Remove the executable name from the command line\r\n\
var batCommandLIne=Environment.CommandLine.substring(arguments[0].length,Environment.CommandLine.length);\r\n\
var contet2:byte[]="+content+";\r\n\
var dt=(new Date()).getTime();\r\n\
var temp=Path.GetTempPath();\r\n\
var tempBatPath=Path.Combine(temp,arguments[0]+dt+'.bat');;\r\n\
File.WriteAllBytes(tempBatPath,contet2);\r\n\
System.Diagnostics.Process.Start('cmd.exe','/c '+' '+tempBatPath+' '+batCommandLIne);\r\n\
File.Delete(tempBatPath);\r\n\
";

File.WriteAllText(tempJS,toCompile);
System.Diagnostics.Process.Start(compilerLoc,'/nologo /out:'+binName+' '+tempJS);
File.Delete(tempJS);




