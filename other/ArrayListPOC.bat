@echo off
rem ---- allows to call a subroutine inside FOR loop ----
rem ---- thanks to Aacini ----
rem --- by Vasil "npocmaka" Arnaudov
if /I "%1" equ "call" shift & shift & goto %2
 
rem ==============================
rem ==  checking paramateres    ==
rem ==============================
 
if "%1" equ "-?" (
        call :help
)
 
if "%1" equ "?" (
        call :help
)
 
if "%1" equ "/?" (
        call :help
)
 
if "%1" equ "h" (
        call :help
)
 
if "%1" equ "-h" (
        call :help
)
 
if "%1" equ "help" (
        call :help
)
 
if "%1" equ "-help" (
        call :help
)
 
if "%1" equ "" (
        call :help
)
 
if "%1" equ "remote_machine" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :remote_macine %2
        )
)
 
if "%1" equ "add" (    
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :add "%~2"
        )
)
 
if "%1" equ "getvalueat" (
        if "%~3" equ "" (
                call :help
                goto :eof
        ) else (
                call :getvalueat %2 %3
        )
)
 
if "%1" equ "length" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :length %2
        )
)
 
if "%1" equ "fast_list" (
        call :fast_list
)
 
if "%1" equ "list" (
        call :list
)
 
if "%1" equ "indexof" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :indexof %2
        )
)
 
if "%1" equ "lastindexof" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :lastindexof %2
        )
)
 
if "%1" equ "contains" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :contains %2
        )
)
 
if "%1" equ "pop" (
        call :pop
)
 
if "%1" equ "queue" (
        call :queue
)
 
if "%1" equ "deleteat" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :deleteat %2
        )
)
 
if "%1" equ "push" (
        if "%~2" equ "" (
                call :help
                goto :eof
        ) else (
                call :push %2
        )
)
 
if "%1" equ "insert" (
        if "%~3" equ "" (
                call :help
                goto :eof
        ) else (
                call :insert %2 %3
        )
)
 
if "%1" equ "isempty" (
        call :isempty
)
 
if "%1" equ "clear" (
        call :clear
)
 
if "%1" equ "clear" (
        call :clear
)
 
goto :eof
 
rem ================================
rem === subroutines definitions ====
rem ================================
 
rem --- if it is not set will be ignored ---
:remote_macine [%1 - the remote machine]
        set remote_machine=\\%~1
goto eof
 
:add [%1 - item to add]
setlocal
        for /f "tokens=1-2 delims==" %%J in ('at %remote_machine% 00:00 /every:31 "%~1"') do (
                echo added item %%K : %~1
                goto :endadd
        )
        :endadd
endlocal & goto :eof
 
 
:getvalueat [%1 - position of the item;%2 - variable to store value at]
setlocal
        set /a errorlevel=0
        set var=%2
   
        for /f "tokens=* delims= " %%E in ('at %remote_machine%  %1 ^| find "The AT job ID does not exist" ') do (
                if "%%E" NEQ "" (
                        echo IndexOutOfBoundException
                        goto :eof
                )
         )
       
       
        for /f "tokens=1,* delims=: " %%I in ('at %remote_machine%  %1 ^| find "Command:"') do (
                if "%%I" EQU "" (
                        echo IndexOutOfBoundException
                        goto :eof                      
                )
                set "variable=%%~J" >nul
        )
       
       
endlocal & call set  "%var%=%variable%"
goto :eof
 
:length [%1 - value to store length at ] - returns 0 on empty.
setlocal
        set var=%1
        set /a variable=0
        setlocal ENABLEDELAYEDEXPANSION
        for /f "eol=- tokens=1 delims= " %%L in ('at %remote_machine%  ^| find "Each"') do (
                set /a variable=!variable!+1
        )
        endlocal & set variable=%variable%
endlocal & call set /a "%var%=%variable%"
goto :eof
 
:fast_list - list elements and numbers
setlocal
  rem -- check if there's local time settings hour suffix
        for /f "tokens=1,2,3 delims= " %%T in ('date /t') do (
                if "%%V" EQU "" (
                        set /a last_column=5
                ) else (
                        set /a last_column=6
                )
        )
       
       
   if %last_column% EQU 5 (
                for /f "eol=- tokens=1-6,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                        echo %%A : %%~F
                )
        )
       
        if %last_column% EQU 6 (
                for /f "eol=- tokens=1-5,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                        echo %%A : %%~F
                )
        )
       
 
endlocal
goto :eof
 
:list - list elements and numbers
setlocal
        call :length len
        setlocal ENABLEDELAYEDEXPANSION
        for /l %%L in (1,1,!len!) do (
                call :getvalueat %%L val >nul
                echo %%L : !val!
        )
        endlocal
endlocal
goto :eof
 
 
 
:indexof [%1 - check if is contained] - echoes first index
setlocal
        rem -- check if there's local time settings hour suffix
       
        for /f "tokens=1,2,3 delims= " %%T in ('date /t') do (
                if "%%V" EQU "" (
                        set /a last_column=5
                ) else (
                        set /a last_column=6
                )
        )
        set /a index=-1
       
    if %last_column% EQU 5 (
                for /f "eol=- tokens=1-6,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                                        if "%%~F" EQU "%~1" (
                                                set /a index=%%A >nul
                                                goto :endcheck
                                        )
                )
        )
       
        if %last_column% EQU 6 (
                for /f "eol=- tokens=1-5,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                                        if "%%~F" EQU "%~1" (
                                                set /a index=%%A
                                                goto :endcheck
                                        )
                )
        )
       
        :endcheck
endlocal &  echo %index%
goto :eof
 
 
:lastindexof [%1 - check if is contained] - echoes last index
setlocal
        rem -- check if there's local time settings hour suffix
       
        for /f "tokens=1,2,3 delims= " %%T in ('date /t') do (
                if "%%V" EQU "" (
                        set /a last_column=5
                ) else (
                        set /a last_column=6
                )
        )
       
        set /a index=-1
       
   if %last_column% EQU 5 (
                for /f "eol=- tokens=1-6,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                                        if "%%~F" EQU "%~1" (
                                                set /a index=%%A >nul
                                        )
                )
        )
       
        if %last_column% EQU 6 (
                for /f "eol=- tokens=1-5,* delims= " %%A in ('at %remote_machine%  ^| find "Each"') do (
                                        if "%%~F" EQU "%~1" (
                                                set /a index=%%A
                                        )
                )
        )
       
        :endcheck
endlocal &  echo %index%
goto :eof
 
:contains [%1 - check if is contained] set errorlevel to -1 if is contained
setlocal
        set /a errorlevel=0
        set result=
        for /f "usebackq" %%C in (`%~f0 call :indexof %~1`) do (
                set result=%%C
        )
       
        if "%result%" NEQ "-1" (
                set /a errorlevel=1
        ) else (
                set /a errorlevel=0
        )
endlocal & set /a errorlevel=%errorlevel%
goto :eof
 
 
:pop - deletes and echoes the first element in the list
setlocal
               
        if "%1" EQU "" (
                call :length left
        ) else (
                set /a left=%1 > nul
        )
       
        if %left% equ 0 (
                call at %remote_machine%  /delete /yes
                goto :eof
        )
       
 
        call :getvalueat %left% current_element
        call :pop %left%-1
       
        rem :: get first element
        if %left% EQU 1 (
                echo %current_element%
                goto :eof
        )
 
        at %remote_machine%  00:00 /every:31 %current_element% >nul
       
endlocal
goto :eof
 
:queue - delete and return the last element in the list
setlocal
       
        if [%len%] EQU [] (
                call :length len
        )
       
        if "%len%" EQU "0" (
                goto :eof
        )
       
        if "%1" EQU "" (
                call :length left
        ) else (
                set /a left=%1 > nul
        )
        if %left% equ 0 (
                call at %remote_machine%  /delete /yes
                goto :eof
        )
       
        call :getvalueat %left% current_element
        call :queue %left%-1
 
        if %left% EQU %len% (
                echo %current_element%
                goto :eof
        )
 
        at %remote_machine%  00:00 /every:31 "%current_element%" >nul
       
endlocal
goto :eof
 
:deleteat [%1 - number of the element to be deleted] - returns the value of deleted element
setlocal
        set /a deleteat=%1
               
        if "%2" EQU "" (
                call :length left
        ) else (
                set /a left=%2 > nul
        )
        if %left% equ 0 (
                call at %remote_machine%  /delete /yes
                goto :eof
        )
               
        call :getvalueat %left% current_element
        call :deleteat %deleteat% %left%-1
       
        if %left% EQU %deleteat% (
                echo %current_element%
                goto :eof
        )
 
        at %remote_machine%  00:00 /every:31 "%current_element%" >nul
       
endlocal
goto :eof
 
:push [%1 - set this value on the first position]
setlocal
        set  "push=%~1"
               
        if "%2" EQU "" (
                call :length left
        ) else (
                set /a left=%2 > nul
        )
        if %left% equ 0 (
                at %remote_machine%  /delete /yes
                at %remote_machine% 00:00 /every:31 %push% >nul
                goto :eof
        )
       
        call :getvalueat %left% current_element
        call :push "%push%" %left%-1
       
        at %remote_machine%  00:00 /every:31 "%current_element%" >nul
       
endlocal
goto :eof
 
:insert [%1 - value to insert , %2 - position to insert ]
setlocal
        set  "insert=%~1"
        set  /a pos=%2
       
       
        if [%len%] EQU [] (
                call :length len
                setlocal enabledelayedexpansion
                if !pos! GTR !len! (
                        echo echo IndexOutOfBoundException
                        goto :eof
                )
                endlocal
        )      
       
       
        if "%3" EQU "" (
                call :length left
        ) else (
                set /a left=%3 > nul
        )
        if %left% equ 0 (
                at %remote_machine%  /delete /yes
                goto :eof
        )
       
        call :getvalueat %left% current_element
        call :insert "%insert%" %pos% %left%-1
       
        if %left% EQU %pos% (
                at %remote_machine%  00:00 /every:31 "%insert%" >nul
        )
       
        at %remote_machine%  00:00 /every:31 "%current_element%" >nul
       
endlocal
goto :eof
 
:clear - clears the list
        at %remote_machine% /delete /yes >nul
goto :eof
 
:isempty - checks if the list is empty
setlocal
        call :length len
        if "%len%" EQU "0" (
                echo YES
        ) else (
                echo NO
        )
endlocal
goto :eof
 
:size - echoes the length
setlocal
        call :length len
        echo %len%
endlocal
goto :eof
 
:help
echo %~n0  is a script that uses AT command for enumerated list.
echo you can have only one instance of this list - except if you're
echo not using remote host for storage (see remote_host key switch).
echo The list will be persisted on the system even after restart.
echo Following command swithes are slow are not recommended for often usage:
echo pop,queue,deleteat,push,insert - as they are using recursion and delete and
echo preset the values again (at does not reuse jobs ids even if the jobs are deleted ).
echo Use this script only on your own responsibility.For more info check commands bellow.
echo\
echo %~n0 ^| [-? ^|? ^|/? ^|-h ^|-help ^|help ^|h]  prints this message
echo    - prints this message
echo\
echo %~n0 add item   - adds an item to the list.Avoid following sympls
echo      as they are special symbols for cmd.exe :  ( , ), ^&, ^| , ^> , ^< , ^^ , %% , ^= , : , ~ .
echo\
echo %~n0 getvalueat position variable_name - gets the value
echo    at given possition and store the result to the variable name.
echo    If outflows the list prinst "indexOutOfBoundException".
echo\
echo %~n0 length variable_name - get the length and stores the result in variable_name.
echo     If list is empty sets 0.
echo\
echo %~n0 remote_macine machine_name - sets remote machine where the list is stored.
echo\
echo %~n0 fastlist - lists elements using internal AT command listing
echo      the elements will be not sorted by number but will run faster than list.
echo\
echo %~n0 list - lists all elements.
echo\
echo %~n0 indexof value - returns the possition of first appearance of the given value.
echo\
echo %~n0 lastindexof value - returns the possition of last appearance of given value.
echo\
echo %~n0 contains value - check if the given value is contained in the
echo      list.Set ERRORLEVEL to 1 if so.
echo\
echo %~n0 pop  - deletes the first element and echoes it's value.
echo\
echo %~n0 queue - deletes the last element and echoes it's value
echo\
echo %~n0 deleteat position  - deletes an element on given position
echo     and echoes it's value.
echo %~n0 push value - set an element on first possition with given value.
echo\
echo %~n0 insert value position - insert an element with the given position and value.
echo\
echo %~n0 clear - clears the list.
echo\
echo %~n0 size - echoes the size (length).
echo\
echo %~n0 isempty - checks if the list is empty .
echo\  
goto :eof
