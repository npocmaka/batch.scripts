@if (@X)==(@Y) @end /* JScript comment
    @echo off

    cscript //E:JScript //nologo "%~f0" %*

    exit /b %errorlevel%

@if (@X)==(@Y) @end JScript comment */

if (WScript.Arguments.Length < 1 ) {
	WScript.Echo(WScript.ScriptName + " input_file output_file");
	WScript.Quit(0)
}

var fso= new ActiveXObject("Scripting.FileSystemObject");
var inputFile=WScript.Arguments.Item(0);

if (!fso.FileExists(inputFile)){
	WScript.Echo(inputFile + " does not exist");
	WScript.Echo("usage:");
	WScript.Echo(WScript.ScriptName + " input_file [output_file]");
	WScript.Quit(1);
}




   function getFileContent(file) {
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
						
		var content = ado.ReadText(size);
		ado.Close();
		return content;
	
   }
   
   function writeContent(file,content) {
   // :: http://www.dostips.com/forum/viewtopic.php?f=3&t=3855&start=15&p=28898  ::
		var ado = WScript.CreateObject("ADODB.Stream");
		ado.Type = 2;  // adTypeText = 2
		ado.CharSet = "iso-8859-1";  // right code page for output (no adjustments)
		//ado.Mode=2;
		ado.Open();

		ado.WriteText(content);
		ado.SaveToFile(file, 2);
		ado.Close();	
   }

   String.prototype.toHtmlEntities = function() {
   // :: http://stackoverflow.com/questions/18749591/encode-html-entities-in-javascript ::
    return this.replace(/[\u00A0-\u9999<>\&]/gim , function(s) {
        return "&#" + s.charCodeAt(0) + ";";
    });
   };


function printToConsole(fileContent){
	//WScript.Echo(fileContent);
	WScript.Echo(fileContent.toHtmlEntities());
}

function printToFile(fileContent,file){
	writeContent(fileContent.toHtmlEntities(),file);

}

if (WScript.Arguments.Length > 1) {
	var outputFile=WScript.Arguments.Item(1);
	printToFile(outputFile,getFileContent(inputFile));
} else {
	printToConsole(getFileContent(inputFile));
}
