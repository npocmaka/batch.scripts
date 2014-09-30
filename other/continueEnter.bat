:: continue only after enter is pressed
:: Unlike set /p= will not save the typed non-enter keys 
:: in the buffer
:: http://ss64.org/viewtopic.php?id=1695
runas /user:# "" >nul 2>&1
