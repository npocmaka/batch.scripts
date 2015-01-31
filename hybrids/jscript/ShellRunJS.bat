@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" "%~nx0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);
var command=0;
var style=1;
var wait=true;
var shell = new ActiveXObject("WScript.Shell");

function printHelp(){
	WScript.Echo(scriptName + " - WScript.Shell wrapper that can start process in certain mode");
	WScript.Echo("usage:");
	WScript.Echo(scriptName + " command [-style {0-10}] [-wait yes|no]");
	WScript.Echo("command    - the command to execute");
	WScript.Echo("wait       - to wait or not for command to finish.Default is yes");
	WScript.Echo("style      - number of 1 to 10 that defines the window style of executed command");
	WScript.Echo("");
	WScript.Echo("Info about styles");
	WScript.Echo("");
	WScript.Echo("https://msdn.microsoft.com/en-us/library/d5fk67ky(v=vs.84).aspx");
	WScript.Echo("");
    WScript.Echo("0 - Hides the window and activates another window.");
    WScript.Echo("1 - [Default]Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position.\r\n     An application should specify this flag when displaying the window for the first time.");
    WScript.Echo("2 - Activates the window and displays it as a minimized window.");
    WScript.Echo("3 - Activates the window and displays it as a maximized window.");
    WScript.Echo("4 - Displays a window in its most recent size and position. The active window remains active.");
    WScript.Echo("5 - Activates the window and displays it in its current size and position.");
    WScript.Echo("6 - Minimizes the specified window and activates the next top-level window in the Z order.");
    WScript.Echo("7 - Displays the window as a minimized window. The active window remains active.");
    WScript.Echo("8 - Displays the window in its current state. The active window remains active.");
    WScript.Echo("9 - Activates and displays the window. If the window is minimized or maximized, the system restores it to its original size and position.\r\n     An application should specify this flag when restoring a minimized window.");
    WScript.Echo("10 - Sets the show-state based on the state of the program that started the application.");
	
}

function parseArguments(){
		if (WScript.Arguments.Length==1 || ARGS.Item(1).toLowerCase() == "-help" ||  ARGS.Item(1).toLowerCase() == "-h" ) {
			printHelp();
			WScript.Quit(1);
		}
		
		if (WScript.Arguments.Length % 2 == 1 ) {
			WScript.Echo("Illegal arguments ");
			printHelp();
			WScript.Quit(1);
		}
		
		command=ARGS.Item(1);
		
		for (var i=2;i<ARGS.length-1;i=i+2){
			switch (ARGS.Item(i).toLowerCase()){
				case "-style":
					style=ARGS.Item(i+1);
					break;
				case "-wait":
					if(ARGS.Item(i+1).toLowerCase()=="no"){
						wait=false;
					}
					break;
				default:
					WScript.Echo("Invalid argument: " + ARGS.Item(i) );
					WScript.Quit(2);
			}
		}
		try {
			style=parseInt(style);
		} catch(err) {
			WScript.Echo("style must be a number between 0 and 10");
			WScript.Quit(3);
		}
		if (style<0 || style>10){
			WScript.Echo("style must be a number between 0 and 10");
			WScript.Quit(3);
		}
		
}

parseArguments();
shell.Run(command,style,wait);
