@if (@X)==(@Y) @end /* JScript comment
@echo off
:: reads a single key stroke and exits with its ascii code.
:: will fail if there's piped input
setlocal enableDelayedExpansion

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    rem del /q /f "%~n0.exe" >nul 2>&1
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)
%~n0.exe %*
exit /b %errorlevel%

*/


import System;
import System.Threading;
//import System.Threading.Thread;

class Reader {
   static  var inputThread;
   static  var getInput, gotInput;
   static  var input;

   function Reader() {
    getInput = new AutoResetEvent(false);
    gotInput = new AutoResetEvent(false);
	
	inputThread = new Thread(ThreadStart(Reader.reader));

    inputThread.IsBackground = true;
    inputThread.Start();
  }

   static function reader() {
    while (true) {
		getInput.WaitOne();
		input = Console.ReadKey();
		gotInput.Set();

    }
  }

   function ReadKey(timeOutMillisecs:int) {
    getInput.Set();
    var success = gotInput.WaitOne(timeOutMillisecs);
    if (success) {
      //return input;
	  Environment.Exit(input.KeyChar.ToString().charCodeAt(0));
    }else{
      Environment.Exit(0);
	}
  }
}
//var to:int;
var arguments:String[] = Environment.GetCommandLineArgs();
if (arguments.length == 1){
	var key = Console.ReadKey(true);
    Environment.Exit(key.KeyChar.ToString().charCodeAt(0));
} else {
	if(arguments[1]=="/?" || arguments[1].toLowerCase().ToLower().Contains("help")) {
		print("Usage:");
		print("	"+arguments[0]+"  [timeout-in-milliseconds]");
		print("	reads a key and exits with its ascii code");
		print("	if a timeout is passed it will wait for input and if no key is pressed it will return 0");
	}else{
		try {
			var to=Int32.Parse(arguments[1]);
			var rdr=new Reader();

			rdr.ReadKey(to);

			
		}
		catch(err) {
			print("no valid number passed as timeout");
			var key = Console.ReadKey(true);
			Environment.Exit(key.KeyChar.ToString().charCodeAt(0));
		}
	}
}

