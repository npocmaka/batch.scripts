0</* :
@echo off
	cscript /nologo /E:jscript "%~f0" %*
exit /b %errorlevel% */0;

//http://blogs.technet.com/b/heyscriptingguy/archive/2005/02/08/how-can-i-find-and-replace-text-in-a-text-file.aspx

var FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var ARGS = WScript.Arguments;

if (ARGS.Item(0).toLowerCase() == "-help") {
	WScript.Echo(Wscript.ScriptName + " path_to_file search replace");
	WScript.Quit(0);
}

if (ARGS.Length < 3 ) {
	WScript.Echo("Wrong arguments");
	WScript.Quit(1);
}



var filename=ARGS.Item(0);
var find=ARGS.Item(1);
var replace=ARGS.Item(2);

var readStream=FSOObj.OpenTextFile(filename, 1);

var content=readStream.ReadAll();
readStream.Close();

function replaceAll(find, replace, str) {
  return str.replace(new RegExp(find, 'g'), replace);
}

var newContent=replaceAll(find,replace,content);

var writeStream=FSOObj.OpenTextFile(filename, 2);
writeStream.WriteLine(newContent);
writeStream.Close();
