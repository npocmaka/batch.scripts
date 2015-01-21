::http://stackoverflow.com/questions/14762813/remove-leading-zeros-in-batch-file

:: exit /b number automatically removes leading zeroes and does not take the number as octal
:: also requires small piece of coding , but could affect the performance a little bit

:removeLeadingZeroes number [rtnVar]
setlocal 
  cmd /c exit /b %~1
endlocal && (
 if "%~2" neq "" (set %~2=%errorlevel%) else echo %errorlevel%
)
