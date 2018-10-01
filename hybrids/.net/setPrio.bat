@if (@X)==(@Y) @end /* JScript comment
@echo off

setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

"%~n0.exe" %* 
del "%~n0.exe"

endlocal & exit /b %errorlevel%

end of jscript comment*/

import System;
import System.Threading;
import System.Diagnostics;

var arguments:String[] = Environment.GetCommandLineArgs();

function printHelp( ) {
  print(arguments[0] + " pid prio");

}

if ( arguments.length == 1 || arguments[1].toLowerCase() == "-h" || arguments[1].toLowerCase() == "-help" ) {
	printHelp();
	Environment.Exit(0);
}

if ( arguments.length != 3) {
	print("wrong number of arguments");
	Environment.Exit(1);
}

try {
	var pid= Int32.Parse(arguments[1]);
}catch(err){
	print("process must be a number");
	Environment.Exit(2);
}

var prio=arguments[2].toLowerCase();
var proc="";
try{
	proc=Process.GetProcessById(pid);
}catch(err){
	print("process " + pid + " not found");
	Environment.Exit(3);
}

switch(prio) {
    case "abovenormal":
        proc.PriorityClass = ProcessPriorityClass.AboveNormal;
        break;
    case "belownormal":
        proc.PriorityClass = ProcessPriorityClass.AboveNormal;
        break;
	case "high":
        proc.PriorityClass = ProcessPriorityClass.High;
        break;
	case "idle":
        proc.PriorityClass = ProcessPriorityClass.Idle;
        break;
	case "normal":
        proc.PriorityClass = ProcessPriorityClass.Normal;
        break;
	case "realTime":
        proc.PriorityClass = ProcessPriorityClass.RealTime;
        break;
    default:
        print("invalid prio: " + prio + " given");
		Environment.Exit(5);
}

