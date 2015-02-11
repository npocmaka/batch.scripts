@if (@X)==(@Y) @end /*JScript comment
@echo off

if "%~1" equ "" (
	echo usage:
	echo %~nx0 [radio_button_name [radio_button_name[..]]]
	exit /b 0
)

(
   echo %*
)|(
   mshta "about:<hta:application ShowInTaskbar=No Caption=no><title>radio</title><body onload='prepare()'><script language='javascript' src='file://%~dpnxf0'></script><span id='container'>Choose: <br></span></body>" 
)|(
  for /f "tokens=* delims=" %%R in ('more') do @(
    @(@echo(%%R)
   )
)

rem echo %result%
exit /b 0

**/

var argline;
var result;
var errmessage;
var elements = new Array();
var textnode;

function clckd(){
     // alert(a);
    var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);

   //fso.Write(line);
    //close(fso.Write(a));
   
   for (i = 0; i < elements.length; i++) {
      if (elements[i].checked ) {
         close(fso.Write(i+1));
         //alert(i+1);
      }
   }
   
}

function prepare(){
   
   try {
      var fso2= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
      argline=fso2.ReadLine();
      //alert(argline);
      //argline = "radio gaga radio gogo someone still loves you"
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
      temp_element.setAttribute("type", "radio");
      temp_element.setAttribute("name", "gaga");
      temp_element.setAttribute("value", i);
      temp_element.setAttribute("id", "gaga".concat(i));
      temp_element.value=args[i];
      elements.push(temp_element);   
   }
   
    for (i = 0; i < args.length; i++) {
      var br_element = document.createElement('br');;
      var container = document.getElementById('container');
       if (args[i] != "") {
		   textnode=document.createTextNode(args[i]);
		   container.appendChild(elements[i]);    
		   container.appendChild(textnode);
		   container.appendChild(br_element);
	   }
    }
   container.appendChild(br_element);
    var submit = document.createElement("input");
   
    submit.setAttribute("type", "button");
    submit.setAttribute("value", "submit");
    submit.onclick= function() {clckd();};
    container.appendChild(submit);

    //alert(document.getElementById('container').innerHTML);    
}
