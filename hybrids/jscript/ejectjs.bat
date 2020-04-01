
@if (@X)==(@Y) @end /* JScript comment 
        @echo off        
        cscript //E:JScript //nologo "%~f0" %* 
		::pause
        exit /b %errorlevel%       
@if (@X)==(@Y) @end JScript comment */ 

function printHelp(){

	WScript.Echo( WScript.ScriptName + " - ejects a device");
	WScript.Echo(" ");
	WScript.Echo(WScript.ScriptName + " {LETTER|*}");
	WScript.Echo("  * will eject all ejectable drives");
}

if (WScript.Arguments.Length < 1 ) {
	printHelp();
	WScript.Quit(0);
}

if (WScript.Arguments.Item(0).length>1) {
	WScript.Echo("You need to pass an a drive letter or *");
	WScript.Quit(1);
}


var ShellObj=new ActiveXObject("Shell.Application");
var myComputer=ShellObj.NameSpace(17);//https://docs.microsoft.com/en-us/windows/win32/api/shldisp/ne-shldisp-shellspecialfolderconstants
var myComputerItems = myComputer.Items();

var usbType="USB Drive";
var cdType="CD Drive";

var usbVerbFB=6;
var cdVerbFB=4;

var toEject=WScript.Arguments.Item(0);


function callVerbFromBottom(item,indexFromBottom){
	var itemVerbs=item.Verbs();
	var verb=itemVerbs.Item(itemVerbs.Count-indexFromBottom);
	verb.DoIt();
	item.InvokeVerb(verb.Name.replace("&",""));
}

function ejectAll(){
	for (var i=0;i<myComputerItems.Count;i++){
		var item=myComputerItems.Item(i);
		var itemType=myComputer.GetDetailsOf(myComputerItems.Item(i),1);
		var itemName=myComputer.GetDetailsOf(myComputerItems.Item(i),0);

		if(itemType===usbType){
			callVerbFromBottom(item,usbVerbFB);
		}
		
		if(itemType===cdType){
			callVerbFromBottom(item,cdVerbFB);
		}	
	}
}

function ejectByLetter(letter) {
		var driveFound=false;
		for (var i=0;i<myComputerItems.Count;i++){
			var item=myComputerItems.Item(i);
			var itemType=myComputer.GetDetailsOf(myComputerItems.Item(i),1);
			var itemName=myComputer.GetDetailsOf(myComputerItems.Item(i),0);

			if(
				itemName.indexOf(":") !== -1 && 
				itemName.indexOf("(") !== -1 && 
				itemName.indexOf(")") !== -1
			) {
				//the item is a some kind of drive
				var itemDriveLetter=itemName.substring(
					itemName.indexOf(")") - 1 ,
					itemName.indexOf(")") - 2
				);

				if(itemDriveLetter.toUpperCase()===letter.toUpperCase()) {
					if(itemType===usbType) {
						callVerbFromBottom(item,usbVerbFB);
					} else if (itemType===cdType) {
						callVerbFromBottom(item,cdVerbFB);
					} else {
						WScript.Echo("Drive "+ letter + " does not support ejectuation");
						WScript.Quit(2);
					}
					driveFound=true;
					break; //drive letter has been found , no more iteration needed.
				}
			}
		}
		
		if(!driveFound){
			WScript.Echo("Drive " + letter +" has not been found");
			WScript.Quit(3);
		}
}

if(toEject==="*") {
	ejectAll();
} else {
	ejectByLetter(toEject);
}
