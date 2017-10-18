@if (@X)==(@Y) @end /* JScript comment
    @echo off
	
	set "file=%~f1"
	set "xpath=%~2"
	set "option=%~3"
	
	if "%~2" equ "" (
		goto :printHelp
	)
	
	for %%# in ("-h" "-help" "/h" "/help" "") do (
		if /i "%~1" equ %%# (
			goto :printHelp
		)
	)
	
	if exist "%file%\" (
		echo file "%~1" does not exist
		exit /b 3
	)
	if not exist "%file%" (
		echo file "%~1" does not exist
		exit /b 4
	) 
	
	
    cscript //E:JScript //nologo "%~f0" /file:"%file%" /xpath:"%xpath%" /option:"%option%"

    exit /b %errorlevel%
	
	:printHelp
	echo %~nx0 prints the value (or list of values)
	echo       of xml attribute/node in xml by given xpath expression
	echo(
	echo Usage:
	echo(
	echo call %~nx0 "filePath" "xpathExpression"
	exit /b %errorlevel%

@if (@X)==(@Y) @end JScript comment */

if (WScript.Arguments.length<2)
{
	WScript.Echo("Not enough arguments");
	WScript.Quit(3);
}


function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(str, find, replace) {
  return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

var xp=WScript.Arguments.Named.Item("xpath");
xp=replaceAll(xp,"'",'"');

var option=WScript.Arguments.Named.Item("option");

var objDoc;
var objNodes;
var loaded;

try {
	objDoc = WScript.CreateObject("MSXML.DOMDocument");
	loaded=objDoc.load(WScript.Arguments.Named.Item("file"));
} catch (err){
	WScript.Echo("Error while parsing the xml");
	WScript.Echo(err.message);
	WScript.Quit(1);
}

if(!loaded){
	WScript.Echo("Error while parsing the xml");
	WScript.Echo("");
	WScript.Echo("Error Code:"+objDoc.parseError.errorCode);
	WScript.Echo("");
	WScript.Echo("Line:"+objDoc.parseError.line+" Posotion:"+objDoc.parseError.filepos);
	WScript.Echo("");
	WScript.Echo("Reason:"+objDoc.parseError.reason);
	WScript.Echo("");
	WScript.Echo("URL:"+objDoc.parseError.url);
	WScript.Echo("");
	WScript.Echo(objDoc.parseError.srcText);
	WScript.Quit(5);
}

try {
	var objNodes = objDoc.selectNodes(xp);
} catch (err){
	WScript.Echo("invalid xpath expression");
	WScript.Echo(err.message);
	WScript.Quit(2);
}

for (var i=0;i<objNodes.length;i++){
    if(option.toLowerCase()=="xml"){
		WScript.Echo(objNodes.item(i).xml);
	} else {
		WScript.Echo(objNodes.item(i).text);
	}
	
}
