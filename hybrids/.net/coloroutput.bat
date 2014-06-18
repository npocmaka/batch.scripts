
@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

%~n0.exe %*

endlocal & exit /b %errorlevel%

*/

import System;

var arguments:String[] = Environment.GetCommandLineArgs();

var newLine = false;
var output = "";
var foregroundColor = 0;
var backgroundColor = 14;
var currentBackground=Console.BackgroundColor;
var currentForeground=Console.ForegroundColor;

function colorSetter( i:Int32 ):ConsoleColor {
	switch ( i ) {
		case 0:
			return ConsoleColor.Black;
			break;
		case 1:
			return ConsoleColor.Blue;
			break;
		case 2:
			return ConsoleColor.Cyan;
			break;
		case 3:
			return ConsoleColor.DarkBlue;
			break;
		case 4:
			return ConsoleColor.DarkCyan;
			break;
		case 5:
			return ConsoleColor.DarkGray;
			break;
		case 6:
			return ConsoleColor.DarkGreen;
			break;
		case 7:
			return ConsoleColor.DarkMagenta;
			break;
		case 8:
			return ConsoleColor.DarkRed;
			break;
		case 9:
			return ConsoleColor.DarkYellow;
			break;
		case 10:
			return ConsoleColor.Gray;
			break;
		case 11:
			return ConsoleColor.Green;
			break;
		case 12:
			return ConsoleColor.Magenta;
			break;
		case 13:
			return ConsoleColor.Red;
			break;
		case 14:
			return ConsoleColor.White;
			break;
		case 15:
			return ConsoleColor.Yellow;
			break;
		default: 
         return ConsoleColor.Black;
	}

}


function printHelp( ) {
   print( arguments[0] + "-s string [-f foreground] [-b background] [-n]" );
   print( " " );
   print( "	string 			String to be printed" );
   print( "	foreground 		Foreground color - a number between 0 and 15.Default is 0" );
   print( "	background 		background color - a number between 0 and 15.Default is 14" );
   print( "	-n 				Indicates if a new line should be written at the end of the string(by default - no)." );
   print( "" );
   print( "Colors :" );
   for ( var c = 0 ; c < 16 ; c++ ) {
		Console.Write( ""+c+"-" );
		Console.BackgroundColor = colorSetter(c);
		Console.Write( " " );
		Console.BackgroundColor=currentBackground;
		Console.WriteLine( "" );
   }
   Console.BackgroundColor=currentBackground;
   

}

function errorChecker( e:Error ) {
		if ( e.message == "Input string was not in a correct format." ) {
			print( "the color parameters should be numbers between 0 and 15" );
			Environment.Exit( 1 );
		} else {
			print ( "Error Message: " + e.message );
			print ( "Error Code: " + ( e.number & 0xFFFF ) );
			print ( "Error Name: " + e.name );
			Environment.Exit( 666 );
		}
}

function numberChecker( i:Int32 ){
	if( i > 15 || i < 0 ) {
		print("the color parameters should be numbers between 0 and 15");
		Environment.Exit(1);
	}
}


if ( arguments.length == 1 || arguments[1].toLowerCase() == "-help" || arguments[1].toLowerCase() == "-help"   ) {
	printHelp();
	Environment.Exit(0);
}

for (var arg = 1; arg <= arguments.length-1; arg++ ) {
	if ( arguments[arg].toLowerCase() == "-n" ) {
		newLine=true;
	}
	
	if ( arguments[arg].toLowerCase() == "-s" ) {
		output=arguments[arg+1];
	}
	
	
	if ( arguments[arg].toLowerCase() == "-b" ) {
		
		try {
			backgroundColor=Int32.Parse( arguments[arg+1] );
		} catch(e) {
			errorChecker(e);
		}
	}
	
	if ( arguments[arg].toLowerCase() == "-f" ) {
		try {
			foregroundColor=Int32.Parse(arguments[arg+1]);
		} catch(e) {
			errorChecker(e);
		}
	}
}



Console.BackgroundColor=colorSetter( backgroundColor );
Console.ForegroundColor=colorSetter( foregroundColor );
if ( newLine ) {
	Console.WriteLine(output);
} else {
	Console.Write(output);
}

Console.BackgroundColor=currentBackground;
Console.ForegroundColor=currentForeground;

