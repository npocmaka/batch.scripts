@if (@X)==(@Y) @end /* JScript comment
@echo off

:: http://www.dostips.com/forum/viewtopic.php?p=36621#p36621
:: displays numbers of pages in a pdf file relying on not mandatory metadata

cscript //E:JScript //nologo "%~f0"  %*
if "%~1" equ "" echo need a path to pdf file & exit /b 1
if not exist "%~1" echo file %1 does not exist & exit /b 2
if exist "%~1\" echo %1 is a directory & exit /b 3

exit /b 0
@if (@X)==(@Y) @end JScript comment */

   var args=WScript.Arguments;
   var filename=args.Item(0);
   var fSize=0;
   var inTag=false;
   var tempString="";
   var pages="";
   
   function getChars(fPath) {

      var ado = WScript.CreateObject("ADODB.Stream");
      ado.Type = 2;  // adTypeText = 2
      ado.CharSet = "iso-8859-1";
      ado.Open();
      ado.LoadFromFile(fPath);                
      var fs = new ActiveXObject("Scripting.FileSystemObject");
      fSize = (fs.getFile(fPath)).size;
                  
      var fBytes = ado.ReadText(fSize);
      var fChars=fBytes.split('');
      ado.Close();
      return fChars;
   }
   
   
   function checkTag(tempString) {
   
   if (tempString.length == 0 ) {
      return;
   }
   
   if (tempString.toLowerCase().indexOf("/count") == -1) {
      return;
   }
   
   if (tempString.toLowerCase().indexOf("/type") == -1) {
      return;
   }
   
   if (tempString.toLowerCase().indexOf("/pages") == -1) {
      return;
   }
   
   if (tempString.toLowerCase().indexOf("/parent") > -1) {
      return;
   }
   
   
   var elements=tempString.split("/");
   for (i = 0;i < elements.length;i++) {
      
      if (elements[i].toLowerCase().indexOf("count") > -1) {
         pages=elements[i].split(" ")[1];
         
      }
   }
   }
   
   function getPages(fPath) {
      var fChars = getChars(fPath);
      
      for (i=0;i<fSize-1;i++) {
         
         if ( fChars[i] == "<" && fChars[i+1] == "<" ) {
            inTag = true;
            continue;
         }
         
         if (inTag && fChars[i] == "<") {
            continue;
         }
         
         if ( inTag && 
              fChars[i] == ">" &&
             fChars[i+1] == ">" ) {
            
            inTag = false;
            checkTag(tempString);
            if (pages != "" ) {
               return;
            }
            
            tempString="";
            
         }
         
         if (inTag) {
            if (fChars[i] != '\n' && fChars[i] != '\r') {
               tempString += fChars[i];
             }
         }
                  
      }
   
   }
   
   getPages(filename);
   if (pages == "") {
    WScript.Echo("1");
   } else {
   WScript.Echo(pages);
   }
 
