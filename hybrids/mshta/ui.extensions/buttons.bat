@if (@X)==(@Y) @end /*JScript comment
@echo off
echo -- %~f0 --
if "%~1" equ "" (
	echo usage:
	echo %~nx0 [button_name [button_name[..]]]
	exit /b 0
)

(
   echo %*
)|(
   mshta "about:<hta:application ShowInTaskbar=No Caption=no><title>buttons</title><body onload='prepare()'><script language='javascript' src='file://%~dpnxf0'></script><span id='container'>Choose: <br></span></body>" 
)|(
  for /f "tokens=* delims=" %%R in ('more') do @(
    @(@echo(%%R)
   )
)

rem echo %result%
exit /b 0

**/

var argline;
var errmessage;
var elements = new Array();
var textnode;


function clckd(a){
    var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
	close(fso.Write(a));	
}

function prepare(){
	window.resizeTo(400,250);
   try {
      var fso2= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
      argline=fso2.ReadLine();
      var args=argline.split(" ");
   } catch (err) {
      errmessage = "cannot get the input";
      var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
      fso.Write(errmessage);
   }
   
   var br_element = document.createElement('br');;

   var i;
   var temp_element;   
    for (i = 0; i < args.length; i++) {
      temp_element =  document.createElement("input");
      temp_element.setAttribute("type", "button");
	  temp_element.setAttribute("value", args[i]);
	  temp_element.setAttribute("number", i+1);
	  temp_element.onclick= function(){clckd(this.number)};
      elements.push(temp_element);   
   }
   
    for (i = 0; i < args.length; i++) {
      var br_element = document.createElement('br');;
      var container = document.getElementById('container');
       if (args[i] != "") {
		   textnode=document.createTextNode(args[i]);
		   container.appendChild(elements[i]);    
		   container.appendChild(br_element);
	   }
    }
   container.appendChild(br_element);
}
