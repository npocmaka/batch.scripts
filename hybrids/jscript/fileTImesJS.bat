@if (@X)==(@Y) @end /****** jscript comment ******
@echo off
setlocal
for %%# in (/h /help -h -help) do (
	if "%~1" equ "%%#" (
		(echo()
		echo %~nx0 - Displays LastModified,LastAccessed and DateCreated times of a given file
		echo         in format YYYY-MM-DD hh:mm:ss , the milliseconds passed since 1970-1-1 , day of the week
		(echo()
		echo example:
		echo call %~nx0 C:\file.ext
	)
)

if "%~1" equ "" (
	echo no file passed
	exit /b 1
)

if not exist "%~f1" (
	echo file "%~f1" does not exist
	exit /b 2
)

if exist "%~f1\" (
	echo "%~f1" is a directory but not a file
	exit /b 3
)
(echo()
echo file timestamps for %~f1 :
(echo()
cscript //E:JScript //nologo "%~f0" "%~f1"
exit /b %errorlevel%

****** end of jscript comment ******/ 

var file_loc = WScript.Arguments.Item(0);
var fso = new ActiveXObject("Scripting.FileSystemObject");
var the_file=fso.GetFile(file_loc);

function toDoubleDigit(number){
	if (number<10){
	  return "0"+number;
	}
	return number;
}

function printDateInfo(timeTag,date){
	var month=toDoubleDigit(date.getMonth()+1);
	var dayOfTheMonth=toDoubleDigit(date.getHours());
	var hours=toDoubleDigit(date.getHours());
	var minutes=toDoubleDigit(date.getMinutes());
	var seconds=toDoubleDigit(date.getSeconds());
	
	WScript.Echo( timeTag + " : " + date.getFullYear() + "-" + month + "-" + dayOfTheMonth + " " + hours + ":" + minutes + ":" + seconds );
	WScript.Echo(timeTag + " - milliseconds passed : " + date.getTime());
	WScript.Echo( timeTag + " day of the week : " + date.getDay());
	WScript.Echo();
}
var modified_date= new Date(the_file.DateLastModified);
var creation_date= new Date(the_file.DateCreated);
var accessed_date= new Date(the_file.DateLastAccessed);

printDateInfo("Modified",modified_date);
printDateInfo("Created",creation_date);
printDateInfo("Accessed",accessed_date);
