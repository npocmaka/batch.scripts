@echo off
setlocal
::Define a Linefeed variable
(set LF=^
%=-=%
)
  
for /f eol^=^%LF%%LF%^ delims^= %%A in (
   'forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x07"'
) do echo(%%A
