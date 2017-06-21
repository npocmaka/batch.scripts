<!-- :
:: PasswordSubmitter.bat
@echo off
setlocal EnableDelayedExpansion
for /f "tokens=* delims=" %%p in ('mshta.exe "%~f0"') do (
    set "pass=%%p"
)

echo your password is !pass!
exit /b
-->

<html>
<head><title>Password submitter</title></head>
<body>

    <script language='javascript' >
		window.resizeTo(300,150);
		function entperPressed(e){
			    if (e.keyCode == 13) {
					pipePass();
				}
		}
        function pipePass() {
            var pass=document.getElementById('pass').value;
            var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(fso.Write(pass));

        }
    </script>

    <input type='password' name='pass' size='15' onkeypress="return entperPressed(event)" ></input>
    <hr>
    <button onclick='pipePass()'>Submit</button>

</body>
</html>
