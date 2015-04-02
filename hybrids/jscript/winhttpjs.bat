@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" "%~nx0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

// used resources

//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384058(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384055(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/windows/desktop/aa384059(v=vs.85).aspx

// global variables and constants

// ------------------------
// -- asynch requests not included
// -----------------------

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
 HTTPREQUEST_PROXYSETTING_DEFAULT   = 0;
 HTTPREQUEST_PROXYSETTING_PRECONFIG = 0;
 HTTPREQUEST_PROXYSETTING_DIRECT    = 1;
 HTTPREQUEST_PROXYSETTING_PROXY     = 2;
 
 var proxy_settings=0;

 //
HTTPREQUEST_SETCREDENTIALS_FOR_SERVER = 0;
HTTPREQUEST_SETCREDENTIALS_FOR_PROXY = 1;
 
//timeouts
var RESOLVE_TIMEOUT = 0;
var CONNECT_TIMEOUT = 60000;
var SEND_TIMEOUT = 30000;
var RECEIVE_TIMEOUT = 30000;

//HttpRequestMethod
var http_method='GET';

//header
var header_file="";
var header="";

//report
var reportfile="";

//autologon policy
var autologon_policy=1; //0,1,2



//save_as_binary
var save_as_binary=false;

function printHelp(){
	WScript.Echo(scriptName + " - sends HTTP request and saves the request body as a file and/or a report of the sent request");
	WScript.Echo(scriptName + " url  [-force yse|no] [-user username -password password] [-proxy proxyserver:port] [-bypass bypass_list]");
	WScript.Echo("							[-proxyuser proxy_username -proxypassword proxy_password] [-certificate certificateString]");
	WScript.Echo("							[-method GET|POST");
	WScript.Echo("							[-saveTo file");
	
	WScript.Echo("							[-sendTimeout int(milliseconds)]");
	WScript.Echo("							[-resolveTimeout int(milliseconds)]");
	WScript.Echo("							[-connectTimeout int(milliseconds)]");
	WScript.Echo("							[-receiveTimeout int(milliseconds)]");
	
	WScript.Echo("							[-autologonPolicy 1|2|3]");
	WScript.Echo("							[-proxySettings 1|2|3] (https://msdn.microsoft.com/en-us/library/windows/desktop/aa384059(v=vs.85).aspx)");
	
	//header
	WScript.Echo("							[-header header_file]");
	//reportfile
	WScript.Echo("							[-reportfile reportfile]");
	
	WScript.Echo("-------");
	
	WScript.Echo("-force  - decide to not or to overwrite if the local exists");
	
	WScript.Echo("proxyserver:port - the proxy server");
	WScript.Echo("bypass- bypass list");
	WScript.Echo("proxy_user , proxy_password - credentials for proxy server");
	WScript.Echo("user , password - credentials for the server");
	WScript.Echo("certificate - location of SSL certificate");
	WScript.Echo("method - what HTTP method will be used.Currently only POST and GET are supported.Default is GET");
	WScript.Echo("saveTo - save the responce as binary file");

	WScript.Echo("Examples:");
	
	WScript.Echo(scriptName +" http://somelink.com/somefile.zip -saveTo c:\\somefile.zip -certificate \"LOCAL_MACHINE\\Personal\\My Middle-Tier Certificate\"");
	WScript.Echo(scriptName +" http://somelink.com/something.html  -method POST  -certificate \"LOCAL_MACHINE\\Personal\\My Middle-Tier Certificate\" -header c:\\header_file -reportfile c:\\reportfile.txt");
}

function parseArgs(){
	//
	if (ARGS.Length < 3) {
		WScript.Echo("insufficient arguments");
		printHelp();
		WScript.Quit(43);
	}
	url=ARGS.Item(1);
	WScript.Echo("URL:"+url);
	//saveTo=ARGS.Item(2);
	
	if(ARGS.Length % 2 != 0) {
		WScript.Echo("illegal arguments");
		printHelp();
		WScript.Quit(44);
	}
	
	WScript.Echo(ARGS.Length);
	
	for (var i=2;i<ARGS.Length-1;i=i+2){
		//TODO use switch-case instead of IFs
		
		WScript.Echo("Parsing args");
		WScript.Echo(i + "-->"+ ARGS.Item(i).toLowerCase());
		
		if(ARGS.Item(i).toLowerCase()=="-force" && ARGS.Item(i+1)=='no'){
			force=false;
		}
		
		if(ARGS.Item(i).toLowerCase()==="-saveto"){
			saveTo=ARGS.Item(i+1);
			save_as_binary=true;
			
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
		
		if(ARGS.Item(i).toLowerCase()=="-method"){
			WScript.Echo("Setting the method");
			if (ARGS.Item(i+1).toLowerCase()=="post") {
				http_method='POST';
			}
		}
		
		if(ARGS.Item(i).toLowerCase()=="-header"){
			header_file=ARGS.Item(i+1);
			header=readTextFile(header_file);
		}
		
		if(ARGS.Item(i).toLowerCase()=="-reportfile"){
			WScript.Echo("report file: "+ reportfile);
			reportfile=ARGS.Item(i+1);
			
		}
		
		//timeouts
		try {  // possible parseint error
			if(ARGS.Item(i).toLowerCase()=="-sendtimeout"){
				SEND_TIMEOUT=parseInt(ARGS.Item(i+1));
			}
			
			if(ARGS.Item(i).toLowerCase()=="-resolvetimeout"){
				RESOLVE_TIMEOUT=parseInt(ARGS.Item(i+1));
			}
			
			if(ARGS.Item(i).toLowerCase()=="-connecttimeout"){
				CONNECT_TIMEOUT=parseInt(ARGS.Item(i+1));
			}

			if(ARGS.Item(i).toLowerCase()=="-receivetimeout"){
				RECEIVE_TIMEOUT=parseInt(ARGS.Item(i+1));
			}
			
					
			if(ARGS.Item(i).toLowerCase()=="-autologonpolicy"){
				autologon_policy=parseInt(ARGS.Item(i+1));
				if (autologon_policy>2||autologon_policy<0){
					WScript.Echo("out of autologon policy range");
					WScript.Quit(87);
				}
			}
			
			if(ARGS.Item(i).toLowerCase()=="-proxysettings"){
				proxy_settings=parseInt(ARGS.Item(i+1));
				if (autologon_policy>2||autologon_policy<0){
					WScript.Echo("out of autologon policy range");
					WScript.Quit(87);
				}
			}
			
			
		} catch (err){
			WScript.Echo(err.message);
			Wscript.Quit(90);
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



function readTextFile(fileName){
	//check existence
	if (!FileSystemObj.FileExists(path)){
		WScript.Echo("file " + fileName + " does not exist!");
		WScript.Quit(15);
	}
	var fileR=FileSystemObj.OpenTextFile(fileName,1);
	var content=fileR.ReadAll();
	fileR.Close();
	return content;
	
}



function request( url){

	if (proxy!=0 && bypass!=0  ) {
		WinHTTPObj.SetProxy(proxy_settings,proxy,bypass);
	}
	
	if (proxy!=0 ) {
		WinHTTPObj.SetProxy(proxy_settings,proxy);
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
	
	
	//set autologin policy
	WinHTTPObj.SetAutoLogonPolicy(autologon_policy);
	//set timeouts
	WinHTTPObj.SetTimeouts(RESOLVE_TIMEOUT,CONNECT_TIMEOUT,SEND_TIMEOUT,RECEIVE_TIMEOUT);

	
	
	try {
		WinHTTPObj.Open(http_method,url,false);
		WinHTTPObj.Send();
		var status=WinHTTPObj.Status
	} catch (err) {
		WScript.Echo(err.message);
		WScript.Quit(666);
	}
	
 
	
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
			Wscript.Echo("Status:407 Proxy Authentication Required");
			Wscript.Echo("Check if correct proxy user and password were provided");
			WScript.Quit(407);
			break;
		default:
			Wscript.Echo("Status: "+status);
			WScript.Echo("Try to help yourself -> https://en.wikipedia.org/wiki/List_of_HTTP_status_codes");
			WScript.Quit(status);
	}
	
	
	////////////////////////
	//     report         //
	////////////////////////

	if(reportfile!="" ) {
	
		//var report_string="";
		var n="\r\n";
		var report_string="Status:"+n;
		report_string=report_string+"      "+WinHTTPObj.Status;
		report_string=report_string+"      "+WinHTTPObj.StatusText+n;
		report_string=report_string+"      "+n;
		report_string=report_string+"Response:"+n;
		report_string=report_string+WinHTTPObj.ResponseText+n;
		report_string=report_string+"      "+n;
		report_string=report_string+"Headers:"+n;
		report_string=report_string+WinHTTPObj.GetAllResponseHeaders()+n;
		
		WinHttpRequestOption_UserAgentString = 0;    // Name of the user agent
		WinHttpRequestOption_URL = 1;                // Current URL
		WinHttpRequestOption_URLCodePage = 2;        // Code page
		WinHttpRequestOption_EscapePercentInURL = 3; // Convert percents 
                                             // in the URL
		
		report_string=report_string+"URL:"+n;
		report_string=report_string+WinHTTPObj.Option(WinHttpRequestOption_URL)+n;
		
		report_string=report_string+"URL Code Page:"+n;
		report_string=report_string+WinHTTPObj.Option(WinHttpRequestOption_URLCodePage)+n;
		
		report_string=report_string+"User Agent:"+n;
		report_string=report_string+WinHTTPObj.Option(WinHttpRequestOption_UserAgentString)+n;
		
		report_string=report_string+"Escapped URL:"+n;
		report_string=report_string+WinHTTPObj.Option(WinHttpRequestOption_EscapePercentInURL)+n;
		
		WScript.Echo("writing a report ");
		prepareateFile(force,reportfile);
		
		WScript.Echo("Writing report to "+reportfile);
		
		writeFile(reportfile,report_string);
		
	}
	
	//if as binary
	if (save_as_binary){
		prepareateFile(force,saveTo);
		try {
			writeBinFile(saveTo,WinHTTPObj.ResponseBody);
		} catch (err) {
			WScript.Echo("Failed to save the file as binary.Attempt to save it as text");
			AdoDBObj.Close();
			prepareateFile(true,saveTo);
			writeFile(saveTo,WinHTTPObj.ResponseText);
		}
	}
}

function prepareateFile(force,file){
	if (force && existsItem(file)){
		if(!deleteItem(file)){
			WScript.Echo("Unable to delete "+ file);
			WScript.Quit(8);
		}
	}else if (existsItem(file)){
		WScript.Echo("Item " + file + " already exist");
		WScript.Quit(9);
	}
}

function writeBinFile(fileName,data ){
	AdoDBObj.Type = 1;		 
	AdoDBObj.Open();
	AdoDBObj.Position=0;
	AdoDBObj.Write(data);
	AdoDBObj.SaveToFile(fileName,2);
	AdoDBObj.Close();	
}

function writeFile(fileName,data ){
	AdoDBObj.Type = 2;
	AdoDBObj.CharSet = "iso-8859-1";
	AdoDBObj.Open();
	AdoDBObj.Position=0;
	AdoDBObj.WriteText(data);
	AdoDBObj.SaveToFile(fileName,2);
	AdoDBObj.Close();	
}

function writeTextFile(fileName,data,append){
	var fileW;
	if(append)	{
		fileW=FileSystemObj.OpenTextFile(fileName,8,false,true);
	} else {
		fileW=FileSystemObj.OpenTextFile(fileName,2,true,true);
	}
	fileW.Write(data);
	fileW.Close();
}

function main(){
	parseArgs();
	request(url);
}

main();
