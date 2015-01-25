@if (@X)==(@Y) @end /* JScript comment
@echo off
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
	"%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

 %~n0.exe %*

endlocal & exit /b %errorlevel%


*/

//todo SSL Support
//todo Better help message
//todo check if local file exists


import System;
import System.Net.WebClient;
import System.Net.NetworkCredential;
import System.Net.WebProxy;
import System.Uri;
import System.Security.Cryptography.X509Certificates;

var arguments:String[] = Environment.GetCommandLineArgs();

var url=0;
var toFile=0;
var force=true;

var user=0;
var password=0;

var proxy=0;
var bypass=0;
var proxy_user=0;
var proxy_pass=0;

var certificate=0;
 
function printHelp(){
	Console.WriteLine(arguments[0] + "download from url to a file");
	Console.WriteLine(arguments[0] + "<url> <file> [-user user -password password] [-proxy proxy] [-proxy_user proxy.user -proxy_pass proxy.pass]");
	
}

function parseArgs(){
	
	if (arguments.length < 3) {
		Console.WriteLine("Wrong arguments");
		printHelp();
		Environment.Exit(1);
	}
	
	if (arguments.length %2 != 1) {
		Console.WriteLine("Wrong number arguments");
		printHelp();
		Environment.Exit(2);	
	}
	
	url=arguments[1];
	toFile=arguments[2];
	
	for (var i=3;i<arguments.length-1;i=i+2){
		var arg=arguments[i].ToLower();
		switch (arg){
			case  "-user" :
				user=arguments[i+1];
				break;
			case "-password" :
				password=arguments[i+1];
				break;
			case "-proxy" :
				proxy=arguments[i+1];
				break;
			case "-proxy_user" :
				proxy_user=arguments[i+1];
				break;
			case "-proxy_pass" :
				proxy_pass=arguments[i+1];
				break;
			case "-bypass" :
				bypass=[arguments[i+1]];
				break;
			/*case "-certificate" :
				certificate=arguments[i+1];
				break;*/
			default:
				Console.WriteLine("Invalid argument "+ arguments[i]);
				printHelp();
				Environment.Exit(3);
		}
	}
	
}

function download(){
	var client:System.Net.WebClient = new System.Net.WebClient();
	
	if (user!=0 && password!=0){
		client.Credentials=new System.Net.NetworkCredential("john", "password1234!");
	}
	
	if (proxy!=0){
		var webproxy =new System.Net.WebProxy();
		webproxy.Address=new Uri(proxy);
		if (proxy_user!=0 && proxy_pass!=0){
			webproxy.Credentials=new System.Net.NetworkCredential(proxy_user,proxy_pass);
		}
		webproxy.UseDefaultCredentials =false;
		
		if (bypass!=0){
			webproxy.BypassList=bypass;
			webproxy.BypassProxyOnLocal = false;
		}
		client.Proxy=webproxy;
	}
	
	try {
		client.DownloadFile(arguments[1], arguments[2]);
	} catch (e) {
        Console.BackgroundColor = ConsoleColor.Green;
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine("\n\nProblem with downloading " + arguments[1] + " to " + arguments[2] + "Check if the internet address is valid");
        Console.ResetColor();
        Environment.Exit(5);
	}
}

 parseArgs();
 download();

