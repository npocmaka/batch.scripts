::http://ss64.org/viewtopic.php?id=1554

@echo on
:: this prints for %%A in ((nul)) do echo %%A
:: before command prompt crash
break | for %%A in () do echo %%A
