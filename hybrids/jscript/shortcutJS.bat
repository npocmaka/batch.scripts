@if (@X)==(@Y) @end /* JScript comment
@echo off

cscript //E:JScript //nologo "%~f0" "%~nx0" %*

exit /b %errorlevel%

by Vasil "npocmaka" Arnaudov

@if (@X)==(@Y) @end JScript comment */
   
   
   var args=WScript.Arguments;
   var scriptName=args.Item(0);
   
   function printHelp() {
	WScript.Echo(scriptName + " -linkfile link -target target [-linkarguments linkarguments]  "+
	" [-description description] [-iconlocation iconlocation] [-hotkey hotkey] [-relativepath relativepath]"+
	" [-windowstyle windowstyle] [-workingdirectory workingdirectory]");
	
	WScript.Echo(" More info: http://msdn.microsoft.com/en-us/library/xk6kst2k%28v=vs.84%29.aspx ");
   
   }
   
   if (WScript.Arguments.Length==1 || args.Item(1).toLowerCase() == "-h" ||  args.Item(1).toLowerCase() == "-h" ) {
	printHelp();
	WScript.Quit(0);
   }
   
   if (WScript.Arguments.Length % 2 == 2 ) {
	WScript.Echo("Illegal arguments ");
	printHelp();
	WScript.Quit(1);
   }
     
   for (var arg =  1;arg<5;arg=arg+2) {
   
		if ( args.Item(arg).toLowerCase() == "-linkfile" ) {
			var linkfile = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-target") {
			var target = args.Item(arg+1);
		}
	
   }
   
   if (typeof linkfile === 'undefined') {
    WScript.Echo("Link file not defined");
	printHelp();
	WScript.Quit(2);
   }
   
   if (typeof target === 'undefined') {
    WScript.Echo("Target not defined");
	printHelp();
	WScript.Quit(3);
   }
   
   
   var oWS = new ActiveXObject("WScript.Shell");
   var sLinkFile = linkfile;
   var oLink = oWS.CreateShortcut(sLinkFile);
   oLink.TargetPath = target;
   
   for (var arg = 5; arg<args.Length;arg=arg+2) {
		
		if (args.Item(arg).toLowerCase() == "-linkarguments") {
			oLink.Arguments = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-description") {
			oLink.Description = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-hotkey") {
			oLink.HotKey = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-iconlocation") {
			oLink.IconLocation = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-windowstyle") {
			oLink.WindowStyle = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-workdir") {
			oLink.WorkingDirectory = args.Item(arg+1);
		}
		
		if (args.Item(arg).toLowerCase() == "-relativepath") {
			oLink.RelativePath= args.Item(arg+1);
		}
   }
   oLink.Save();
