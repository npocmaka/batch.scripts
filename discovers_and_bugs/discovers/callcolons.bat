:: calling lables can be used like
:: call ::label arguments

@echo off

call ::label
echo -after-
exit /b o
:label
echo printed
