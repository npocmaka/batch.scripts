<!-- :
:: PasswordSubmitter.bat
@echo off
for /f "tokens=* delims=" %%p in ('mshta.exe "%~f0"') do (
	set "pass=%%p"
)

echo your password is %pass%
exit /b
-->

<html>
<head><title>Password submitter</title></head>
<body>

	<script language='javascript' >
		function pipePass() {
			var pass=document.getElementById('pass').value;
			var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
			close(fso.Write(pass));

		}
	</script>

	<input type='password' name='pass' size='15'></input>
	<hr>
	<button onclick='pipePass()'>Submit</button>

</body>
</html>
