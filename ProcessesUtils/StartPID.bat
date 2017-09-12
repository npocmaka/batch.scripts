@echo off
setlocal
 
 
for %%# in ( "" "/h" "-h" "/help" "-help") do (
	if /i "%~1" equ "%%~#"  goto :echoHelp
)

 
set /A shifter=1
set "workdir=."
 
 
:argParser
        if /i "%~1" EQU "-exec" (
                set "exec=%~2"
        )
        if /i "%~1" EQU "-commandline" (
                set "commandline=%~2"
        )
        if /i "%~1" EQU "-workdir" (
                set "workdir=%~2"
        )
        if /i "%~1" EQU "-host" (
                set "host=%~2"
        )
        if /i "%~1" EQU "-user" (
                set "user=%~2"
        )
        if /i "%~1" EQU "-pass" (
                set "pass=%~2"
        )
        if /i "%~1" EQU "-record" (
                set "record=%~2"
        )
		
		if /i "%~1" EQU "-debug" (
                set "debug=%~2"
        )
		
        shift
        shift
        set /A shifter=%shifter% + 1
       
        if %shifter% EQU 8 ( 
            goto :endArgParser
        )
 
goto :argParser
:endArgParser
 
if "%exec%" EQU "" (
        echo executable not defined
        goto :eof
)
 
if "%host%" NEQ "" (
        set "host_param=/NODE:%host%"
        if "%user%" NEQ "" (
                set "user_param=/USER:%user%"
                if "%pass%" NEQ "" (
                        set "pass_param=/PASSWORD:%pass%"
                )
        )
)
 
if "%record%" NEQ "" (
        set "record_param=/RECORD:%record%"
)
 
set "global_params=%record_param% %host_param% %user_param% %pass_param%"
 
set "ProcessId="
set "ReturnValue="

if defined debug (
	echo executing:
	echo wmic %global_params%  process call create "%exec% %commandline%"^,"%workdir%"
)

for /f " skip=5 eol=} tokens=* delims=" %%a in ('wmic %global_params%  process call create "%exec% %commandline%"^,"%workdir%"') do (
    
	for /f "tokens=1,3 delims=;	 " %%c in ("%%a") do (
        set "%%c=%%d"
    )
)

 
::successfull
if defined ProcessId  (
    endlocal && ( 
		echo %ProcessId%
        exit /B %ProcessId% 
	)
)
 
::unsuccessful with code
::check the return code and give hints


if defined ReturnValue (
	echo error code : %ReturnValue%
	 
	if "%ReturnValue%" EQU "2" (
			echo -Access Denied
	)
	 
	if "%ReturnValue%" EQU "3" (
			echo -Insufficient Privilege
	)
	 
	if "%ReturnValue%" EQU "8" (
			echo -Unknown failure  
			echo Hint: Check if the executable and workdir exists or if command line parameters are correct.
	)
	 
	if "%ReturnValue%" EQU "9" (
			echo -Path Not Found
			echo Hint: check if  the workdir or executable exist.
	)
	 
	if "%ReturnValue%" EQU "21" (
			echo -Invalid Parameter
			echo Hint: Check executable path.Check if  host and user are corect.
	)
	
	endlocal && (
		exit /b 0
	)
)


 
::unsuccessful with no code
echo execution of the following line has failed:
echo wmic  %global_params%  process call create "%exec% %commandline%","%workdir%"
echo(
echo HINT :brackets,quotes or commas in the password  or the command line could break the script
goto :eof
 
endlocal
goto :eof
 
 
:echoHelp
       echo starts process on the local or a remote machine and returns it's PID to the ERRORLEVEL
       echo %~n0 -exec executubale [-commandline command_line] [ -workdir working_directory] [-host  remote_host [-user user [-pass password]]] [-record path_to_xml_output] [-debug debug]
       echo\
       echo localhost cant' be used as in -host variable
       echo Examples:
       echo %~n0  -exec "notepad" -workdir "c:/"  -record "test.xml" -commandline "/A startpid.txt"
       echo %~n0  -exec "cmd" -workdir "c:/"  -record "test.xml" -host remoteHost -user User
       echo\
 
goto :eof
