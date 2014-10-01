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


endlocal & exit /b %errorlevel%

end oj jscript comment*/

import System;
import System.Media;
import System.Threading;


var arguments:String[] = Environment.GetCommandLineArgs();

function printHelp( ) {
  print(arguments[0] + " [beep] [asterisk] [hand] [beep] [question]");

}

if ( arguments.length == 1 || arguments[1].toLowerCase() == "-h" || arguments[1].toLowerCase() == "-help" ) {
	printHelp();
	Environment.Exit(0);
}



for (var arg = 1; arg <= arguments.length-1; arg++ ) {

	if ( arguments[arg].toLowerCase() == "beep" ) {
		SystemSounds.Beep.Play();
		System.Threading.Thread.Sleep(300);
	}
	
	if ( arguments[arg].toLowerCase() == "asterisk" ) {
		SystemSounds.Asterisk.Play();
		System.Threading.Thread.Sleep(300);
	}
	
	if ( arguments[arg].toLowerCase() == "exclamation" ) {
		SystemSounds.Exclamation.Play();
		System.Threading.Thread.Sleep(300);
	}
	
	if ( arguments[arg].toLowerCase() == "hand" ) {
		SystemSounds.Hand.Play();
		System.Threading.Thread.Sleep(300);
	}
	
	if ( arguments[arg].toLowerCase() == "question" ) {
		SystemSounds.Question.Play();
		System.Threading.Thread.Sleep(300);
	}

}


/*
Asterisk	
Beep
Exclamation
Hand
Question
*/
