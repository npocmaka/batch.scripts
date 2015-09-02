@if (@X)==(@Y) @end /****** jscript comment ******

@echo off
::::::::::::::::::::::::::::::::::::
:::       compile the script    ::::
::::::::::::::::::::::::::::::::::::
setlocal

if exist "%~n0.exe" goto :skip_compilation

:: searching the latest installed .net framework
for /f "tokens=* delims=" %%v in ('dir /b /s /a:d /o:-n "%SystemRoot%\Microsoft.NET\Framework\v*"') do (
    if exist "%%v\jsc.exe" (
        rem :: the javascript.net compiler
        set "jsc=%%~dpsnfxv\jsc.exe"
        goto :break_loop
    )
)
echo jsc.exe not found && exit /b 0
:break_loop


call %jsc% /nologo /out:"%~n0.exe" "%~nx0"
::::::::::::::::::::::::::::::::::::
:::       end of compilation    ::::
::::::::::::::::::::::::::::::::::::
:skip_compilation

::
::::::::::
"%~n0.exe"
::::::::
::

exit /b 0

## http://msdn.microsoft.com/en-us/library/system.text.encoding.getencodings.aspx?cs-save-lang=1&cs-lang=csharp#code-snippet-2
##
****** end of jscript comment ******/

import System;
import System.Text;

Console.Write( "CodePage identifier and name     " );
Console.Write( "BrDisp   BrSave   " );
Console.Write( "MNDisp   MNSave   " );
Console.WriteLine( "1-Byte   ReadOnly " );

var ei=  new Object();
var encs=new Enumerator(Encoding.GetEncodings());
	
while(!encs.atEnd()) {
	var enc=encs.item();
	var e=enc.GetEncoding();
		
	Console.Write( "{0,-6} {1,-25} ", enc.CodePage, enc.Name );
	Console.Write( "{0,-8} {1,-8} ", e.IsBrowserDisplay, e.IsBrowserSave );
	Console.Write( "{0,-8} {1,-8} ", e.IsMailNewsDisplay, e.IsMailNewsSave );
 	Console.WriteLine( "{0,-8} {1,-8} ", e.IsSingleByte, e.IsReadOnly );
		 
	encs.moveNext();
}
	
	
