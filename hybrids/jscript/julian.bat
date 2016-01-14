@if (@X)==(@Y) @end /* JScript comment
    @echo off

    cscript //E:JScript //nologo "%~f0" 

    exit /b %errorlevel%
:: Calculates today's julian  date
:: julian date function stolen from here:
:: http://stackoverflow.com/a/11760121/388389
@if (@X)==(@Y) @end JScript comment */


Date.prototype.getJulian = function() {
    return Math.floor((this / 86400000) - (this.getTimezoneOffset()/1440) + 2440587.5);
}

var today = new Date(); //set any date
var julian = today.getJulian(); //get Julian counterpart
WScript.Echo(julian);
