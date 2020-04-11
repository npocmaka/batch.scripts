@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

var string="";
if (WScript.Arguments.Length==0) {
	var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
	string=fso.ReadLine();
} else {
	string=WScript.Arguments.Item(0);
}

String.prototype.hexEncode = function(){
    var hex, i;

    var result = "";
    for (i=0; i<this.length; i++) {
        hex = this.charCodeAt(i).toString(16);
        result += (hex).slice(-4);
    }

    return result
}

WScript.Echo(string.hexEncode());
