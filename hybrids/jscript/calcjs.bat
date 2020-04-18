@if (@X) == (@Y) @end /*
@cscript //E:JScript //nologo "%~f0" "%*"
@exit /b %errorlevel%
*/WScript.StdOut.WriteLine(eval(WScript.Arguments.Item(0)));
