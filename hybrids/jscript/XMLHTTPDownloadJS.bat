@if (@X)==(@Y) @end /* JScript comment
	@echo off
	
	rem :: the first argument is the script name as it will be used for proper help message
	cscript //E:JScript //nologo "%~f0" "%~nx0" %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */

// used resources
//http://www.codeproject.com/Tips/506439/Downloading-files-with-VBScript
//http://blogs.msdn.com/b/xmlteam/archive/2006/10/23/using-the-right-version-of-msxml-in-internet-explorer.aspx
//https://msdn.microsoft.com/en-us/library/ie/ms535874(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/aa923283.aspx
//https://msdn.microsoft.com/en-us/library/ms759148(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/ms759148(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/ms760236(v=vs.85).aspx
//http://stackoverflow.com/questions/20712635/providing-authentication-info-via-msxml2-serverxmlhttp
//https://msdn.microsoft.com/en-us/library/ms763680(v=vs.85).aspx
//https://msdn.microsoft.com/en-us/library/ms757849(v=vs.85).aspx
//http://fm4dd.com/programming/shell/microsoft-vbs-http-download.htm
//http://stackoverflow.com/questions/11573022/vba-serverxmlhttp-https-request-with-self-signed-certificate
//http://www.qtcentre.org/threads/44629-Using-XMLHttpRequest-for-HTTPS-Post-to-server-with-SSL-certificate

// global variables and constants
var ARGS = WScript.Arguments;
var scriptName=ARGS.Item(0);

var url="";
var saveTo="";

var user=0;
var pass=0;

var proxy=0;
var bypass="";
var proxy_user=0;
var proxy_pass=0;

var certificate=0;

var force=true;

//ActiveX objects
//Use the right version of MSXML
/*var progIDs = [ 'Msxml2.DOMDocument.6.0', 'Msxml2.DOMDocument.5.0', 'Msxml2.DOMDocument.4.0', 'Msxml2.DOMDocument.3.0', 'Msxml2.DOMDocument' ]
for (var i = 0; i < progIDs.length; i++) {
    try {
        var XMLHTTPObj = new ActiveXObject(progIDs[i]);
    }catch (ex) {		
	}
}

if typeof  XMLHTTPObj === 'undefined'{
	WScript.Echo ("You are using too ancient windows or you have no installed IE");
	WScript.Quit(1);
}*/

var XMLHTTPObj = new ActiveXObject("MSXML2.XMLHTTP");
var FileSystemObj = new ActiveXObject("Scripting.FileSystemObject");
var AdoDBObj = new ActiveXObject("ADODB.Stream");


function printHelp(){
	WScript.Echo(scriptName + " - downloads a file through HTTP");
	WScript.Echo(scriptName + " url localfile [-force yse|no] [-user username -password password] [-proxy proxyserver:port -bypass bypass_list]");
	WScript.Echo("							[-proxyuser proxy_username -proxypassword proxy_password] [-certificate certificateString]");
	WScript.Echo("-force  - decide to not or to overwrite if the local exists");
	WScript.Echo("proxyserver:port - the proxy server");
	WScript.Echo("bypass- bypass list can be \"\" if you don't need it");
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

function existsItem(path){
	return FileSystemObj.FolderExists(path)||FileSystemObj.FileExists(path);
}

stripTrailingSlash = function(path){
	while (path.substr(path.length - 1,path.length) == '\\') {
		path=path.substr(0, path.length - 1);
	}
	return path;
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
	

	
	if (proxy!=0 && bypass !="") {
		//https://msdn.microsoft.com/en-us/library/ms760236(v=vs.85).aspx
		XMLHTTPObj.setProxy(SXH_PROXY_SET_DIRECT,proxy,bypass);
	} else if (proxy!=0) {
		XMLHTTPObj.setProxy(SXH_PROXY_SET_DIRECT,proxy,"");
	}
	

	
	if (proxy_user!=0 && proxy_pass!=0 ) {
		//https://msdn.microsoft.com/en-us/library/ms763680(v=vs.85).aspx
		XMLHTTPObj.setProxyCredentials(proxy_user,proxy_pass);
	}
	
	if(certificate!=0) {
		//https://msdn.microsoft.com/en-us/library/ms763811(v=vs.85).aspx
		WinHTTPObj.setOption(3,certificate);
	}
	
	if (user!=0 && pass!=0){
		//https://msdn.microsoft.com/en-us/library/ms757849(v=vs.85).aspx
		 XMLHTTPObj.Open('GET',url,false,user,pass);
	} else {
		XMLHTTPObj.Open('GET',url,false);
	}
	
	
	
	XMLHTTPObj.Send();
	var status=XMLHTTPObj.Status;
	
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
	writeFile(file,XMLHTTPObj.ResponseBody);
}

function main(){
	parseArgs();
	download(url,saveTo);
}
main();
