0</* :
@echo off

	cscript /nologo /E:jscript "%~f0" %*

exit /b %errorlevel% */0;
	
	var ARGS = WScript.Arguments;
	
	if (ARGS.Length < 3 ) {
		WScript.Echo("Wrong arguments");
		WScript.Echo(WScript.ScriptName + " path_to_file search replace [search replace[search replace [...]]]");
		WScript.Echo(WScript.ScriptName + " e?path_to_file search replace [search replace[search replace [...]]]");
		WScript.Echo("if filename starts with \"e?\" search and replace string will be evaluated for special characters ")
		WScript.Quit(1);
	}
	
	if (ARGS.Item(0).toLowerCase() == "-help" || ARGS.Item(0).toLowerCase() == "-h") {
		WScript.Echo(WScript.ScriptName + " path_to_file search replace [search replace[search replace [...]]]");
		WScript.Echo(WScript.ScriptName + " e?path_to_file search replace [search replace[search replace [...]]]");
		WScript.Echo("if filename starts with \"e?\" search and replace string will be evaluated for special characters ")
		WScript.Quit(0);
	}



	if (ARGS.Length % 2 !== 1 ) {
		WScript.Echo("Wrong arguments");
		WScript.Quit(2);
	}
	
	var jsEscapes = {
	  'n': '\n',
	  'r': '\r',
	  't': '\t',
	  'f': '\f',
	  'v': '\v',
	  'b': '\b'
	};
	
	
	//string evaluation
	//http://stackoverflow.com/questions/24294265/how-to-re-enable-special-character-sequneces-in-javascript
	
	function decodeJsEscape(_, hex0, hex1, octal, other) {
	  var hex = hex0 || hex1;
	  if (hex) { return String.fromCharCode(parseInt(hex, 16)); }
	  if (octal) { return String.fromCharCode(parseInt(octal, 8)); }
	  return jsEscapes[other] || other;
	}

	function decodeJsString(s) {
	  return s.replace(
		  // Matches an escape sequence with UTF-16 in group 1, single byte hex in group 2,
		  // octal in group 3, and arbitrary other single-character escapes in group 4.
		  /\\(?:u([0-9A-Fa-f]{4})|x([0-9A-Fa-f]{2})|([0-3][0-7]{0,2}|[4-7][0-7]?)|(.))/g,
		  decodeJsEscape);
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
   
	if (typeof String.prototype.startsWith != 'function') {
	  // see below for better implementation!
	  String.prototype.startsWith = function (str){
		return this.indexOf(str) === 0;
	  };
	}
   
   
	var evaluate=false;
    var filename=ARGS.Item(0);
	if(filename.toLowerCase().startsWith("e?")) {
		filename=filename.substring(2,filename.length);
		evaluate=true;
	}
    var content=getContent(filename);
	var newContent=content;
	var find="";
	var replace="";
	
	for (var i=1;i<ARGS.Length-1;i=i+2){
		find=ARGS.Item(i);
		replace=ARGS.Item(i+1);
		if(evaluate){
			find=decodeJsString(find);
			replace=decodeJsString(replace);
		}
		newContent=replaceAll(find,replace,newContent);
	}
	
	writeContent(filename,newContent);
