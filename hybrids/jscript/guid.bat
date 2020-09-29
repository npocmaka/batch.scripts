@if (@X)==(@Y) @end /*
@cscript //E:JScript //nologo "%~f0" %*
@exit /b %errorlevel%
@*/WScript.Echo((new ActiveXObject("Scriptlet.TypeLib")).Guid) 
