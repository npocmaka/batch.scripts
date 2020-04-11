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

String.prototype.hexDecode = function(){
    var j;
    var hexes = this.match(/.{1,2}/g) || [];
    var back = "";
    for(j = 0; j<hexes.length; j++) {
        back += String.fromCharCode(parseInt(hexes[j], 16));
    }

    return back;
}

WScript.Echo(string.hexDecode());
