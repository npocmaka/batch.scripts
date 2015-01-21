@echo off
rem gets Date Parts
rem by Vasil "npocmaka" Arnaudov
rem 21.01.15 - improvement was proposed by Ildar Shaimordanov - a.k.a siberia-man
rem - to use empty folder to increase performance
for /f "skip=10 tokens=2,3,4,5,6,7,8 delims=:    " %%D in ('
 robocopy /l * "%windir%\System32\wbem\MOF\bad" "%windir%\System32\wbem\MOF\bad" /ns /nc /ndl /nfl /np /njh /XF * /XD * 
') do (
 set "dow=%%D"
 set "month=%%E"
 set "day=%%F"
 set "HH=%%G"
 set "MM=%%H"
 set "SS=%%I"
 set "year=%%J"
)
 
echo Day of the week: %dow%
echo Day of the month : %day%
echo Month : %month%
echo hour : %HH%
echo minutes : %MM%
echo seconds : %SS%
echo year : %year%
