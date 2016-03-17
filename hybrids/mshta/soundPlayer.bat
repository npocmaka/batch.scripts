<!-- :
@echo off
(echo(%*)|mshta.exe "%~f0"|findstr "^"
exit /b
-->

<HTA:Application
   WindowsState=Minimize
   SysMenu=No
   ShowInTaskbar=no
   Caption=No
   Border=Thin
   ID="player"
>
<meta http-equiv="x-ua-compatible" content="ie=9" />

<html>
<bgsound src="" volume=''>
<body>




<script language="javascript" type="text/javascript">
window.visible=false;
window.resizeTo(0,0);

var output= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
var input= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
FSOObj = new ActiveXObject("Scripting.FileSystemObject");
var objShell=new ActiveXObject("Shell.Application");

var lenMagicNumber=27;
var volume=0;
var file='';
var seconds=0;
var start=0;

var arguments=input.ReadLine().trim();


function lenToSeconds(len){
	var hhmmss=len.split(":");
	return Number(hhmmss[0])*3600 + Number(hhmmss[1])*60 + Number(hhmmss[2]);
}

//fso
existsFile = function (path) {
	return FSOObj.FileExists(path);
}

getFullPath = function (path) {
    return FSOObj.GetAbsolutePathName(path);
}

//paths
getParent = function(path){
	var splitted=path.split("\\");
	var result="";
	for (var s=0;s<splitted.length-1;s++){
		if (s==0) {
			result=splitted[s];
		} else {
			result=result+"\\"+splitted[s];
		}
	}
	return result;
}


getName = function(path){
	var splitted=path.split("\\");
	return splitted[splitted.length-1];
}
//args
function parseArguments(args){
	if(args===""){
		var scriptPath=player.commandLine.split('"')[1];
		output.write('no arguments passed\n\r');
		output.write('usage:\n\r');
		output.write('\n\r');
		output.write(getName(scriptPath)+' "soundFile" [volume]\n\r');
		output.write('soundFile - path to sound file to play\n\r');
		output.write('volume - a number from -10000 to 0 that will set volume to the sound (0 is loudest and default value)\n\r');
		output.write('Example:\n\r');
		output.write('allplayer.bat "C:\Windows\Media\Ring05.wav" -1000\n\r');
		close();
	}
	
	//http://stackoverflow.com/a/24071183/388389
	var argarray=args.match(/"(?:\\"|\\\\|[^"])*"|\S+/g);
	if(argarray.length > 1) {
		volume=Number(argarray[1]);
	}
	
	file=argarray[0].replace (/"/g,'');	
}

function main(arguments){

	parseArguments(arguments);
	if(!existsFile(file)){
		output.write('file '+file+' does not exist\n\r');
		return;
	}	
	var fullFilename=getFullPath(file);
	var namespace=getParent(fullFilename);
	var name=getName(fullFilename);
	var objFolder=objShell.NameSpace(namespace);
	var objItem=objFolder.ParseName(name);
	var rawLen=objFolder.GetDetailsOf(objItem,lenMagicNumber);
	if(rawLen=="") {
		output.write('file '+file+' is not a media file\n\r');
		return;
	}
	
	seconds=lenToSeconds(rawLen);
	start = new Date().getTime();
	output.write('playing: '+fullFilename+' : '+rawLen+'\r\n');
	output.write('\r\n');
	//output.write(seconds+'\r\n')
	var bgsoundElems = document.getElementsByTagName('bgsound');
	bgsoundElems[0].src=fullFilename;
	bgsoundElems[0].volume=''+volume;
}

try {
    main(arguments);
}
catch(err) {
    output.write(err.message+'\r\n');
}


</script>

<script language="javascript" type="text/javascript">

window.setTimeout('close()', seconds*1000+600);

</script>
</body>
</html>
