@echo off 

:isInterer  input [returnVar] 
setlocal enableDelayedexpansion 
set "input=%~1" 

if "!input:~0,1!" equ "-" (
	set "input=!input:~1!"
) else (
	if "!input:~0,1!" equ "+" set "input=!input:~1!"
)

for %%# in (1 2 3 4 5 6 7 8 9 0) do ( 
        if not "!input!" == "" ( 
                set "input=!input:%%#=!" 
    )         
) 

if "!input!" equ "" ( 
        set result=true 
) else ( 
        set result=false 
) 

endlocal & if "%~2" neq "" (set %~2=%result%) else echo %result% 
