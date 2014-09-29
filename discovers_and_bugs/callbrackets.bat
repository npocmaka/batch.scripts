::http://stackoverflow.com/questions/24418084/why-call-command-cannot-execute-a-command-enclosed-with-brackets
:: 
:: Call command is unable to execute expression enclosed in brackets
:: Examples bellow
::
::

@echo off

:: the echo that will never be
call(echo echo echo)

:: its the same with non-cmd internal commands
call ( notepad.exe )

:: and even with a code that should fail
call(gibberish)

:: moreover the execution is successful
call (gibberish)&&echo %errorlevel%

:: though there's some parsing done
call(this will print call help because contains "/?"-/?)

:: and will detect a wrong syntax of some parsed-before-execution commands
call ( if a==)

:: and this too
call (%~)

:: same with labels
call(:label)
call(:no_label)
:label
