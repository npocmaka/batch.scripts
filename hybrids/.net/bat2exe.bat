@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

del %~n0.exe /q /s >nul 2>nul

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

%~n0.exe  "%jsc%" %*
del /q /f %~n0.exe 1>nul 2>nul 
endlocal & exit /b %errorlevel%
*/

//https://github.com/npocmaka/batch.scripts/blob/master/hybrids/.net/bat2exe.bat
import System;
import System;
import System.IO;
import  System.Diagnostics;


var arguments:String[] = Environment.GetCommandLineArgs();
if (arguments.length<3){
    Console.WriteLine("Path to cmd\bat file not given");
    Environment.Exit(1);
}

var binName=Path.GetFileName(arguments[2])+".exe";
if(arguments.length>3){
	binName=Path.GetFileName(arguments[3]);
}
var batchContent:byte[]= File.ReadAllBytes(arguments[2]);
var compilerLoc=arguments[1];

var content="["

for (var i=0;i<batchContent.length-1;i++){
    content=content+batchContent[i]+","
}
content=content+batchContent[batchContent.length-1]+"]";
var temp=Path.GetTempPath();
var dt=(new Date()).getTime();
var tempJS=temp+"\\2exe"+dt+".js";


var toCompile="\r\n\
import System;\r\n\
import System.IO;\r\n\
import  System.Diagnostics;\r\n\
var batCommandLine:String='';\r\n\
//Remove the executable name from the command line\r\n\
try{\r\n\
var arguments:String[] = Environment.GetCommandLineArgs();\r\n\
batCommandLine=Environment.CommandLine.substring(arguments[0].length,Environment.CommandLine.length);\r\n\
}catch(e){}\r\n\
var content2:byte[]="+content+";\r\n\
var dt=(new Date()).getTime();\r\n\
var temp=Path.GetTempPath();\r\n\
var nm=Process.GetCurrentProcess().ProcessName.substring(0,Process.GetCurrentProcess().ProcessName.length-3);\r\n\
var tempBatPath=Path.Combine(temp,nm+dt+'.bat');\r\n\
File.WriteAllBytes(tempBatPath,content2);\r\n\
var pr=System.Diagnostics.Process.Start('cmd.exe','/c '+' '+tempBatPath+' '+batCommandLine);\r\n\
pr.WaitForExit();\r\n\
File.Delete(tempBatPath);\r\n\
";

File.WriteAllText(tempJS,toCompile);
var pr=System.Diagnostics.Process.Start(compilerLoc,'/nologo /out:"'+binName+'" "'+tempJS+'"');
pr.WaitForExit();
File.Delete(tempJS);
