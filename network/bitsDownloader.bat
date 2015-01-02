   @echo off
    setlocal
    
    :: uses bitsadmin utility to download a file
    :: bitsadmin is not available in winXP Home edition
    :: the only way to download a file with 'pure' batch
   :download

    if "%2" equ "" (
      call :help
      exit /b 5
   )

   if "%1" equ "" (
      call :help
      exit /b 6
   )
    set url=%~1
    set file=%~2
    rem ----
    if "%~3" NEQ "" (
        set /A timeout=%~3
    ) else (
        set timeout=5
    )

    bitsadmin /cancel download >nul
    bitsadmin /create /download download >nul 
    call bitsadmin /addfile download "%url%" "%CD%\%file%" >nul
    bitsadmin /resume download >nul 
    bitsadmin /setproxysettings download AUTODETECT >nul

    set /a attempts=0
    :repeat
    set /a attempts +=1
    if "%attempts%" EQU "10" (
        echo TIMED OUT
        endlocal
        exit /b 1
    )
    bitsadmin /info download /verbose | find  "STATE: ERROR"  >nul 2>&1 && endlocal &&  bitsadmin /cancel download && echo SOME KIND OF ERROR && exit /b 2
    bitsadmin /info download /verbose | find  "STATE: SUSPENDED" >nul 2>&1 && endlocal &&  bitsadmin /cancel download &&echo FILE WAS NOT ADDED && exit /b 3
    bitsadmin /info download /verbose | find  "STATE: TRANSIENT_ERROR" >nul 2>&1 && endlocal &&  bitsadmin /cancel download &&echo TRANSIENT ERROR && exit /b 4
    bitsadmin /info download /verbose | find  "STATE: TRANSFERRED" >nul 2>&1 && goto :finishing 

   w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:%timeout%  >nul 2>&1
    goto :repeat
    :finishing 
    bitsadmin /complete download >nul
    echo download finished
    endlocal
   goto :eof

   :help
   echo %~n0 url file [timeout]
   echo.
   echo  url - the source for download
   echo  file - file name in local directory where the file will be stored
   echo  timeout - number in seconds between each check if download is complete (attempts are 10)
   echo.
   goto :eof
