:pushd_counter
::http://ss64.org/viewtopic.php?id=1697
@echo off
set prompt_backup=%prompt%
prompt $+
( echo on
   for %%a in (1) do ( @rem
   )
)>%temp%\p.tmp
@echo off
prompt %prompt_backup%
set "prompt_backup="
for /f "usebackq tokens=1 delims=() " %%P in ("%temp%\p.tmp") do (
        set s=%%P
)
del %temp%\p.tmp  /q >nul
setlocal EnableDelayedExpansion
  set "s=#!s!"
  set "len=0"
  for %%A in (2187 729 243 81 27 9 3 1) do (
        set /A mod=2*%%A
        for %%Z in (!mod!) do (
                if "!s:~%%Z,1!" neq "" (
                        set /a "len+=%%Z"
                        set "s=!s:~%%Z!"
                       
                ) else (
                        if "!s:~%%A,1!" neq "" (
                                set /a "len+=%%A"
                                set "s=!s:~%%A!"
                        )
                )
        )
  )
endlocal &  echo %len%
set "s="
exit /b
