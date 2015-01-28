@Deprecated /* >nul 2>&1

:: self compiled java/.bat hybrid
::
:: deprecated is the only one annotation that can be used outside the class definition
:: and is needed for 'mute' start of multi-line java comment
:: that will be not printed by the batch file.
:: though it still creates two files - the .class and the .java
:: it still allows you to embed both batch and java code into one file

@echo off
setlocal
java -version >nul 2>&1 || (
	echo java not found
	exit /b 1
)

::find class name
::can be different than the script name
for /f "usebackq tokens=3 delims=} " %%c in (`type %~f0 ^|find /i "public class"^|findstr /v "for /f"`) do (
    set "javaFile=%%c"
    goto :skip
)
:skip

copy "%~f0" "%javaFile%.java" >nul 2>&1

javac "%javaFile%.java" 
java "%javaFile%"

::optional
::del %javaFile%.* >nul 2>&1 
endlocal
exit /b 0

*******/



public class TestClass
{
    public static void main(String args[])
    {
       System.out.println("selfcompiled .bat/.java hybrid");
    }
}
