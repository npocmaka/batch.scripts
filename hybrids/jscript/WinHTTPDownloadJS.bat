@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" "%~nx0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

//!!! - check https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat  - 
//  has more features and has fixed bugs still presented here.

//TODO make this simplified version of  https://github.com/npocmaka/batch.scripts/blob/master/hybrids/jscript/winhttpjs.bat


// used resources
//http://www.codeproject.com/Tips/506439/Downloading-files-with-VBScript
//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384058(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384055(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384059(v=vs.85).aspx

// global variables and constants
var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);

var url="";
var saveTo="";

var user=0;
var pass=0;

var proxy=0;
var bypass=0;
var proxy_user=0;
var proxy_pass=0;

var certificate=0;

var force=true;

//ActiveX objects
var WinHTTPObj = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
var FileSystemObj = new ActiveXObject("Scripting.FileSystemObject");
var AdoDBObj = new ActiveXObject("ADODB.Stream");

// HttpRequest SetCredentials flags.
var  HTTPREQUEST_SETCREDENTIALS_FOR_SERVER = 0;
var  HTTPREQUEST_SETCREDENTIALS_FOR_PROXY = 1;

// HttpRequest SetCredentials flags.
HTTPREQUEST_PROXYSETTING_DEFAULT   = 0;
HTTPREQUEST_PROXYSETTING_PRECONFIG = 0;
HTTPREQUEST_PROXYSETTING_DIRECT    = 1;
HTTPREQUEST_PROXYSETTING_PROXY     = 2;


// HttpRequest SetCredentials flags
HTTPREQUEST_SETCREDENTIALS_FOR_SERVER = 0;
HTTPREQUEST_SETCREDENTIALS_FOR_PROXY = 1;

function printHelp(){
	WScript.Echo(scriptName + " - downloads a file through HTTP");
	WScript.Echo(scriptName + " url localfile [-force yse|no] [-user username -password password] [-proxy proxyserver:port] [-bypass bypass_list]");
	WScript.Echo("							[-proxyuser proxy_username -proxypassword proxy_password] [-certificate certificateString]");
	WScript.Echo("-force  - decide to not or to overwrite if the local exists");
	WScript.Echo("proxyserver:port - the proxy server");
	WScript.Echo("bypass- bypass list");
	WScript.Echo("proxy_user , proxy_password - credentials for proxy server");
	WScript.Echo("user , password - credentials for the server");
	WScript.Echo("certificate - location of SSL certificate");
	WScript.Echo("Example:");
	WScript.Echo(scriptName +" http://somelink.com/somefile.zip c:\\somefile.zip -certificate \"LOCAL_MACHINE\\Personal\\My Middle-Tier Certificate\"");	
}

function parseArgs(){
	//
	if (ARGS.Length < 3) {
		WScript.Echo("insufficient arguments");
		printHelp();
		WScript.Quit(43);
	}
	url=ARGS.Item(1);
	saveTo=ARGS.Item(2);
	
	if(ARGS.Length % 2 != 1) {
		WScript.Echo("illegal arguments");
		printHelp();
		WScript.Quit(44);
	}
	
	for (var i=3;i<ARGS.Length-1;i=i+2){
		if(ARGS.Item(i).toLowerCase()=="-force" && ARGS.Item(i+1)=='no'){
			force=false;
		}
		
		if(ARGS.Item(i).toLowerCase()=="-user"){
			user=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-password"){
			pass=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-proxy"){
			proxy=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-bypass"){
			bypass=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-proxyuser"){
			proxy_user=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-proxypassword"){
			proxy_pass=ARGS.Item(i+1);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-certificate"){
			certificate=ARGS.Item(i+1);
		}
	}
}

stripTrailingSlash = function(path){
	while (path.substr(path.length - 1,path.length) == '\\') {
		path=path.substr(0, path.length - 1);
	}
	return path;
}

function existsItem(path){
	return FileSystemObj.FolderExists(path)||FileSystemObj.FileExists(path);
}

function deleteItem(path){
	if (FileSystemObj.FileExists(path)){
		FileSystemObj.DeleteFile(path);
		return true;
	} else if (FileSystemObj.FolderExists(path) ) {
		FileSystemObj.DeleteFolder(stripTrailingSlash(path));
		return true;
	} else {
		return false;
	}
}

function writeFile(fileName,data ){
	AdoDBObj.Type = 1;		 
	AdoDBObj.Open();
	AdoDBObj.Position=0;
	AdoDBObj.Write(data);
	AdoDBObj.SaveToFile(fileName,2);
	AdoDBObj.Close();	
}

function download( url,file){
	if (force && existsItem(file)){
		if(!deleteItem(file)){
			WScript.Echo("Unable to delete "+ file);
			WScript.Quit(8);
		}
	}else if (existsItem(file)){
		WScript.Echo("Item " + file + " already exist");
		WScript.Quit(9);
	}
	
	if (proxy!=0 && bypass!=0  ) {
		WinHTTPObj.SetProxy(HTTPREQUEST_PROXYSETTING_PROXY,proxy,bypass);
	}
	
	if (proxy!=0 ) {
		WinHTTPObj.SetProxy(HTTPREQUEST_PROXYSETTING_PROXY,proxy);
	}
	
	if (user!=0 && pass!=0){
		 WinHTTPObj.SetCredentials(user,pass,HTTPREQUEST_SETCREDENTIALS_FOR_SERVER);
	}
	
	if (proxy_user!=0 && proxy_pass!=0 ) {
		WinHTTPObj.SetCredentials(proxy_user,proxy_pass,HTTPREQUEST_SETCREDENTIALS_FOR_PROXY );
	}
	
	if(certificate!=0) {
		WinHTTPObj.SetClientCertificate(certificate);
	}
	
	WinHTTPObj.Open('GET',url,false);
	WinHTTPObj.Send();
	var status=WinHTTPObj.Status
	
	switch(status){
		case 200:
			WScript.Echo("Status: 200 OK");
			break;
		case 401:
			WScript.Echo("Status: 401 Unauthorized");
			WScript.Echo("Check if correct user and password were provided");
			WScript.Quit(401);
			break;
		case 407:
			WScript.Echo("Status:407 Proxy Authentication Required");
			WScript.Echo("Check if correct proxy user and password were provided");
			WScript.Quit(407);
			break;
		default:
			WScript.Echo("Status: "+status);
			WScript.Echo("Try to help yourself -> https://en.wikipedia.org/wiki/List_of_HTTP_status_codes");
			WScript.Quit(status);
	}
	writeFile(file,WinHTTPObj.ResponseBody);
}

function main(){
	parseArgs();
	download(url,saveTo);
}

main();
