:: using SHIFT and accessing arguments within same brackets context
:: might cause troubles
::
:: following code with this arg. line ich ni san shi go roku
:: 
:: @echo off
:: for /l %%c in (1=1=5) do (
:: 	echo --%1--
:: 	shift
:: )
:: echo --%1--
::
:: gives following output
:: 
:: --ich--
:: --ni--
:: --san--
:: --shi--
:: --go--
:: --roku--
::
:: the only way to access arguments in this case is using CALL
:: http://ss64.org/viewtopic.php?id=1708

@echo off
for /l %%c in (1 ; 1 ; 5) do (
	call echo --%%1--
	shift
)
echo --%1--

::
:: with delayed expansion
::

setlocal enableDelayedExpansion
set /a counter=0
for /l %%x in (1 ; 1 ; 5) do (
 set /a counter=!counter!+1
 call echo %%!counter! 
)
endlocal
