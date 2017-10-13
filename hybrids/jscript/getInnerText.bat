@if (@X)==(@Y) @end /* JScript comment 
        @echo off 

        cscript //E:JScript //nologo "%~f0" %* 
        ::pause
        exit /b %errorlevel% 

@if (@X)==(@Y) @end JScript comment */ 


var link=WScript.Arguments.Item(0);
var saveTo=WScript.Arguments.Item(1);


var IE = new ActiveXObject("InternetExplorer.Application"); 
IE.Visible=false;
IE.Navigate2(link);

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}

var counter=0;
while (IE.Busy && counter<60*60*10) {
    //WScript.Echo(IE.Busy);
    sleep(1000);
    counter++;
}

if(IE.Busy){
    WScript.Echo("Cant wait 4ever");
    WScript.Quit(10);
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

var innerText=IE.document.body.innerText;
IE.Quit();
writeContent(saveTo,innerText)
