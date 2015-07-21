0</* :
@echo off

	cscript /nologo /E:jscript "%~f0" %*

exit /b %errorlevel% */0;
	
	var ARGS = WScript.Arguments;
	
	if (ARGS.Item(0).toLowerCase() == "-help") {
		WScript.Echo(Wscript.ScriptName + " path_to_file search replace [search replace[search replace [...]]]");
		WScript.Quit(0);
	}

	if (ARGS.Length < 3 ) {
		WScript.Echo("Wrong arguments");
		WScript.Quit(1);
	}

	if (ARGS.Length % 2 !== 1 ) {
		WScript.Echo("Wrong arguments");
		WScript.Quit(2);
	}

	function replaceAll(find, replace, str) {
	  return str.replace(new RegExp(find, 'g'), replace);
	}
	
  function getContent(file) {
		// :: http://www.dostips.com/forum/viewtopic.php?f=3&t=3855&start=15&p=28898  ::
		var ado = WScript.CreateObject("ADODB.Stream");
		ado.Type = 2;  // adTypeText = 2
		
		ado.CharSet = "iso-8859-1";  // code page with minimum adjustments for input
		ado.Open();
		ado.LoadFromFile(file);

		var adjustment = "\u20AC\u0081\u201A\u0192\u201E\u2026\u2020\u2021" +
						 "\u02C6\u2030\u0160\u2039\u0152\u008D\u017D\u008F" +
						 "\u0090\u2018\u2019\u201C\u201D\u2022\u2013\u2014" +
						 "\u02DC\u2122\u0161\u203A\u0153\u009D\u017E\u0178" ;

						 
		var fs = new ActiveXObject("Scripting.FileSystemObject");
		var size = (fs.getFile(file)).size;
						
		var lnkBytes = ado.ReadText(size);
		ado.Close();
		var chars=lnkBytes.split('');
		for (var indx=0;indx<size;indx++) {
			if ( chars[indx].charCodeAt(0) > 255 ) {
			   chars[indx] = String.fromCharCode(128 + adjustment.indexOf(chars[indx]));
			}
		}
		return chars.join("");
   }
   
   function writeContent(file,content) {
		var ado = WScript.CreateObject("ADODB.Stream");
		ado.Type = 2;  // adTypeText = 2
		ado.CharSet = "iso-8859-1";  // right code page for output (no adjustments)
		//ado.Mode=2;
		ado.Open();

		ado.WriteText(content);
		ado.SaveToFile(file, 2);
		ado.Close();	
   }
   
   
    var filename=ARGS.Item(0);
    var content=getContent(filename);
	var newContent=content;
	var find="";
	var replace="";
	
	for (var i=1;i<ARGS.Length-1;i=i+2){
		find=ARGS.Item(i);
		replace=ARGS.Item(i+1);
		newContent=replaceAll(find,replace,newContent);
	}
	
	writeContent(filename,newContent);
