@if (@X)==(@Y) @end /* JScript comment 
        @echo off 
        for /f "tokens=2" %%a in ("%cmdcmdline%") do  set "switch=%%a" 
        
        rem determine if the command is clicked or called from command line 
        if /i "%switch%" == "/c" ( 
                mode 15,1 
                prompt #auto-login# 
                title  #auto-login# 
        ) 
        
        rem check if arguments are passed to the script
        if "%~1" == "" ( 
                mode 15,1 
                prompt #auto-login# 
                title  #auto-login# 
        ) 
        
        
        rem :: the first argument is the script name as it will be used for proper help message 
        cscript //E:JScript //nologo "%~f0" "%~nx0" %* 
        exit /b %errorlevel% 
@if (@X)==(@Y) @end JScript comment */ 

// 
// written by Vasil "npocmaka" Arnaudov 
// 

//ActiveX objects 
var sh=new ActiveXObject("WScript.Shell"); 
var FileSystemObj = new ActiveXObject("Scripting.FileSystemObject"); 

var ARGS = WScript.Arguments; 
var scriptName=ARGS.Item(0); 

//variables 
var user=""; 
var pass=""; 
var stopOnLogon=false; 


var popupString={ 
        IE : "Windows Security", 
        FireFox : "Authentication Required" 
        // Opera and Chrome use pop-ups without title and cant be handled by appActivate function 
        // IDK about Safari , but I don't care. 
} 

var act=popupString.FireFox; 

function readPropFile(fileName){ 
        //check existence   
        if (!FileSystemObj.FileExists(fileName)){ 
                WScript.Echo("(headers)file " + fileName + " does not exist!"); 
                WScript.Quit(15); 
        } 
        if (FileSystemObj.GetFile(fileName).Size === 0){ 
                return; 
        } 
        var fileR=FileSystemObj.OpenTextFile(fileName,1); 
        var line=""; 

        var lineN=0; 
        var index=0; 
                var key=""; 
                var value=""; 
        try { 
                WScript.Echo("parsing  "+fileName+" property file "); 
                while(!fileR.AtEndOfStream){ 
                        line=fileR.ReadLine(); 
                        lineN++; 
                        index=line.indexOf("="); 
                        if(line.indexOf("#") === 0 || trim(line)==="") { 
                                continue; 
                        } 
                        if(index=== -1 || index === line.length-1 || index === 0) { 
                                WScript.Echo("Invalid line "+ lineN); 
                                WScript.Quit(93); 
                        } 
                                                key=trim(line.substring(0,index)).toLowerCase(); 
                                                value=trim(line.substring(index+1,line.length)); 
                                            switch(key) { 
                                                        case "browser": 
                                                                popupString=selectBrowser(value);                                                                 
                                                                break; 
                                                        case "user": 
                                                                user=value; 
                                                                break; 
                                                        case "pass": 
                                                        case "password": 
                                                                pass=value; 
                                                                break; 
                                                        case "stoponlogon": 
                                                                if (value.toLowerCase() === "yes") { 
                                                                        stopOnLogon=true; 
                                                                } 
                                                                
                                                } 
                } 
                fileR.Close(); 
        }catch (err){ 
                WScript.Echo("Error while reading file: "+fileName); 
                WScript.Echo(err.message); 
                                return; 
        } 
} 

function trim(str){ 
        return str.replace(/^\s+/,'').replace(/\s+$/,''); 
} 
function printHelp(){ 
        WScript.Echo(scriptName + " - Autolgin for Firefox/InternetExplorer authentication pop-up aimed to help for protractor/selenium tests"); 
        WScript.Echo("Usage:"); 
        WScript.Echo(scriptName + " [-browser ie|firefox] [-user username] [-pass password] [-file file] [-stoponlogon yes|no]"); 
        WScript.Echo("-browser  default is firefox"); 
        WScript.Echo("-file  path to file that contains a property file with user and password key/value"); 
        WScript.Echo("if no user/password are provided default.props will searched ") 
        WScript.Echo("or -user/-pass or -file arguments must be passed"); 
        WScript.Echo("-stoponlogon whether or not the script will stop after first fulfil of the authentication pop-up"); 
        WScript.Echo("default is no"); 
} 
function selectBrowser(str){ 
        switch (str.toLowerCase()){ 
                case "ie": 
                case "internetexplorer": 
                        act=popupString.IE; 
                        break; 
                case "ff": 
                case "firefox": 
                        act=popupString.firefox; 
                        break;         
        } 
} 

//--------------------------- 
function parseArgs(){ 
                // 
        if (ARGS.Length < 3) { 
                WScript.Echo("insufficient arguments"); 
                printHelp(); 
                WScript.Quit(43); 
        } 

        if(ARGS.Length % 2 != 1) { 
                WScript.Echo("illegal arguments"); 
                printHelp(); 
                WScript.Quit(44); 
        } 
                
                for (var i=2;i<ARGS.Length-1;i=i+2){ 
            var arg=ARGS.Item(i).toLowerCase(); 
            var next=ARGS.Item(i+1); 

            try { switch(arg) { 
                                case "-browser": 
                    popupString=selectBrowser(next);                                                                 
                    break; 
                            case "-user": 
                                        user=next; 
                                        break; 
                                case "-pass": 
                                case "-password": 
                                        pass=next; 
                                        break; 
                                case "-file": 
                                        readPropFile(next); 
                                        break; 
                                case "-stoponlogon": 
                                        if (next.toLowerCase() === "yes") { 
                                                stopOnLogon=true; 
                                        } 
                                        
            }}catch (err) { 
                                WScript.Echo("Some kind of error"); 
                                WScript.Echo(err.message); 
                                WScript.Quit(91); 
                        } 
        }                         

} 
//--------------------------- 

//-------------------------- 
if (user === "" || pass === "") { 
        
        if(!FileSystemObj.FileExists("default.props")){ 
                WScript.Echo("No credentials provided"); 
                WScript.Quit(81); 
        } else { 
                readPropFile("default.props"); 
        } 
        if (user === "" || pass === ""){ 
                WScript.Echo("No credentials provided"); 
                WScript.Quit(82); 
        } 
        
} 
if(act===popupString.FireFox){ 
        WScript.Echo("Firefox autologin started"); 
} 

if(act===popupString.IE){ 
        WScript.Echo("Internet Explorer autologin started"); 
} 

for(;;){ 
        WScript.Sleep(300); 
        
        if (sh.AppActivate(act)){ 
                sh.SendKeys(user+"{TAB}"+pass+"{ENTER}"); 
                if (stopOnLogon) { 
                        WScript.Echo("Exiting on first logon"); 
                        WScript.Quit(0); 
                } 
        }         
} 
//--------------------------
