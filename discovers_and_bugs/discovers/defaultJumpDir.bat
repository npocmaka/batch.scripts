:: For every drive there's dynamic environment variable
:: that points to the last accessed directory e.g. :
::
:: =D:=D:\someFolder
::
:: defining same variable in-advance will 
:: allow direct jump to some directory by entering the drive
:: (if directory does not exist it will print it as a message)
:: This will not harm the command prompt.
:: If different folder is entered the value of the variable will be changed durring the 
:: command prompt session.
::
::http://ss64.org/viewtopic.php?id=1559
::


reg add HKCU\Environment /v "=D:" /d "Get out of here stalker" /f

:: SETX won't allow defining variable starting with equal sign on every machine.So it's better to use REG
