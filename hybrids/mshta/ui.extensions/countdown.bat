<!-- :
:: countdown.bat
@echo off

if "%~1" equ "" (
  echo seconds not passed
  exit /b 1
)

echo %*|mshta.exe "%~f0"|more



exit /b %errorlevel%
-->

<html>
<head><title>It's the final countdown</title></head>
<body>

<p>Seconds left</p>
<div id="countdown">--</div>
<button onclick='quit()'>QUIT</button>
    <script language='javascript' type="text/javascript">
        function parse() {
               var seconds=0;
               try {
                  var fso2= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(0);
                  argline=fso2.ReadLine();
                  var args=argline.split(" ");
                  var seconds=parseInt(args[0]);
                  //var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
                  //fso.Write("wait for: " + milliseconds);
               } catch (err) {
                  errmessage = "cannot get the milliseconds";
                  var fso= new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
                  fso.Write(errmessage);
                  close();
               }
               seconds = document.getElementById('countdown').innerHTML=seconds;
               countdown();
        }

  var seconds;
  var temp;

  function countdown() {
    seconds = document.getElementById('countdown').innerHTML;
    seconds = parseInt(seconds, 10);

    if (seconds == 1) {
      temp = document.getElementById('countdown');
      close();
      return;
    }

    seconds--;
    temp = document.getElementById('countdown');
    temp.innerHTML = seconds;
    timeoutMyOswego = setTimeout(countdown, 1000);
  } 

  //countdown();
  window.resizeTo(400,250)
  parse();

        function quit() {
            close();
        }
        //itsTheFinalCountdown(10000);
    </script>
</body>

</html>
