:: http://ss64.org/viewtopic.php?id=1595
:: In find command searched string must be surrounded with quotes.
:: But if you want to search a string containing a quote you can escape it with another quote
:: Examples

@echo off
echo "12" | find """12"""
echo %errorlevel%
echo " 12"12 | find "2""1"
echo %errorlevel%
echo 12" "21 | find "2"" ""2"
echo %errorlevel%
