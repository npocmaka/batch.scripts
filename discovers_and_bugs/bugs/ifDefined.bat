:: Checking if variable that name contains spaces (or default delimiters - pointed by Liviu)
:: is not so easy
:: Escaping delimiters with ^ does not work and even its buggy
:: 
:: To perform proper checking you need delayed expansion
:: or FOR /F wrapping (proposed by penpen)
::
:: http://www.dostips.com/forum/viewtopic.php?f=3&t=6148
::
:: using delayed expansion

:: some explantations here : http://stackoverflow.com/questions/28000194/why-if-checking-ignores-delimtersome-word-after-the-check-expression

@echo off

setlocal enableDelayedExpansion

set sim salabim=magic
set sim=simulation

set "checker=sim salabim"

if defined !checker! echo #

rem the commented lines  produce errors
rem if defined sim salabim echo $
rem if defined %checker% echo @
rem if defined "sim salabim" echo *


endlocal


:: using FOR /F (penpen)

@echo off
setlocal disableDelayedExpansion
set sim salabim=magic

for %%a in ("sim salabim") do if defined %%~a echo ---
endlocal
goto :eof


:: If defined parser bug demonstration

@echo off

setlocal

   set "undefined1="
   set "undefined2="
   set "undefined3="

   set "var1=1"

   if defined var1^ undefined1^ undefined2^ undefined3 echo ###

endlocal
