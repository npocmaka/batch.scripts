 @if (@x)==(@y) @end /***** jscript comment ******
     @echo off

     cscript //E:JScript //nologo "%~f0" "%~nx0" %*
     exit /b 0

 @if (@x)==(@y) @end ******  end comment *********/
 

var wshShell = WScript.CreateObject("WScript.Shell");
var args=WScript.Arguments;
var title=args.Item(0);

var timeout=-1;
var message="";

function printHelp() {
	WScript.Echo(title + "[-title Title] [-timeout m] [-message \"pop-up message\"]");
	WScript.Echo(title + "if time out not defined will wait only for button pressing");
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
	WScript.Quit(10);
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
	
	
	if (args.Item(arg).toLowerCase() == "-message") {
		message = args.Item(arg+1);
	}
}
 
function runPopup(){
	var btn = wshShell.Popup(message, timeout, title, 0x4 + 0x20);
	//WScript.Echo(btn)
	switch(btn) {
		// yes pressed.
		case 6:
			WScript.Echo("yes");
			WScript.Quit(btn);
			break;
		// no  pressed.
		case 7:
			WScript.Echo("no");
			WScript.Quit(btn);
			break;

		// Timed out.
		case -1:
		   WScript.Echo("timeout");
		   WScript.Quit(btn);
		   break;
	}
}

runPopup();
