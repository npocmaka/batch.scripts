@if (@x)==(@y) @end /***** jscript comment ******
     @echo off
     cscript //E:JScript //nologo "%~f0" "%~nx0" %* 
     exit /b %errorlevel%

 @if (@x)==(@y) @end ******  end comment *********/
 
var FileSystemObj = new ActiveXObject("Scripting.FileSystemObject");

var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);

//var arguments:String[] = Environment.GetCommandLineArgs();

var directory=".";
//var filter="creation";
var max_date=(new Date()).getTime();
var min_date=(new Date(0)).getTime();

var DD=0;
var hh=0;
var mm=0;
var ss=0;

var recursive=true;
var show_dirs=false;
var show_files=true;
var direction="after";

//var show_files=true;
//var show_dirs=false;
var getFunct=getDateCreated;
function printHelp(){
	WScript.Echo(scriptName + " filters files/directories by date or time");
	WScript.Echo("");
	WScript.Echo("Usage:");
	WScript.Echo(scriptName + " directory [options]");
	WScript.Echo("Options:");
	WScript.Echo("-beginDate dd-MM-yy#hh:mm:ss -endDate  dd-MM-yy#hh:mm:ss");
	WScript.Echo("		will show files/directories between the two dates.Date formats ");
	WScript.Echo("		Short dates can use either a '/' or "-" date separator, but must follow the month/day/year format, for example '7/20/96'");
	WScript.Echo("		Long dates of the form 'July 10 1995' can be given with the year, month, and day in any order, and the year in 2-digit or 4-digit form. If you use the 2-digit form, the year must be greater than or equal to 70.");
	WScript.Echo("		Any text inside parentheses is treated as a comment. These parentheses may be nested.");
	WScript.Echo("		Both commas and spaces are treated as delimiters. Multiple delimiters are permitted.");
	WScript.Echo("		Month and day names must have two or more characters. Two character names that are not unique are resolved as the last match. For example, 'Ju' is resolved as July, not June.");
	WScript.Echo("		The stated day of the week is ignored if it is incorrect given the remainder of the supplied date. For example, 'Tuesday November 9 1996' is accepted and parsed even though that date actually falls on a Friday. The resulting Date object contains 'Friday November 9 1996'.");
	WScript.Echo("		JScript handles all standard time zones, as well as Universal Coordinated Time (UTC) and Greenwich Mean Time (GMT).");
	WScript.Echo("		Hours, minutes, and seconds are separated by colons, although all need not be specified. '10:', '10:11', and '10:11:12' are all valid.");
	WScript.Echo("		If the 24-hour clock is used, it is an error to specify 'PM' for times later than 12 noon. For example, '23:15 PM' is an error.");
	WScript.Echo("		A string containing an invalid date is an error. For example, a string containing two years or two months is an error.");
	WScript.Echo("-direction before|after  ");
	WScript.Echo("    will search for files/directories before or after given date.Default is after");
	WScript.Echo("-hh  Number");
	WScript.Echo("    Will add/subtract(if number is negative) hours to given dates");
	WScript.Echo("    Default is 0");
	WScript.Echo("-mm  Number");
	WScript.Echo("    Will add/subtract(if number is negative) minutes to given dates");
	WScript.Echo("    Default is 0");
	WScript.Echo("-dd  Number");
	WScript.Echo("    Will add/subtract(if number is negative) days to given dates");
	WScript.Echo("    Default is 0");
	WScript.Echo("-ss Number");
	WScript.Echo("    Will add/subtract(if number is negative) seconds to given dates");
	WScript.Echo("    Default is 0");
	WScript.Echo("-recursive yes|no");
	WScript.Echo("    Will search be recursive or not");
	WScript.Echo("    Default is yes");
	WScript.Echo("-show dirs|files|all");
	WScript.Echo("    Will search files or directories");
	WScript.Echo("    Default is files");
	WScript.Echo("");
	WScript.Echo("-show dirs|files|all");
	WScript.Echo("     Will search files or directories by passed time property ");
	WScript.Echo("    Default is files");
	WScript.Echo("");
	WScript.Echo("Examples:");
	WScript.Echo("");
	WScript.Echo("Will show files older than 5 hours");
	WScript.Echo(scriptName + '"." -hh -5');
	WScript.Echo("");
	WScript.Echo("Will show files between the begin and end date");
	WScript.Echo(scriptName + '"." -beginDate "September 1, 2014 10:15 AM" -endDate "November 1, 2014 10:15 PM" ');
	WScript.Echo("Will show files newer than 5 hours starting from given date");
	WScript.Echo(scriptName + '"." -hh 5 -beginDate -beginDate "September 1, 2014 10:15 AM"');
	WScript.Echo("");
	WScript.Echo("Will show files older than 5 hours starting from given date");
	WScript.Echo(scriptName + '"." -hh 5 -beginDate -beginDate "September 1, 2014 10:15 AM" -direction before');
	WScript.Echo("");
	
}

	


function getLastModified(obj){
	return obj.DateLastModified;
}

function getDateCreated(obj){
	return obj.DateCreated;
}

function getLastAccessed(obj){
	return obj.DateLastAccessed;
}

function check(enumObj,filterFunction){
	for (; !enumObj.atEnd(); enumObj.moveNext()){
		var dateObj=new Date(filterFunction(enumObj.item()));
		if ((dateObj.getTime() <= max_date) && 
			(dateObj.getTime() >= min_date)){
				WScript.Echo(enumObj.item());
		}
	}
}

function parseDate(string){
	//https://msdn.microsoft.com/en-us/library/k4w173wk(v=vs.84).aspx
	try {
		return Date.parse(string);
	} catch (err){
		WScript.Echo("Wrong date format");
		WScript.Echo(err.message);
		WScript.Quit(4);
	}
}

function list(directory,filterFunction){
	var folder=FileSystemObj.GetFolder(directory);
	if (show_files){
		var file_enum = new Enumerator(folder.files);
		check(file_enum,filterFunction);
	}
	if (show_dirs){
		var folder_enum = new Enumerator(folder.SubFolders );
		check(folder_enum,filterFunction);
	}
	if(recursive){
		var folder_enum = new Enumerator(folder.SubFolders );
		for (;!folder_enum.atEnd(); folder_enum.moveNext()){
			list(folder_enum.item(),filterFunction);
		}
	}
}

function parseArgs(){
	
	if (ARGS.Item(1) == "-h" || ARGS.Item(1) == "-help"){
		printHelp();
	}
	
	if (ARGS.length<2){
		WScript.Echo("Wrong arguments");
		printHelp();
		Environment.Exit(1);
	}
	
	if (ARGS.length%2 != 0){
		WScript.Echo("Wrong number of arguments");
		printHelp();
		Environment.Exit(2);
	}
	
	directory=ARGS.Item(1);
	
	for (var i=2;i<ARGS.length-1;i=i+2){
		var arg= ARGS.Item(i).toLowerCase();
		var next=ARGS.Item(i+1).toLowerCase();
		switch (arg){
			case "-direction" :
				if (next == 'before') {
					direction="before";
				}
				break;
			case "-hh" :
				hh=parseInt(next);
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
			case "-filetime" :
				switch(next){
					case "created":
						getFunct=getDateCreated;
						break;
					case "accessed":
						getFunct=getLastAccessed;
						break;
					case "modified":
						getFunct=getLastModified;
						break;
					default :
						WScript.Echo("invalid value "+ next);
						WScript.Quit(4);
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
				if (next == "all"){
					show_dirs = true;
					show_files = true;
				}
				break;
			case "-begindate" :
				min_date=parseDate(next);
				break;			
			case "-enddate" :
				max_date=parseDate(next);
				break;					
			default:
				WScript.Echo("Wrong argument " + arg);
				WScript.Quit(5);
		}
	}
}

parseArgs();

//ticks are in nanoseconds

if (direction=='after'){
	min_date=max_date + (hh*3600000)+ (DD*86400000) + (ss*1000) + (mm*60000) ;
}else{
	max_date=max_date + (hh*3600000)+ (DD*86400000) + (ss*1000) + (mm*60000) ;
	
}

// swap if needed
if (min_date > max_date) {
	min_date=min_date^max_date;
	max_date=min_date^max_date;
	min_date=min_date^max_date;
}

list(directory,getFunct);
