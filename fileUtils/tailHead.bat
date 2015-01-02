@echo off
setlocal
 
rem ---------------------------
rem ------ arg parsing --------
rem ---------------------------
 
    if "%~1" equ "" goto :help
        for %%H in (/h -h /help -help) do (
                if /I "%~1" equ "%%H" goto :help
        )
        setlocal enableDelayedExpansion
            set "prev="
            for %%A in (%*) do (
                    if /I "!prev!" equ "-file" set file=%%~fsA
                    if /I "!prev!" equ "-begin" set begin=%%~A
                    if /I "!prev!" equ "-end" set end=%%A
                    set prev=%%~A
            )
        endlocal & (
                if "%file%" neq "" (set file=%file%)
                if "%begin%" neq "" (set /a begin=%begin%)
                if "%end%" neq "" (set /a end=%end%)
        )
 
rem -----------------------------
rem --- invalid cases check -----
rem -----------------------------
       
        if "%file%" EQU "" echo file not defined && exit /b 1
        if not exist "%file%"  echo file not exists && exit /b 2
        if not defined begin if not defined end echo neither BEGIN line nor END line are defined && exit /b 3
       
rem --------------------------
rem -- function selection ----
rem --------------------------
       
        if defined begin if %begin%0 LSS 0 for /F %%C in ('find /c /v "" ^<"%file%"')  do set /a lines_count=%%C
        if defined end if %end%0 LSS 0 if not defined lines_count for /F %%C in ('find /c /v "" ^<"%file%"')  do set lines_count=%%C
               
                rem -- begin only
        if not defined begin if defined end if %end%0 GEQ 0 goto :end_only
        if not defined begin if defined end if %end%0 LSS 0 (
                        set /a end=%lines_count%%end%+1
                        goto :end_only
                )
               
                rem -- end only
        if not defined end if defined begin if %begin%0 GEQ 0 goto :begin_only
        if not defined end if defined begin if %begin%0 LSS 0 (
                        set /a begin=%lines_count%%begin%+1
                        goto :begin_only
                )
                rem -- begin and end
        if %begin%0 LSS 0 if %end%0 LSS 0 (
                        set /a begin=%lines_count%%begin%+1
                        set /a end=%lines_count%%end%+1
                        goto :begin_end
                )
        if %begin%0 LSS 0 if %end%0 GEQ 0 (
                        set /a begin=%lines_count%%begin%+1
                        goto :begin_end
                )
        if %begin%0 GEQ 0 if %end%0 LSS 0 (
                        set /a end=%lines_count%%end%+1
                        goto :begin_end
                )
        if %begin%0 GEQ 0 if %end%0 GEQ 0 (
                        goto :begin_end
                )      
goto :eof
 
rem -------------------------
rem ------ functions --------
rem -------------------------
 
rem -----  single cases -----
 
:begin_only
        setlocal DisableDelayedExpansion
        for /F "delims=" %%L in ('findstr /R /N "^" "%file%"') do (
                set "line=%%L"
                for /F "delims=:" %%n in ("%%L") do (
                        if %%n GEQ %begin% (
                                setlocal EnableDelayedExpansion
                                set "text=!line:*:=!"
                                (echo(!text!)
                                endlocal
                        )
                )
        )
        endlocal
endlocal
goto :eof
 
:end_only
        setlocal disableDelayedExpansion
        for /F "delims=" %%L in ('findstr /R /N "^" "%file%"') do (
                set "line=%%L"
                for /F "delims=:" %%n in ("%%L") do (
                        IF %%n LEQ %end% (
                                setlocal EnableDelayedExpansion
                                set "text=!line:*:=!"
                                (echo(!text!)
                                endlocal
                        ) ELSE goto :break_eo
                )
        )
        :break_eo
        endlocal
endlocal
goto :eof
 
rem ---  end and begin case  -----
 
:begin_end
        setlocal disableDelayedExpansion
        if %begin% GTR %end% goto :break_be
        for /F "delims=" %%L in ('findstr /R /N "^" "%file%"') do (
                set "line=%%L"
                for /F "delims=:" %%n in ("%%L") do (
                    IF %%n GEQ %begin% IF %%n LEQ %end% (        
                        setlocal EnableDelayedExpansion
                        set "text=!line:*:=!"
                       (echo(!text!)
                        endlocal
                    ) ELSE goto :break_be                              
                )
        )
        :break_be
        endlocal
endlocal
goto :eof
rem ------------------
rem --- HELP ---------
rem ------------------
:help
    echo(
        echo %~n0 - dipsplays a lines of a file defined by -BEGIN and -END arguments passed to it
        echo(
        echo( USAGE:
        echo(
        echo %~n0  -file=file_to_process {-begin=begin_line ^| -end=end_line }
        echo or
        echo %~n0  -file file_to_process {-begin begin_line ^| -end end_line }
        echo(
        echo( if some of arguments BEGIN or END has a negative number it will start to count from the end of file
        echo(
        echo( http://ss64.org/viewtopic.php^?id^=1707
        echo(
        echo( by Vasil "npocmaka" Arnaudov
goto :eof
