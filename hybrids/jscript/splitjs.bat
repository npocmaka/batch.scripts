@if (@x)==(@y) @end /***** jscript comment ******
     @echo off
     cscript //E:JScript //nologo "%~f0" "%~nx0" %* 
     exit /b %errorlevel%

 @if (@x)==(@y) @end ******  end comment *********/
 
 //https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/zipjs.bat
 
var FileSystemObj = new ActiveXObject("Scripting.FileSystemObject");
var AdoDBObj = new ActiveXObject("ADODB.Stream");

var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);

if (ARGS.length <3) {
	WScript.Echo("Wrong arguments");
	WScript.Echo("usage:");
	WScript.Echo(scriptName +"file_to_split size_in_bytes");
	WScript.Quit(1);
}
var file=ARGS.Item(1);
var max_size=parseInt(ARGS.Item(2));

function getSize(file){
	return FileSystemObj.getFile(file).size;
}

function isExist(file){
	return FileSystemObj.FileExists(file);
}
 
function writeFile(fileName,data ){
	AdoDBObj.Type = 1;		 
	AdoDBObj.Open();
	AdoDBObj.Position=0;
	AdoDBObj.Write(data);
	AdoDBObj.SaveToFile(fileName,2);
	AdoDBObj.Close();	
}

function readFile(fileName,size,position){
	AdoDBObj.Type = 1; 
	AdoDBObj.Open();
	AdoDBObj.LoadFromFile(fileName);
	AdoDBObj.Position=position;
	fileBytes=AdoDBObj.Read(size);
	AdoDBObj.Close();
	return fileBytes;
	
	
}

function chunker(file,size){
	var part=0;
	var position=0;
	var buffer=readFile(file,size,0);
	file_size=getSize(file);
	while (buffer !== null ) {
		part++;
		writeFile(file+"."+part,buffer);
		if (size*part <= file_size) {
			position=size*part;
		} else {
			position=file_size;
		}
		buffer=readFile(file,size,position);
	}
}

if (!isExist(file)){
	WScript.Echo(file+" does not exist");
	WScript.Quit(2);
}

if(max_size<=0){
	WScript.Echo("Size must be bigger than 0.")
	WScript.Quit();
}

chunker(file,max_size);
