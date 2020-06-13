@if (@X) == (@Y) @end /* JScript comment 
    @echo off  	
		for /f "tokens=*" %%a in ('cscript //E:JScript //nologo "%~f0" "%~nx0"') do (
			if "%~1" equ "" (
				echo %%a
			) else (
				set "%~1=%%a"
			)
		)
    exit /b %errorlevel%       
@if (@X)==(@Y) @end JScript comment */

//https://stackoverflow.com/questions/105034/how-to-create-guid-uuid/2117523#2117523

UUIDv4 =

function b(
  a // placeholder
){
  return a // if the placeholder was passed, return
    ? ( // a random number from 0 to 15
      a ^ // unless b is 8,
      Math.random() // in which case
      * 16 // a random number from
      >> a/4 // 8 to 11
      ).toString(16) // in hexadecimal
    : ( // or otherwise a concatenated string:
      [1e7] + // 10000000 +
      -1e3 + // -1000 +
      -4e3 + // -4000 +
      -8e3 + // -80000000 +
      -1e11 // -100000000000,
      ).replace( // replacing
        /[018]/g, // zeroes, ones, and eights with
        b // random hex digits
      )
}

WScript.Echo(UUIDv4());
