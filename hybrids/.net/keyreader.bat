@if(@X) == (@Y) @end /* JScript comment
@echo off
:: reads a single key stroke and exits with its ascii code.
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

//http://stackoverflow.com/questions/57615/how-to-add-a-timeout-to-console-readline
import System;
import System.Threading;


class Reader {
    static var inputThread;
    static var getInput, gotInput;
    static var input;

    function Reader() {
        getInput = new AutoResetEvent(false);
        gotInput = new AutoResetEvent(false);
        inputThread = new Thread(ThreadStart(Reader.reader));
        inputThread.IsBackground = true;
        inputThread.Start();
    }

    static function reader() {
        while (true) {
            try {
                getInput.WaitOne();
                input = Console.ReadKey();
                gotInput.Set();
            } catch (err) {
                var key = Console.Read();
                Environment.Exit(key);
            }
        }
    }

    function ReadKey(timeOutMillisecs: int) {
        getInput.Set();
        var success = gotInput.WaitOne(timeOutMillisecs);
        if (success) {
            Environment.Exit(input.KeyChar.ToString().charCodeAt(0));
        } else {
            Environment.Exit(-2);
        }
    }
}

var arguments: String[] = Environment.GetCommandLineArgs();
if (arguments.length == 1) {
    try {
        var key = Console.ReadKey(true);
        Environment.Exit(key.KeyChar.ToString().charCodeAt(0));
    } catch (err) {
        var key = Console.Read();
        Environment.Exit(key);
    }
} else {
    if (arguments[1] == "/?" || arguments[1].toLowerCase().ToLower().Contains("help")) {
        print("Usage:");
        print("	" + arguments[0] + "  [timeout-in-milliseconds]");
        print("	reads a key and exits with its ascii code");
        print("	if a timeout is passed it will wait for input and if no key is pressed it will return -2");
    } else {
        try {
            var to = Int32.Parse(arguments[1]);
            var rdr = new Reader();
            rdr.ReadKey(to);
        } catch (err) {
		    try {
				print("no valid number passed as timeout");
				var key = Console.ReadKey(true);
				Environment.Exit(key.KeyChar.ToString().charCodeAt(0));
			} catch (err) {
				var key = Console.Read();
				Environment.Exit(key);
            }
        }
    }
}
