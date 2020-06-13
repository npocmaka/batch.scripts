@if (@X) == (@Y) @end /* JScript comment 
    @echo off  	
		for /f "tokens=*" %%a in ('cscript //E:JScript //nologo "%~f0" "%~nx0"') do (
			if "%~2" equ "" (
				echo %%a
			) else (
				set "%~2=%%a"
			)
		)
    exit /b %errorlevel%       
@if (@X)==(@Y) @end JScript comment */

//https://stackoverflow.com/questions/105034/how-to-create-guid-uuid/2117523#2117523

function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

WScript.Echo(uuidv4());
