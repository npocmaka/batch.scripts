::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF
set __COMPAT_LAYER=RunAsInvoker  
:: Export java settings from registry to a temporary file
START /W REGEDIT /E %Temp%\java.reg "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft" 


if not exist "%Temp%\java.reg" (
	START /W REGEDIT /E %Temp%\java.reg "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft"
)



if not exist "%Temp%\java.reg" (
	echo java not installed 
	exit /b 1
)
 

 
:: Find java location
FOR /F "tokens=1* delims==" %%A IN ('TYPE %Temp%\java.reg ^| FIND "INSTALLDIR"') DO SET JAVA_HOME=%%B
SET JAVA_HOME=%JAVA_HOME:"=%
SET JAVA_HOME=%JAVA_HOME:\\=\%
SET JAVA_HOME
 
:: Get java version
::FOR /F "tokens=1* delims==" %%A IN ('TYPE %Temp%\java.reg ^| FIND "CurrentVersion"') DO SET JAVA_VERSION=%%B
::SET JAVA_VERSION=%JAVA_VERSION:"=%
::SET JAVA_VERSION
::SET JAVA_VERSION=%JAVA_VERSION:.=%
::SET JAVA_VERSION=%JAVA_VERSION:_=%
::SET /A JAVA_VERSION=%JAVA_VERSION%

for /f tokens^=2-5^ delims^=.-_^" %%j in ('%JAVA_HOME%\bin\java.exe -fullversion 2^>^&1') do set "JAVA_VERSION=%%j%%k%%l%%m"
 
:: Delete temp file
rem @DEL %Temp%\java.reg /S /Q > NUL 2>&1
set JAVA_VERSION
:: Check java version compatibility
IF %JAVA_VERSION% LSS 16020 (
ECHO.
ECHO YOU NEED AT LEAST JAVA WITH VERSION 1.6.0_20 -- this is just an example echo.
GOTO :EOF
)
 
PAUSE
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
