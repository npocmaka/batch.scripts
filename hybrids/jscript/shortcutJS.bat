@if (@X)==(@Y) @end /* JScript comment
@echo off

cscript //E:JScript //nologo "%~f0" "%~nx0" %*

exit /b %errorlevel%
@if (@X)==(@Y) @end JScript comment */
   
   
   var args=WScript.Arguments;
   var scriptName=args.Item(0);
   //var adminPermissions= false;
   var edit= false;
   
   function printHelp() {
	WScript.Echo(scriptName + " -linkfile link -target target [-linkarguments linkarguments]  "+
	" [-description description] [-iconlocation iconlocation] [-hotkey hotkey] "+
	" [-windowstyle 1|3|7] [-workingdirectory workingdirectory] [-adminpermissions yes|no]");
	WScript.Echo();
		WScript.Echo(scriptName + " -edit link [-target target] [-linkarguments linkarguments]  "+
	" [-description description] [-iconlocation iconlocation] [-hotkey hotkey] "+
	" [-windowstyle 1|3|7] [-workingdirectory workingdirectory] [-adminpermissions yes|no]");
	WScript.Echo();
	WScript.Echo(scriptName + " -examine link");
	WScript.Echo();
	WScript.Echo(" More info: http://msdn.microsoft.com/en-us/library/xk6kst2k%28v=vs.84%29.aspx ");
	

   
   }
   
	// reads the given .lnk file as a char array
   function getlnkChars(lnkPath) {
		// :: http://www.dostips.com/forum/viewtopic.php?f=3&t=3855&start=15&p=28898  ::
		var ado = WScript.CreateObject("ADODB.Stream");
		ado.Type = 2;  // adTypeText = 2
		
		ado.CharSet = "iso-8859-1";  // code page with minimum adjustments for input
		ado.Open();
		ado.LoadFromFile(lnkPath);

		var adjustment = "\u20AC\u0081\u201A\u0192\u201E\u2026\u2020\u2021" +
						 "\u02C6\u2030\u0160\u2039\u0152\u008D\u017D\u008F" +
						 "\u0090\u2018\u2019\u201C\u201D\u2022\u2013\u2014" +
						 "\u02DC\u2122\u0161\u203A\u0153\u009D\u017E\u0178" ;

						 
		var fs = new ActiveXObject("Scripting.FileSystemObject");
		var size = (fs.getFile(lnkPath)).size;
						
		var lnkBytes = ado.ReadText(size);
		ado.Close();
		var lnkChars=lnkBytes.split('');
		for (var indx=0;indx<size;indx++) {
			if ( lnkChars[indx].charCodeAt(0) > 255 ) {
			   lnkChars[indx] = String.fromCharCode(128 + adjustment.indexOf(lnkChars[indx]));
			}
		}
		return lnkChars;
	
   }
   
   
   function hasAdminPermissions(lnkPath) {
		return (getlnkChars(lnkPath))[21].charCodeAt(0) == 32 ;
   }
   
   
   function setAdminPermissions(lnkPath , flag) {
		lnkChars=getlnkChars(lnkPath);
		var ado = WScript.CreateObject("ADODB.Stream");
		ado.Type = 2;  // adTypeText = 2
		ado.CharSet = "iso-8859-1";  // right code page for output (no adjustments)
		//ado.Mode=2;
		ado.Open();
		// setting the 22th byte to 32 
		if (flag) {
			lnkChars[21]=String.fromCharCode(32);
		} else {
			lnkChars[21]=String.fromCharCode(0);
		}
		ado.WriteText(lnkChars.join(""));
		ado.SaveToFile(lnkPath, 2);
		ado.Close();
		
   }
   
   function examine(lnkPath) {
   
	   var fs = new ActiveXObject("Scripting.FileSystemObject");
	   if (!fs.FileExists(lnkPath)) {
		WScript.Echo("File " + lnkPath + " does not exist");
		WScript.Quit(2);
	   }
	   
	   var oWS = new ActiveXObject("WScript.Shell");
	   var oLink = oWS.CreateShortcut(lnkPath);
		
	   WScript.Echo("");	
	   WScript.Echo(lnkPath + " properties:");	
	   WScript.Echo("");
	   WScript.Echo("Target:" + oLink.TargetPath);
	   WScript.Echo("Icon Location:" + oLink.IconLocation);
	   WScript.Echo("Description:" + oLink.Description);
	   WScript.Echo("Hotkey:" + oLink.HotKey );
	   WScript.Echo("Working Directory:" + oLink.WorkingDirectory);
	   WScript.Echo("Window style:" + oLink.WindowStyle);
	   WScript.Echo("Admin Permissions:" + hasAdminPermissions(lnkPath));
	   
	   WScript.Quit(0);
   }

   
   if (WScript.Arguments.Length==1 || args.Item(1).toLowerCase() == "-help" ||  args.Item(1).toLowerCase() == "-h" ) {
	printHelp();
	WScript.Quit(0);
   }
   
   if (WScript.Arguments.Length % 2 == 0 ) {
	WScript.Echo("Illegal arguments ");
	printHelp();
	WScript.Quit(1);
   }
   
   	if ( args.Item(1).toLowerCase() == "-examine" ) {
		
		var linkfile = args.Item(2);
		examine(linkfile);
	}
	
	if ( args.Item(1).toLowerCase() == "-edit" ) {
		var linkfile = args.Item(2);
		edit=true;	
	}
    
	if(!edit) {
	   for (var arg =  1;arg<5;arg=arg+2) {
	   
			if ( args.Item(arg).toLowerCase() == "-linkfile" ) {
				var linkfile = args.Item(arg+1);
			}
					
			if (args.Item(arg).toLowerCase() == "-target") {
				var target = args.Item(arg+1);
			}
	   }
   }
   
   if (typeof linkfile === 'undefined') {
    WScript.Echo("Link file not defined");
	printHelp();
	WScript.Quit(2);
   }
   
   if (typeof target === 'undefined' && !edit) {
    WScript.Echo("Target not defined");
	printHelp();
	WScript.Quit(3);
   }
   
   
   var oWS = new ActiveXObject("WScript.Shell");
   var oLink = oWS.CreateShortcut(linkfile);

    
   if(typeof target === 'undefined') {
		var startIndex=3;
   } else {
		var startIndex=5;
		oLink.TargetPath = target;
   }
   
   
   for (var arg = startIndex ; arg<args.Length;arg=arg+2) {
		
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
		
		if (args.Item(arg).toLowerCase() == "-workingdirectory" || args.Item(arg).toLowerCase() == "-workdir") {
			oLink.WorkingDirectory = args.Item(arg+1);
		}
		
	
		if (args.Item(arg).toLowerCase() == "-adminpermissions") {
			if(args.Item(arg+1).toLowerCase() == "yes") {
				var adminPermissions= true;
			} else if(args.Item(arg+1).toLowerCase() == "no") {
				var adminPermissions= false;
			} else {
				WScript.Echo("Illegal arguments (admin permissions)");
				WScript.Quit(55);
			}
		}
   }
   oLink.Save();
   
   if (!(typeof adminPermissions === 'undefined')) {
		setAdminPermissions(linkfile ,adminPermissions);
   }
