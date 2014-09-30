:: Type command accepts wildcards and file lists
:: Every time when a wildcard or a list of more than one 
:: file is used  it will print file names in StdErr 
:: even if a single file applies to the wildcard expression
:: or the file list
:: http://ss64.org/viewtopic.php?id=1794

@echo off
echo hello>lang.en
echo holla>lang.es
echo hallo>lang.de

echo --
echo -- testing type lang.??
echo --
type lang.??

echo --
echo -- testing type lang* 2^>nul
echo --
type lang* 2>nul

echo --
echo -- testing type lang* ^>nul
echo --
type lang?* >nul

echo --
echo -- testimg more lang*
echo --
more lang*

exit /b 0


:: the output is

--
-- testing type lang.??
--

lang.de


hallo

lang.en


hello

lang.es


holla
--
-- testing type lang* 2>nul
--
hallo
hello
holla
--
-- testing type lang* >nul
--

lang.de



lang.en



lang.es


--
-- testimg more lang*
--
hallo
hello
holla

