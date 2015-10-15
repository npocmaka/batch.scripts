@echo off
for %%# in (-h /h /help -help) do (
   if "%~1" equ "%%~#" (
      (echo()
      echo Executes vbscript statements
      (echo()
      echo Usage:
      echo  %~nx0 statement [statement] 
      (echo()
      echo double quotes in ststements must be replaced with single quotes
      echo in ordred to avoid collision with command line arguments
      (echo()
      echo example:
      echo   call %~nx0 "Wscript.Echo('example')"  "WScript.Sleep(3000)"
      exit /b 0
   )   
)
cscript /noLogo "%~f0?.WSF"  //job:execute %*
exit /b %ErrorLevel%

   <job id="execute">
      <script language="VBScript">
      For i=0 to WScript.Arguments.Count-1
         Execute(Replace(WScript.Arguments.Item(i),"'","""")):
      Next
      </script>
  </job>
