@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe %* 2>nul

endlocal & exit /b %errorlevel%


*/

import System;
import System.Diagnostics;


var arguments:String[] = Environment.GetCommandLineArgs();

var command="";
var command_args="";
var pid=0;
var priorityClass=ProcessPriorityClass.Normal;
var processorAffinity=1;
var workingDirectory=".";
var windowStyle=ProcessWindowStyle.Hidden;

var newWindows=true;
var redirectStandartError=false;
var redirectStandartInput=false;
var redirectStandartOutput=false;
var useShellExecute=true;

//var verbose=false;


function printHelp(){
	Console.WriteLine(arguments[0] + " starts a process in different modes");
	Console.WriteLine("Usage:");
	Console.WriteLine(arguments[0] + " command [-option value]");
	Console.WriteLine("Options:");
	Console.WriteLine("-style Hidden|Normal|Maximized|Minimized");
	Console.WriteLine("-arguments command_arguments");
	Console.WriteLine("-priority Normal|High|BellowNormal|AboveNormal|RealTime|Idle");
	Console.WriteLine("-directory working_directory");
	Console.WriteLine("-newWindow yes|no");
	Console.WriteLine("-affinity 1..7");
	Console.WriteLine("-redirectError yes|no");
	Console.WriteLine("-redirectInput yes|no");
	Console.WriteLine("-redirectOutput yes|no");
	Console.WriteLine("-useshellexecute yes|no");
	Console.WriteLine("");
	Console.WriteLine("More Info: https://msdn.microsoft.com/en-us/library/system.diagnostics.processstartinfo%28v=vs.110%29.aspx");
	
}

function parseArgs(){
	
	if (arguments[1] == "-h" || arguments[1] == "-help"){
		printHelp();
	}
	
	if (arguments.length<2){
		Console.WriteLine("Wrong arguments");
		printHelp();
		Environment.Exit(1);
	}
	
	if (arguments.length%2 != 0){
		Console.WriteLine("Wrong number of arguments");
		printHelp();
		Environment.Exit(2);
	}
	
	command=arguments[1];
	
	for (var i=2;i<arguments.length-1;i=i+2){
		var arg=arguments[i].ToLower();
		switch (arg){
			case "-style" :
				windowStyle=setStyle(arguments[i+1]);
				break;
			case "-arguments" :
				command_args=arguments[i+1];
				break;
			case "-affinity" :
				processorAffinity=parseInt(arguments[i+1]);
				break;
			case "-directory" :
				workingDirectory=arguments[i+1];
				break;
			case "-priority" :
				priorityClass=setPrio(arguments[i+1]);
				break;
			case "-newwindow" :
				if (arguments[i+1].ToLower() == "yes"){
					newWindows=true;
				}
				break;
			case "-redirecterror" :
				if (arguments[i+1].ToLower() == "no"){
					redirectStandartError=false;
				}
				break;
			case "-redirectoutput" :
				if (arguments[i+1].ToLower() == "no"){
					redirectStandartOutput=false;
				}
				break;
			case "-redirectinput" :
				if (arguments[i+1].ToLower() == "no"){
					redirectStandartInput=false;
				}
				break;
			case "-useshellexecute" :
				if (arguments[i+1].ToLower() == "no"){
					useShellExecute=false;
				}
				break;
			default :
				Console.WriteLine("Wrong argument: " + arguments[i] );
				Environment.Exit(3);
		}
	}
	
	function setPrio(pr){
		switch(pr.ToLower()) {
			case "normal":
				return ProcessPriorityClass.Normal;
			case "high":
				return ProcessPriorityClass.High;
			case "idle":
				return ProcessPriorityClass.Idle;
			case "abovenormal":
				return ProcessPriorityClass.AboveNormal;
			case "belownormal":
				return ProcessPriorityClass.BelowNormal;
			case "realtime":
				return ProcessPriorityClass.RealTime;
			default:
				Console.WriteLine("Invalid switch:" + pr);
		}
	}
	function setStyle(st){
		switch(st.ToLower()) {
			case "hidden":
				return ProcessWindowStyle.Hidden;
			case "maximized":
				return ProcessWindowStyle.Maximized;
			case "minimized":
				return ProcessWindowStyle.Minimized;
			case "normal":
				return ProcessWindowStyle.Normal;
			default:
				Console.WriteLine("Invalid switch:" + st);	
		}	
	}
}

parseArgs();
var process = new Process();
var startInfo = new ProcessStartInfo(command,command_args);

process.StartInfo.FileName=command;
process.StartInfo.Arguments=command_args;
process.StartInfo.UseShellExecute=useShellExecute;
process.StartInfo.WindowStyle=windowStyle;
process.StartInfo.WorkingDirectory=workingDirectory;
process.StartInfo.RedirectStandardOutput=redirectStandartOutput;
process.StartInfo.RedirectStandardInput=redirectStandartInput;
process.StartInfo.RedirectStandardError=redirectStandartError;
process.StartInfo.CreateNoWindow=newWindows;

try {

	var np=process.Start(startInfo);
	Console.WriteLine("Started: " + command + " " + command_args);
	Console.WriteLine("PID:" + np.Id);
} catch(err) {
	Console.WriteLine(err.message);
}
