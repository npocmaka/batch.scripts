:: http://ss64.org/viewtopic.php?id=1554
:: redirecting to/from escaped EOF crashes the command prompt
:: as explained in dbenham in the above link
:: this was also featured here
:: http://stackoverflow.com/questions/23284131/cmd-exe-parsing-bug-leads-to-other-exploits

@echo off
rem do not set new lines at the end or you'll break the breaker
echo combobreaker |( goto :eof >^
