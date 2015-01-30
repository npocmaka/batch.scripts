@echo off
 
setlocal enableExtensions
rem :-----------------------------------------
rem : check if should prompt the help message
rem :-----------------------------------------
if "%~2" equ "" goto :help
for %%H in (/h -h /help -help) do (
    if /I "%~1" equ "%%H" goto :help
)
if not exist "%~1" echo file does not exist & exit /b 1
 
 
rem :-----------------------------------------
rem : validate input
rem :-----------------------------------------
set /a size=%~2
if not defined size echo something wrong with size parameter & exit /b 2
if %size%0 LSS 00 echo not a valid number passed as a parameter & exit /b 3
 
rem : -- two hex symbols and an empty space are 1 byte
rem : -- so the sum of all hex symbols
rem : -- per part should be doubled
set /a len=%size%*2
set "file=%~dfn1"
 
for %%F in ("%file%") do set fn=%%~nxF
 
rem : -- clear temp data
del /F /Q "%temp%\file" >nul 2>&1
del /F /Q  "%temp%\fn.p.*" >nul 2>&1
certutil -encodehex -f "%file%" "%temp%\file" >nul
set "part=1"
 
setlocal enableDelayedExpansion
        set "hex_str="
        set hex_len=0
        break>%temp%\fn.p.!part!
       
rem : -- reads the hex encoded file
rem : -- and make it on a parts that will
rem : -- decoded with certutil
 
rem :-- the delimitier is <tab> wich separates
rem :-- line number from the rest of the information
rem :-- in the hex file
rem :---------------------------- v <tab>
for /f "usebackq tokens=2 delims=	" %%A in ("%temp%\file") do (
		set "line=%%A"
        rem : -- there's a double space in the middle of the line
        rem :-- so here the line is get
        set hex_str=!hex_str!!line:~0,48!
		rem echo hex_str !hex_str!
        rem :-- empty spaces are cleared
        set hex_str=!hex_str: =!
        rem echo hex_str !hex_str! 
        rem :-- the length of the hex line 32
        set /a hex_len=hex_len+32
       
        rem : -- len/size is reached
        rem : -- and the content is printed to a hex file
        if !hex_len! GEQ !len! (
			echo  !hex_len! GEQ !len!
                set /a rest=hex_len-len
                for %%A in (!rest!) do (
                        (echo(!hex_str:~0,-%%A!)>>%temp%\fn.p.!part!
                        rem : -- the rest of the content of the line is saved
                        set hex_str=!hex_str:~-%%A!
                        set /a hex_len=rest
						echo !hex_len!
                )
                certutil -decodehex -f %temp%\fn.p.!part! %fn%.part.!part! >nul
                echo -- !part!th part created --
                rem :-- preprarin next hex file
                set /a part=part+1
                break>%temp%\fn.p.!part!
                rem :-- reinitilization of the len/size of the file part
                set /a len=%size%*2
        )
        rem : -- a buffer that not allows to
        rem : -- to enter too long commmands
        rem : -- used to reduce disk operations
        if !hex_len! GEQ 7800 (
                (echo(!hex_str!)>>%temp%\fn.p.!part!
                set "hex_str="
                set hex_len=0
                rem :-- the size that need to be reached is reduces
                rem :-- as there's alredy part of the part of the file
                rem :-- added to the hex file
        set /a len=!len!-7800
                if !len! LSS 0 set len=0
 
        )
 
)
rem : -- adding the rest of the file
echo !hex_str!>>%temp%\fn.p.!part!
certutil -decodehex -f %temp%\fn.p.!part! %fn%.part.!part! >nul
echo -- !part!th part created --
 
rem : -- clear created temp data
rem del /F /Q  %temp%\fn.p.* >nul 2>&1
rem del /F /Q  %temp%\file >nul 2>&1
endlocal
endlocal
 
goto :eof
rem :-----------------------------------------
rem : help message
rem :-----------------------------------------
 
:help
echo\
echo Splits a file on parts by given size in bytes in 'pure' batch.
echo\
echo\
echo    %0 file size
echo\
echo\
echo by Vasil "npocmaka" Arnaudov
