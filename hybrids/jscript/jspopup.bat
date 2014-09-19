 @if (@x)==(@y) @end /***** jscript comment ******
     @echo off

     cscript //E:JScript //nologo "%~f0" "%~nx0" %*
     exit /b 0

 @if (@x)==(@y) @end ******  end comment *********/
 

var wshShell = WScript.CreateObject("WScript.Shell");
var args=WScript.Arguments;
var title=args.Item(0);

var timeout=-1;
var pressed_message="button pressed";
var timeout_message="timedout";
var message="";

function printHelp() {
	WScript.Echo(title + "[-title Title] [-timeout m] [-tom \"Time-out message\"] [-pbm \"Pressed button message\"]  [-message \"pop-up message\"]");
}

if (WScript.Arguments.Length==1){
	runPopup();
	WScript.Quit(0);
}

if (args.Item(1).toLowerCase() == "-help" ||  args.Item(1).toLowerCase() == "-h" ) {
	printHelp();
	WScript.Quit(0);
}

if (WScript.Arguments.Length % 2 == 0 ) {
	WScript.Echo("Illegal arguments ");
	printHelp();
	WScript.Quit(1);
}

for (var arg = 1 ; arg<args.Length;arg=arg+2) {
		
	if (args.Item(arg).toLowerCase() == "-title") {
		title = args.Item(arg+1);
	}
	
	if (args.Item(arg).toLowerCase() == "-timeout") {
		timeout = parseInt(args.Item(arg+1));
		if (isNaN(timeout)) {
			timeout=-1;
		}
	}
	
	if (args.Item(arg).toLowerCase() == "-tom") {
		timeout_message = args.Item(arg+1);
	}
	
	if (args.Item(arg).toLowerCase() == "-pbm") {
		pressed_message = args.Item(arg+1);
	}
	
	if (args.Item(arg).toLowerCase() == "-message") {
		message = args.Item(arg+1);
	}
}
 
function runPopup(){
	var btn = wshShell.Popup(message, timeout, title, 0x0 + 0x10);
	 
	switch(btn) {
		// button pressed.
		case 1:
			WScript.Echo(pressed_message);
			break;

		// Timed out.
		case -1:
		   WScript.Echo(timeout_message);
		   break;
	}
}

runPopup();
