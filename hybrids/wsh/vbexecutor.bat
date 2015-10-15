@echo off
set job=Execute
for %%# in (-h /h /help -help) do (
	if "%~1" equ "%%~#" (
		(echo()
		echo Executes vbscript statements
		(echo()
		echo Usage:
		echo  %~nx0 [function] statement [statement] 
		(echo()
		echo double quotes in ststements must be replaced with single quotes
		echo in ordred to avoid collision with command line arguments
		(echo()
		echo default function is /Execute
		echo other options are /Eval and /ExecuteGlobal
		(echo()
		echo examples:
		echo   call %~nx0 "Wscript.Echo('example')"  "WScript.Sleep(3000)"
		echo   call %~nx0 /Execute "Wscript.Echo('example')"  "WScript.Sleep(3000)"
		echo   call %~nx0 /ExecuteGlobal "Function SumTwo(a,b):SumTwo=a+b:End Function"  "WScript.Echo(SumTwo(2,2))"
		echo   call %~nx0 /Eval  "WScript.Echo(2+2)"
		exit /b 0
	)	
)

cscript /noLogo "%~f0?.WSF"  //job:execute  %*
exit /b %ErrorLevel%

   <job id="Execute">
      <script language="VBScript">
		funct="/execute"
		start=0:
		Function startsWith (str , prefix )
			startsWith = CBool (Left(str, Len(prefix)) = prefix )
		End Function
		
		check=LCase(WScript.Arguments.Item(0)):
		
		If startsWith(check,"/") then 
			start=1:
			select case check
				case "/execute"
				case "/executeglobal"
					funct="/executeglobal"
				case "/eval"
					funct="/eval"
				case else 
					Wscript.Echo("Invalid evaluation function " & check ):
					Wscript.Quit(1):
			end select
		end if
		
		For i=start to WScript.Arguments.Count-1
			select case funct
				case "/execute"
					Execute(Replace(WScript.Arguments.Item(i),"'","""")):
				case "/executeglobal"
					ExecuteGlobal(Replace(WScript.Arguments.Item(i),"'","""")):
				case "/eval"
					Eval(Replace(WScript.Arguments.Item(i),"'",""""))
			end select
			
		Next
      </script>
  </job>
