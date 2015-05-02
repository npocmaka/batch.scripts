set "lev="
(@for /l  %%i in (1 1 33) do ( setlocal 2>nul && set lev=%%i ) && for /l %%o in (1 1 %lev% ) do ( endlocal & set  lev=%lev%))&(set /a lev=32-lev)
echo %lev%

:: http://ss64.org/viewtopic.php?id=1778
