@if (@X)==(@Y) @end /* JScript comment
@echo off

setlocal
del /q /f %~n0.exe >nul 2>&1
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

if exist "%~n0.exe" ( 
    "%~n0.exe" %* 
)


endlocal & exit /b %errorlevel%

end of jscript comment*/

import System;
import System.Windows;
import System.Windows.Forms;
import System.Drawing;
import System.Drawing.SystemIcons;


var arguments:String[] = Environment.GetCommandLineArgs();


var notificationText="Warning";
var icon=System.Drawing.SystemIcons.Hand;
var tooltip=null;
//var tooltip=System.Windows.Forms.ToolTipIcon.Info;
var title="";
//var title=null;
var timeInMS:Int32=2000;





function printHelp( ) {
   print( arguments[0] + " [-tooltip warning|none|warning|info] [-time milliseconds] [-title title] [-text text] [-icon question|hand|exclamation|аsterisk|application|information|shield|question|warning|windlogo]" );

}

function setTooltip(t) {
	switch(t.toLowerCase()){

		case "error":
			tooltip=System.Windows.Forms.ToolTipIcon.Error;
			break;
		case "none":
			tooltip=System.Windows.Forms.ToolTipIcon.None;
			break;
		case "warning":
			tooltip=System.Windows.Forms.ToolTipIcon.Warning;
			break;
		case "info":
			tooltip=System.Windows.Forms.ToolTipIcon.Info;
			break;
		default:
			//tooltip=null;
			print("Warning: invalid tooltip value: "+ t);
			break;
		
	}
	
}

function setIcon(i) {
	switch(i.toLowerCase()){
		 //Could be Application,Asterisk,Error,Exclamation,Hand,Information,Question,Shield,Warning,WinLogo
		case "hand":
			icon=System.Drawing.SystemIcons.Hand;
			break;
		case "application":
			icon=System.Drawing.SystemIcons.Application;
			break;
		case "аsterisk":
			icon=System.Drawing.SystemIcons.Asterisk;
			break;
		case "error":
			icon=System.Drawing.SystemIcons.Error;
			break;
		case "exclamation":
			icon=System.Drawing.SystemIcons.Exclamation;
			break;
		case "hand":
			icon=System.Drawing.SystemIcons.Hand;
			break;
		case "information":
			icon=System.Drawing.SystemIcons.Information;
			break;
		case "question":
			icon=System.Drawing.SystemIcons.Question;
			break;
		case "shield":
			icon=System.Drawing.SystemIcons.Shield;
			break;
		case "warning":
			icon=System.Drawing.SystemIcons.Warning;
			break;
		case "winlogo":
			icon=System.Drawing.SystemIcons.WinLogo;
			break;
		default:
			print("Warning: invalid icon value: "+ i);
			break;		
	}
}


function parseArgs(){
	if ( arguments.length == 1 || arguments[1].toLowerCase() == "-help" || arguments[1].toLowerCase() == "-help"   ) {
		printHelp();
		Environment.Exit(0);
	}
	
	if (arguments.length%2 == 0) {
		print("Wrong number of arguments");
		Environment.Exit(1);
	} 
	for (var i=1;i<arguments.length-1;i=i+2){
		try{
			//print(arguments[i] +"::::" +arguments[i+1]);
			switch(arguments[i].toLowerCase()){
				case '-text':
					notificationText=arguments[i+1];
					break;
				case '-title':
					title=arguments[i+1];
					break;
				case '-time':
					timeInMS=parseInt(arguments[i+1]);
					if(isNaN(timeInMS))  timeInMS=2000;
					break;
				case '-tooltip':
					setTooltip(arguments[i+1]);
					break;
				case '-icon':
					setIcon(arguments[i+1]);
					break;
				default:
					Console.WriteLine("Invalid Argument "+arguments[i]);
					break;
		}
		}catch(e){
			errorChecker(e);
		}
	}
}

function errorChecker( e:Error ) {
	print ( "Error Message: " + e.message );
	print ( "Error Code: " + ( e.number & 0xFFFF ) );
	print ( "Error Name: " + e.name );
	Environment.Exit( 666 );
}

parseArgs();

var notification;

notification = new System.Windows.Forms.NotifyIcon();



//try {
	notification.Icon = icon; 
	notification.BalloonTipText = notificationText;
	notification.Visible = true;
//} catch (err){}

 
notification.BalloonTipTitle=title;

	
if(tooltip!==null) { 
	notification.BalloonTipIcon=tooltip;
}


if(tooltip!==null) {
	notification.ShowBalloonTip(timeInMS,title,notificationText,tooltip); 
} else {
	notification.ShowBalloonTip(timeInMS);
}
	
var dieTime:Int32=(timeInMS+100);
	
System.Threading.Thread.Sleep(dieTime);
notification.Dispose();

