@echo off
goto :endComment
 Nothing useful , just observation over KEYS internal state and how it differs from ECHO.
 KEYS changes its state even if it's called within brackets or in conditional execution statements and to child threads/processes spawned with pipes or FOR (unlike ECHO):
 https://www.dostips.com/forum/viewtopic.php?t=6914#p45037
:endComment
setlocal disableDelayedExpansion

set "if_on=for /f "tokens=3" %%# in ('keys') do if %%#==on. "
set "if_off=for /f "tokens=3" %%# in ('keys') do if %%#==off. "

rem :: echo state cannot be examined so easy
::for /f "tokens=3" %%# in ('echo') do echo %%#
::echo|for /f "tokens=3" %%# in ('more') do echo %%#
::echo|find "on."
( 

   keys on
   %if_on% echo Should be displayed
   %if_off% echo Should be not
   keys off
   %if_off% echo Should be displayed
   %if_on% echo Should be not
   (
     keys on
   )
   %if_on% echo Should be displayed
   %if_off% echo Should be not

)
