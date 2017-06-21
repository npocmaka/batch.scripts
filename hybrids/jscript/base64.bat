
@if (@X)==(@Y) @end /* JScript comment
	@echo off
	

	cscript //E:JScript //nologo "%~f0"  %*

	exit /b %errorlevel%
	
@if (@X)==(@Y) @end JScript comment */


var toCall=null;
var input=null;
var ev=false;

function parseArgs(){
	var args=WScript.Arguments;
	if(args.Length==0){
		printHelp();
		WScript.Quit(0);
	}
	
	var help = [
		"-h",
		"-help",
		"-?",
		"/h",
		"/help",
		"/?"	
	];
	
	for(var i=0;i<help.length;i++){
		if(args.Item(0).toLowerCase()==help[i]){
			printHelp();
			WScript.Quit(0);
		}
	}
	
	if(args.Length%2!=0){
		WScript.Echo("Wrong number of arguments");
		WScript.Quit(1);
	}
	
	for(var i=0;i<args.Length-1;i+=2){
		switch(args.Item(i).toLowerCase()){
			case "-decode":
				toCall=Base64.decode;
				input=args.Item(i+1);
				//return;
				break;
			case "-encode":
				toCall=Base64.encode;
				input=args.Item(i+1);
				//return;
				break;
			case "-eval":
				if(args.Item(i+1).toLowerCase()=="yes" || args.Item(i+1).toLowerCase()=="true"){
					ev=true;
				}
				break;
				
			default:
				WScript.Echo("Wrong argument: "+args.Item(i));
				WScript.Quit(2);
				break;
		}
	}
	
	if(toCall==null || input==null){
		WScript.Echo("Wrong arguments");
		WScript.Quit(1);
	}
	
}

//http://stackoverflow.com/a/24294348/388389

var jsEscapes = {
  'n': '\n',
  'r': '\r',
  't': '\t',
  'f': '\f',
  'v': '\v',
  'b': '\b'
};

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

function printHelp(){
	WScript.Echo(WScript.ScriptName + "  decodes or encodes base64 strings");
	WScript.Echo("");
	WScript.Echo("Usage:");
	WScript.Echo("");
	WScript.Echo(WScript.ScriptName + "{-decode|-encode} input [-eval {yes|no}]");
	WScript.Echo("	-eval - evaluate the special characters input");
	WScript.Echo("");
	WScript.Echo("Examples:");
	WScript.Echo("");
	WScript.Echo(WScript.ScriptName + " -encode \"\\u0022Hello\\u0022\" -eval yes " );
	WScript.Echo(WScript.ScriptName + " -decode \"SGVsbG8=\"");
}


//http://www.webtoolkit.info/javascript-base64.html#.WMpLPzuGOqk
var Base64 = {

// private property
_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

// public method for encoding
encode : function (input) {
    var output = "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;

    input = Base64._utf8_encode(input);

    while (i < input.length) {

        chr1 = input.charCodeAt(i++);
        chr2 = input.charCodeAt(i++);
        chr3 = input.charCodeAt(i++);

        enc1 = chr1 >> 2;
        enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
        enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
        enc4 = chr3 & 63;

        if (isNaN(chr2)) {
            enc3 = enc4 = 64;
        } else if (isNaN(chr3)) {
            enc4 = 64;
        }

        output = output +
        this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
        this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

    }

    return output;
},

// public method for decoding
decode : function (input) {
    var output = "";
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;

    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

    while (i < input.length) {

        enc1 = this._keyStr.indexOf(input.charAt(i++));
        enc2 = this._keyStr.indexOf(input.charAt(i++));
        enc3 = this._keyStr.indexOf(input.charAt(i++));
        enc4 = this._keyStr.indexOf(input.charAt(i++));

        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;

        output = output + String.fromCharCode(chr1);

        if (enc3 != 64) {
            output = output + String.fromCharCode(chr2);
        }
        if (enc4 != 64) {
            output = output + String.fromCharCode(chr3);
        }

    }

    output = Base64._utf8_decode(output);

    return output;

},

// private method for UTF-8 encoding
_utf8_encode : function (string) {
    string = string.replace(/\r\n/g,"\n");
    var utftext = "";

    for (var n = 0; n < string.length; n++) {

        var c = string.charCodeAt(n);

        if (c < 128) {
            utftext += String.fromCharCode(c);
        }
        else if((c > 127) && (c < 2048)) {
            utftext += String.fromCharCode((c >> 6) | 192);
            utftext += String.fromCharCode((c & 63) | 128);
        }
        else {
            utftext += String.fromCharCode((c >> 12) | 224);
            utftext += String.fromCharCode(((c >> 6) & 63) | 128);
            utftext += String.fromCharCode((c & 63) | 128);
        }

    }

    return utftext;
},

// private method for UTF-8 decoding
_utf8_decode : function (utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;

    while ( i < utftext.length ) {

        c = utftext.charCodeAt(i);

        if (c < 128) {
            string += String.fromCharCode(c);
            i++;
        }
        else if((c > 191) && (c < 224)) {
            c2 = utftext.charCodeAt(i+1);
            string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
            i += 2;
        }
        else {
            c2 = utftext.charCodeAt(i+1);
            c3 = utftext.charCodeAt(i+2);
            string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            i += 3;
        }

    }

    return string;
}

}

parseArgs();

if(ev && toCall==Base64.encode) {
	input=decodeJsString(input);
}
//Why this is not working?
//WScript.Echo(toCall(input));

if(toCall==Base64.encode){
	WScript.Echo(Base64.encode(input));
} else {
	WScript.Echo(Base64.decode(input));
}
