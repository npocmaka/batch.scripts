@echo off
setlocal enableDelayedExpansion

:: Binary tree implementation with pure batch
:: only insert and find methods are implmented so far
::
:: it uses the binary tree name as the variable that holds
:: the root element and adds revursively to namer right elements
:: and namel the left elements.

:::--- some tests -----
call ::insert test_tree6 1
call ::insert test_tree6 5
call ::insert test_tree6 8
call ::insert test_tree6 9999

color
echo searching for value 8
call ::find test_tree6 8
echo %errorlevel% - if 0 element is found
echo searching for value 123
call ::find test_tree6 123
echo %errorlevel% - if 1 element is not found
set test_tree6
::::::::::::::::::::::::::::::

exit /b 0


:find three_name value
setlocal enableDelayedExpansion
set /a value=%~2
set node=%1

if %value% equ !%1! (
   endlocal & (
      echo %1
      exit /b 0
   )
)


if %value% GTR !%1! (
   if defined %1r (
      endlocal & (
         call ::find %1r %value%
      )
   ) else (
      endlocal & exit /b 1
   )
)

if %value% LSS !%1! (
   if defined %1l (
      endlocal & (
         call ::find %1l %value%
      )
   ) else (
      endlocal & exit /b 1
   )
)


exit /b 



:insert three_name value
setlocal
::set "three_name=%~1"
set /a value=%~2

if not defined %~1 (
   endlocal & (
      set "%~1=%value%"
      exit /b 0
   )
)

if %value% GEQ %~1r (
 if not defined  %~1r (
   endlocal & (
      set %~1r=%value%
      exit /b 0
   )
  ) else (
   endlocal & (
      call ::insert %~1r %value%
      rem exit /b 0
   )
  )
)

if %value% LSS %~1l ( 
  if not defined  %~1l (
   endlocal & (
      set %~1l=%value%
      exit /b 0
   )
   ) else (
   endlocal & (
      call ::insert %~1r %value%
      rem exit /b 0
   )
   )
)

exit /b 0

:delete
