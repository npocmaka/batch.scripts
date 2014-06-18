
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
var evaluate = false;
var currentBackground=Console.BackgroundColor;
var currentForeground=Console.ForegroundColor;


//http://stackoverflow.com/a/24294348/388389
var jsEscapes = {
  'n': '\n',
  'r': '\r',
  't': '\t',
  'f': '\f',
  'v': '\v',
  'b': '\b'
};

function decodeJsEscape(_, hex0, hex1, octal, other) {
  var hex = hex0 || hex1;
  if (hex) { return String.fromCharCode(parseInt(hex, 16)); }
  if (octal) { return String.fromCharCode(parseInt(octal, 8)); }
  return jsEscapes[other] || other;
}

function decodeJsString(s) {
  return s.replace(
      // Matches an escape sequence with UTF-16 in group 1, single byte hex in group 2,
      // octal in group 3, and arbitrary other single-character escapes in group 4.
      /\\(?:u([0-9A-Fa-f]{4})|x([0-9A-Fa-f]{2})|([0-3][0-7]{0,2}|[4-7][0-7]?)|(.))/g,
      decodeJsEscape);
}

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
   print( arguments[0] + "  -s string [-f foreground] [-b background] [-n]" );
   print( " " );
   print( "	string 			String to be printed" );
   print( "	foreground 		Foreground color - a " );
   print( "					number between 0 and 15.Default is 0" );
   print( "	background 		background color - a " );
   print( "					number between 0 and 15.Default is 14" );
   print( "	-n 		        Indicates if a new line should" );
   print( "					be written at the end of the ");
   print( "					string(by default - no)." );
   print( "" );
   print( "Colors :" );
   for ( var c = 0 ; c < 16 ; c++ ) {
		
		Console.BackgroundColor = colorSetter(c);
		Console.Write( " " );
		Console.BackgroundColor=currentBackground;
		Console.Write( "-"+c );
		Console.WriteLine( "" );
   }
   Console.BackgroundColor=currentBackground;
   
   

}

function errorChecker( e:Error ) {
		if ( e.message == "Input string was not in a correct format." ) {
			print( "the color parameters should be numbers between 0 and 15" );
			Environment.Exit( 1 );
		} else if (e.message == "Index was outside the bounds of the array.") {
			print( "invalid arguments" );
			Environment.Exit( 2 );
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
	
	if ( arguments[arg].toLowerCase() == "-e" ) {
		evaluate=true;
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



Console.BackgroundColor = colorSetter( backgroundColor );
Console.ForegroundColor = colorSetter( foregroundColor );

if ( evaluate ) {
	output=decodeJsString(output);
}

if ( newLine ) {
	Console.WriteLine(output);	
} else {
	Console.Write(output);
	
}

Console.BackgroundColor = currentBackground;
Console.ForegroundColor = currentForeground;

