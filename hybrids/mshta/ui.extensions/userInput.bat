<!-- :
:: PasswordSubmitter.bat
@echo off
setlocal EnableDelayedExpansion

if "%~1" equ "/?" (
	echo Creates an input value window and output
	echo   the result to console or assign it to variable
	echo   if variable name is passed
	(echo()
	echo Usage:
	(echo()
	echo %~0nx [storeInputTo]
)
for /f "tokens=* delims=" %%p in ('mshta.exe "%~f0"') do (
    set "input=%%p"
)


if "%~1" equ "" (
	echo %input%
	endlocal
) else (
	endlocal & (
		set "%~1=%input%"
	)
)
exit /b
-->

<html>
<head><title>User Input</title></head>
<body>

    <script language='javascript' >
		window.resizeTo(300,150);
		function entperPressed(e){
			    if (e.keyCode == 13) {
					pipePass();
				}
		}
        function pipePass() {
            var pass=document.getElementById('input').value;
            var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(fso.Write(pass));

        }
    </script>

    <input type="text" id="input" value="">
    <hr>
    <button onclick='pipePass()'>Submit</button>

</body>
</html>
