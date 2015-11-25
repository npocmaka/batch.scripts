@if (@X)==(@Y) @end /* JScript comment 
        @echo off 
       
        rem :: the first argument is the script name as it will be used for proper help message 
        cscript //E:JScript //nologo "%~f0" "%~nx0" %* 
        exit /b %errorlevel% 
@if (@X)==(@Y) @end JScript comment */ 


var sh=new ActiveXObject("WScript.Shell"); 
var ARGS = WScript.Arguments; 
var scriptName=ARGS.Item(0); 

var title="";
var keys="";

function printHelp(){ 
        WScript.Echo(scriptName + " - sends keys to a applicaion with given title"); 
        WScript.Echo("Usage:"); 
        WScript.Echo("call " + scriptName + " title string"); 
        WScript.Echo("title  - the title of the application"); 
        WScript.Echo("string - keys to be send"); 
		WScript.Echo("to send keys to no particular window use \"\" as title (e.g. shortcut keys) "); 
		WScript.Echo("  refence with special keys -> http://social.technet.microsoft.com/wiki/contents/articles/5169.vbscript-sendkeys-method.aspx");
} 

function parseArgs(){ 
                
        if (ARGS.Length < 3) { 
                WScript.Echo("insufficient arguments"); 
                printHelp(); 
                WScript.Quit(43); 
        }
		
		title=ARGS.Item(1);
		keys=ARGS.Item(2);
}


function escapeRegExp(str) {
    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(str, find, replace) {
  return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

parseArgs();
//in case the script is called with CALL command the carets will be doubled
keys=replaceAll(keys,"^^","^");

if (title === "") {
	sh.SendKeys(keys); 
	WScript.Quit(0);
}
if (sh.AppActivate(title)){
    sh.SendKeys(keys); 
	WScript.Quit(0);
} else {
	WScript.Echo("Failed to find application with title " + title);
	WScript.Quit(1);
}
