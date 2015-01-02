@echo off
setlocal
 
if [%~1] EQU [] (
        call :echoHelp
        goto :eof
)
 
if [%~1] EQU [-help] (
        call :echoHelp
        goto :eof
)
 
set /A shifter=1
set workdir=.
 
 
:argParser
        if [%~1] EQU [-exec] (
                set exec=%~2
        )
        if [%~1] EQU [-commandline] (
                set commandline=%~2
        )
        if [%~1] EQU [-workdir] (
                set workdir=%~2
        )
        if [%~1] EQU [-host] (
                set host=%~2
        )
        if [%~1] EQU [-user] (
                set user=%~2
        )
        if [%~1] EQU [-pass] (
                set pass=%~2
        )
        if [%~1] EQU [-record] (
                set record=%~2
        )
        shift
        shift
        set /A shifter=%shifter% + 1
       
        if %shifter% EQU 7 (
               
                goto :endArgParser
        )
 
goto :argParser
:endArgParser
 
if "%exec%" EQU "" (
        echo executable not defined
        goto :eof
)
 
if "%host%" NEQ "" (
        set host_param=/NODE:%host%
        if [%user%] NEQ [] (
                set user_param=/USER:%user%
                if [%pass%] NEQ [] (
                        set pass_param=/PASSWORD:%pass%
                )
        )
)
 
if [%record%] NEQ [] (
        set record_param=/RECORD:%record%
)
 
set global_params=%record_param% %host_param% %user_param% %pass_param%
 
 call echo wmic  %global_params%  process call create "%exec% %commandline%"^,"%workdir%"
 
for /f "usebackq tokens=*" %%G IN (`wmic  %global_params%  process call create "%exec% %commandline%"^,"%workdir%"`)  do (
        echo %%G | find "ProcessId" >nul && (
                for /f  "tokens=2 delims=;= " %%H in ('echo %%G ^| find  "ProcessId"') do (
                        call set /A PID=%%H
                        goto :endLoop1
                )
        )
       
        echo %%G | find "ReturnValue" >nul && (
                for /f  "tokens=2 delims=;= " %%I in ('echo %%G ^| find  "ReturnValue"') do (
                        call set /A RETCOD=%%I
                        goto :endLoop2
                )
        )
       
        call :concat "%%G"    
)
goto :endloop3
 
::successful execution
:endLoop1
if %PID% NEQ 0 (
        echo %PID%
        exit /B %PID%
)
 
::unsuccessful with code
::check the return code and give hints
:endLoop2
 
echo return code : %RETCOD%
 
if %RETCOD% EQU 2 (
        echo -Access Denied
)
 
if %RETCOD% EQU 3 (
        echo -Insufficient Privilege
)
 
if %RETCOD% EQU 8 (
        echo -Unknown failure  
        echo Hint: Check if the executable and workdit exists or if command line parameters are correct.
)
 
if %RETCOD% EQU 9 (
        echo -Path Not Found
        echo Hint: check if  the work exists on the remote machine.
)
 
if %RETCOD% EQU 21 (
        echo -Invalid Parameter
        echo Hint: Check executable path.Check if  host and user are corect.
)
 
exit /b 0
goto :eof
 
::unsuccessful with no code
:endloop3
echo %output%
echo HINT :brackets,quotes or commas in the password  could break the script
goto :eof
 
endlocal
goto :eof
 
 
:echoHelp
        echo %~n0 -exec executubale [-commandline command_line] [ -workdir working_directory] [-host  remote_host [-user user [-pass password]]] [-record path_to_xml_output]
        echo\
        echo localhost cant' be used as in -host variable
       echo Examples:
       echo %~n0  -exec "notepad" -workdir "c:/"  -record "test.xml" -commandline "/A startpid.txt"
       echo %~n0  -exec "cmd" -workdir "c:/"  -record "test.xml" -host remoteHost -user User
       echo\
       echo by Vasil "npocmaka" Arnaudov
 
goto :eof
 
:concat
       call set output=%output% %1
 
goto :eof
