@echo off
rem : ------------------------------
rem :
rem : sets java version as a number to jver
rem : variable in one line.
rem : by Vasil "npocmaka" Arnaudov
rem :
rem : ------------------------------
 
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"
 
rem : ------------------------------
rem : for execution directly to the command prompt use the line bellow
rem : for /f tokens^=2-5^ delims^=.-_^" %j in ('java -fullversion 2^>^&1') do @set "jver=%j%k%l%m"
rem : ------------------------------
