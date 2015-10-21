@if (@X)==(@Y) @end /****** silent line that start jscript comment ******

@echo off
::::::::::::::::::::::::::::::::::::
:::       compile the script    ::::
::::::::::::::::::::::::::::::::::::
setlocal
if exist "%~n0.exe" goto :skip_compilation

setlocal

:: find csc.exe
set "jsc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*jsc.exe") do  set "jsc=%%#"

if not exist "%jsc%" (
   echo no .net framework installed
   exit /b 10
)

:break_loop


call %jsc% /nologo /out:"%~n0.exe" "%~f0"
::::::::::::::::::::::::::::::::::::
:::       end of compilation    ::::
::::::::::::::::::::::::::::::::::::
:skip_compilation



for %%# in (/h /help -h -help) do (
	if "%~1" equ "%%#" (
		(echo()
		echo %~nx0 - Displays LastModified,LastAccessed and DateCreated times of a given directory
		echo         in format YYYY-MM-DD hh:mm:ss , the thichs since 0:00:00 UTC on January 1, 0001 , day of the week
		(echo()
		echo example:
		echo call %~nx0 C:\file.ext
	)
)

if "%~1" equ "" (
	echo no directory passed
	exit /b 1
)

if not exist "%~f1" (
	echo directory "%~f1" does not exist
	exit /b 2
)

if exist "%~f1\"  if not exist "%~f1" (
	echo "%~f1" is a file but not a directory
	exit /b 3
)

(echo()
echo directory timestamps for %~f1 :
(echo()


"%~n0.exe" "%~f1"

exit /b 0


****** end of jscript comment ******/
import System;
import System.IO;

var arguments:String[] = Environment.GetCommandLineArgs();

function printDateInfo(timeTag,dt){
	Console.WriteLine( timeTag + " : " + dt.ToString("yyyy-MM-dd hh:mm:ss"));
	Console.WriteLine(timeTag + " thicks : " + dt.Ticks);
	Console.WriteLine( timeTag + " day of the week : " + dt.DayOfWeek);
	Console.WriteLine( timeTag + " day of the year : " + dt.DayOfYear);
	Console.WriteLine();
}

var modified_date= Directory.GetLastWriteTime(Environment.GetCommandLineArgs()[1]);
var creation_date= Directory.GetCreationTime(Environment.GetCommandLineArgs()[1]);
var accessed_date= Directory.GetLastAccessTime(Environment.GetCommandLineArgs()[1]);

printDateInfo("Modified",modified_date);
printDateInfo("Created",creation_date);
printDateInfo("Accessed",accessed_date);
