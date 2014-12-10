:: http://www.dostips.com/forum/viewtopic.php?f=3&t=5539
::
:: when something is piped to IF command the spaces before first operand are eaten (check the link above)
:: While I've only found the problem - the root cause and the solution were found by jeb

 @echo off
    rem prints  1 is geq than 1
    echo.|if defined 1 geq 1 echo 1 is geq than 1
    rem prints 2 is gtr than 100
    echo.|if defined 2 gtr 100 echo 2 is gtr than 100
    
    rem prints 1 is gteater than 100
    echo.|if 1 gtr gtr 100 echo 1 is gteater than 100
    rem prints 100 is gteater and the same time less than 100
    echo.|if 100 lss gtr 100 echo 100 is gteater and the same time less than 100

:: the root cause is visible by executing the following line in command prompt (found by jeb):
::C:\>echo pipe | if defined X lss Y echo %^cmdcmdline%
:: In both cases - befora and after swalowing of the spaces syntax errors are detected (that's why the examples above works
::  - a second comparison operator is added)


:: the solution (proposed by jeb):


@echo off
set "myLine=if 1 lss 2 more"
echo pipe | ( %%myLine%%)

:: If command dows now swallow the pipe and passed string can be used both in IF and ELSE commands.
   


