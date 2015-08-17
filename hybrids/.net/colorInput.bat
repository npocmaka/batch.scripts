
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
import System.IO;

var arguments:String[] = Environment.GetCommandLineArgs();

var foregroundColor = Console.ForegroundColor;
var backgroundColor = Console.BackgroundColor;

var currentBackground=Console.BackgroundColor;
var currentForeground=Console.ForegroundColor;
var promptString:String="";
var outFile="";

function printHelp( ) {
   print( arguments[0] + " [-f foreground] [-b background] [-p prompt string] [-o out file]" );

   print( "	foreground 		Foreground color - a " );
   print( "					number between 0 and 15." );
   print( "	background 		Background color - a " );
   print( "					number between 0 and 15." );
   print( "Colors :" );
   for ( var c = 0 ; c < 16 ; c++ ) {
		
		Console.BackgroundColor = c;
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


function parseArgs(){
	if ( arguments.length == 1 || arguments[1].toLowerCase() == "-help" || arguments[1].toLowerCase() == "-help"   ) {
		printHelp();
		Environment.Exit(0);
	}
	
	for (var i=1;i<arguments.length-1;i=i+2){
		try{
			switch(arguments[i].toLowerCase()){
				case '-f':
					foregroundColor=Int32.Parse(arguments[i+1]);
					break;
				case '-b':
					backgroundColor=Int32.Parse(arguments[i+1]);
					break;
				case '-p':
					promptString=arguments[i+1];
					break;
				case '-o':
					outFile=arguments[i+1];
					break;
				default:
					Console.WriteLine("Invalid Argument "+arguments[i]);
					break;
		}
		}catch(e){
			errorChecker(e);
		}
	}
}

parseArgs();
numberChecker(backgroundColor);
numberChecker(foregroundColor);

Console.BackgroundColor = backgroundColor ;
Console.ForegroundColor = foregroundColor ;

Console.Write(promptString);

var key;
var input="";
do {
    key = Console.ReadKey(true);
    if ( (key.KeyChar.ToString().charCodeAt(0)) >= 20 && (key.KeyChar.ToString().charCodeAt(0) <= 126) ) {
		input=input+(key.KeyChar.ToString());
        Console.Error.Write(key.KeyChar.ToString());
    }   
} while (key.Key != ConsoleKey.Enter);
Console.Error.WriteLine();
Console.BackgroundColor = currentBackground;
Console.ForegroundColor = currentForeground;

try {
	if (outFile != ""){
		File.WriteAllText(outFile , input);
	}
}catch(e){
	errorChecker(e);
}
