@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe %* 2>nul

endlocal & exit /b %errorlevel%


*/

import System;
import System.Globalization;
import  System.DateTime;
import System.IO;
import System.IO.Directory;
import System.Collections;



var arguments:String[] = Environment.GetCommandLineArgs();

var directory=".";
//var filter="creation";
var max_date=DateTime.Now.Ticks ;
var min_date=DateTime.MinValue.Ticks ;

var DD=0;
var hh=0;
var mm=0;
var ss=0;

var recursive=true;
var show_dirs=false;
var show_files=true;
var mask="*";
var direction="after";

var getFunct=File.GetCreationTime;



function printHelp(){
	Console.WriteLine(arguments[0] + " filters files/directories by date or time");
	Console.WriteLine("");
	Console.WriteLine("Usage:");
	Console.WriteLine(arguments[0] + " directory [options]");
	Console.WriteLine("Options:");
	Console.WriteLine("-beginDate dd-MM-yy#hh:mm:ss -endDate  dd-MM-yy#hh:mm:ss");
	Console.WriteLine("		will show files/directories between the two dates.Date format can be");
	Console.WriteLine("		dd-MM-yy#hh:mm:ss|dd-MM-yy (time will be 00:00:00)|#hh:mm:ss( date will be current)|");
	Console.WriteLine("		dd-MM-yy#hh|dd-MM-yy#hh:mm");
	Console.WriteLine("		default are  01:01:0001#00:00:00 and the current");
	Console.WriteLine("-mask pattern  ");
	Console.WriteLine("    will show files/directories that applies a given pattern.Wildcards are accepted");
	Console.WriteLine("    Default is '*'");
	Console.WriteLine("-direction before|after  ");
	Console.WriteLine("    will search for files/directories before or after given date.Default is after");
	Console.WriteLine("-hh  Number");
	Console.WriteLine("    Will add/subtract(if number is negative) hours to given dates");
	Console.WriteLine("    Default is 0");
	Console.WriteLine("-mm  Number");
	Console.WriteLine("    Will add/subtract(if number is negative) minutes to given dates");
	Console.WriteLine("    Default is 0");
	Console.WriteLine("-dd  Number");
	Console.WriteLine("    Will add/subtract(if number is negative) days to given dates");
	Console.WriteLine("    Default is 0");
	Console.WriteLine("-ss Number");
	Console.WriteLine("    Will add/subtract(if number is negative) seconds to given dates");
	Console.WriteLine("    Default is 0");
	Console.WriteLine("-recursive yes|no");
	Console.WriteLine("    Will search be recursive or not");
	Console.WriteLine("    Default is yes");
	Console.WriteLine("-show dirs|files");
	Console.WriteLine("    Will search files or directories");
	Console.WriteLine("    Default is files");
	Console.WriteLine("");
	Console.WriteLine("-filetime created|accessed|modified");
	Console.WriteLine("    Will search files or directories by passed time property ");
	Console.WriteLine("    Default is created");
	Console.WriteLine("Examples:");
	Console.WriteLine("");
	Console.WriteLine("Will show files older than 5 hours");
	Console.WriteLine(arguments[0] + '"." -hh -5');
	Console.WriteLine("");
	Console.WriteLine("Will show files between the begin and end date with '.jpg' extension");
	Console.WriteLine(arguments[0] + '"." -beginDate 30-12-14#15:30:00 -endDate  10-01-15#00:00:10 -mask "*.jpg"');
	Console.WriteLine("Will show files newer than 5 hours starting from given date");
	Console.WriteLine(arguments[0] + '"." -hh 5 -beginDate -beginDate 30-12-14#15:30:00');
	Console.WriteLine("");
	Console.WriteLine("Will show files older than 5 hours starting from given date");
	Console.WriteLine(arguments[0] + '"." -hh 5 -beginDate -beginDate 30-12-14#15:30:00 -direction before');
	Console.WriteLine("");
}

function parseDate(stringDate){
	try {
		var provider = CultureInfo.InvariantCulture;
		switch (stringDate.length){
			case 8:
				var pattern="dd-MM-yy";
				return DateTime.ParseExact(stringDate,pattern,provider).Ticks;
			case 9:
				var pattern="d-M-yyyy#hh:mm:ss";
				var c_date=DateTime.Now;
				var remastered_date=c_date.Month+"-"+c_date.Day+"-"+c_date.Year+stringDate;
				return DateTime.ParseExact(stringDate,pattern,provider).Ticks;
			case 11:
				var pattern="dd-MM-yy#hh";
				return DateTime.ParseExact(stringDate,pattern,provider).Ticks;		
			case 14:
				var pattern="dd-MM-yy#hh:mm";
				return DateTime.ParseExact(stringDate,pattern,provider).Ticks;
			case 17:
				var pattern="dd-MM-yy#hh:mm:ss";
				return DateTime.ParseExact(stringDate,pattern,provider).Ticks;
			default:
				Console.WriteLine("Wrong date format");
				Environment.Exit(7);
		}
	} catch (err) {
		Console.WriteLine(err.message)
	}
}

function parseArgs(){
	
	if (arguments[1] == "-h" || arguments[1] == "-help"){
		printHelp();
	}
	
	if (arguments.length<2){
		Console.WriteLine("Wrong arguments");
		printHelp();
		Environment.Exit(1);
	}
	
	if (arguments.length%2 != 0){
		Console.WriteLine("Wrong number of arguments");
		printHelp();
		Environment.Exit(2);
	}
	
	directory=arguments[1];
	
	for (var i=2;i<arguments.length-1;i=i+2){
		var arg=arguments[i].ToLower();
		var next=arguments[i+1].ToLower();
		switch (arg){
			case "-direction" :
				if (next == 'before') {
					direction="before";
				}
				break;
			case "-hh" :
				hh=Int32.Parse(next);
				break;
			case "-dd" :
				DD=parseInt(next);
				break;
			case "-mm" :
				mm=parseInt(next);
				break;
			case "-ss" :
				ss=parseInt(next);
				break;
			case "-mask" :
				mask=next;
				break;
			case "-filetime" :
				switch(next){
					case "created":
						if (show_dirs) {
							getFunct=Directory.GetCreationTime;
						} else {
							getFunct=File.GetCreationTime;
						}
						break;
					case "accessed":
						if (show_dirs) {
							getFunct=Directory.GetLastAccessTime;
						} else {
							getFunct=File.GetLastAccessTime;
						}
						break;
					case "modified":
						if (show_dirs) {
							getFunct=Directory.GetLastWriteTime;
						} else {
							getFunct=File.GetLastWriteTime;
						}
						break;
					default :
						Console.WriteLine("invalid value "+ next);
						Environment.Exit(4);
				}
				break;
			case "-recursive" :
				if (next == "no"){
					recursive=false;
				}
				break;
			case "-show" :
				if (next == "dirs"){
					show_dirs = true;
					show_files = false;
				}
				break;
			case "-begindate" :
				min_date=parseDate(next);
				break;			
			case "-enddate" :
				max_date=parseDate(next);
				break;					
			default:
				Console.WriteLine("Wrong argument " + arg);
				Environment.Exit(5);
		}
	}
}

//ticks are in nanoseconds
parseArgs();
if (direction=='after'){
	min_date=max_date + (hh*3600000*10000)+ (DD*86400000*10000) + (ss*1000*10000) + (mm*60000*10000) ;
}else{
	max_date=max_date + (hh*3600000*10000)+ (DD*86400000*10000) + (ss*1000*10000) + (mm*60000*10000) ;
	
}



// swap if needed
if (min_date > max_date) {
	min_date=min_date^max_date;
	max_date=min_date^max_date;
	min_date=min_date^max_date;
}



function listItems(funct,getFunct){
	var files:String[]=funct(directory,"*",System.IO.SearchOption.AllDirectories);
	for (var f=0;f<files.length;f++){
		if (getFunct(files[f]).Ticks >= min_date && getFunct(files[f]).Ticks <= max_date){
			
			Console.WriteLine(files[f]);
			//Console.WriteLine(" ; " + getFunct(files[f]).Ticks);
		}
	}
}


if (show_dirs){
	listItems(Directory.GetDirectories ,getFunct);
}

if (show_files){
	listItems(Directory.GetFiles,getFunct);
}
