@echo off
:printclip
:: prints clipboard data
for /f "usebackq tokens=* delims=" %%i in (
   `mshta "javascript:Code(close(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(clipboardData.getData('Text'))));"`
) do (
	(echo(%%i)
)
exit /b %errorlevel%
