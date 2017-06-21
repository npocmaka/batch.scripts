@if (@X)==(@Y) @end /*** Javascript comment
@echo off
rem :: a UI extension example for bat files
rem :: that not require enabled WSH as it uses mshta
rem :: As mshta allows JScript directives it is possible to 
rem :: to use the batch file as javascript source file
rem :: seen first here 
rem :: https://groups.google.com/forum/#!msg/alt.msdos.batch.nt/b8q29_uLfQs/4uoVLRo1uOsJ
rem ::
rem :: by Vasil "npocmaka" Arnaudov
rem ::


(
	mshta "about:<title>chooser</title><body onload='prepare()'><script language='javascript' src='file://%~dpnxf0'></script><span id='container'>buttons:</span></body>" 
)|(
	for /f "tokens=* delims=" %%B in ('more') do @(
		echo selected buton: %%B
	)
)
exit /b 0

**/

function clckd(a){
	var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
	close(fso.Write(a));
}

function prepare(){
	window.resizeTo(200,150);
	var element1 = document.createElement("input");
	element1.setAttribute("type", "button");
	element1.setAttribute("value", "yep");
	//this will not work on IE or MSHTA
	//   element1.setAttribute("onclick", "clckd('yep');");
	element1.onclick= function() {clckd('yep');};
	
	var element2 = document.createElement("input");
	element2.setAttribute("type", "button");
	element2.setAttribute("value", "nope");
	//this will not work on IE or MSHTA
	//   element2.setAttribute("onclick", "clckd('nope');");
	element2.onclick= function() {clckd('nope');};


	var container = document.getElementById('container');
	container.appendChild(element1);
	container.appendChild(element2);

	//alert(document.getElementById('container').innerHTML);	
}
