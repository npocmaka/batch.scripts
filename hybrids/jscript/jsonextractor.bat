@if (@CodeSection == @Batch) @then

@echo off & setlocal

cscript /nologo /e:JScript "%~f0" %*
goto :EOF

@end // end batch / begin JScript hybrid chimera

var htmlfile = WSH.CreateObject('htmlfile');
htmlfile.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
var JSON = htmlfile.parentWindow.JSON;

//needs file existence checks
var jsloc=WScript.Arguments.Item(0);
var jsonPath=WScript.Arguments.Item(1);


FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var txtFile=FSOObj.OpenTextFile(jsloc,1);
var json=txtFile.ReadAll();

try {
	var jParsed=JSON.parse(json);
}catch(err) {
   WScript.Echo("Failed to parse the json content");
   htmlfile.close();
   txtFile.close();
   WScript.Exit(1);
   //WScript.Echo(err.message);
}


WScript.Echo(eval("JSON.stringify(jParsed."+jsonPath+")"));


htmlfile.close();
txtFile.close();
