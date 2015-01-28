   @echo off
   :: requires Admin permissions
   :: allows a files with .JAVA (in this case ) extension to act like .bat/.cmd files.
   :: Will create a 'caller.bat' asociated with the extension
   :: which will create a temp .bat file on each call (you can consider this as cheating)
   :: and will call it.
   :: Have on mind that the %0 argument will be lost.


    rem :: "installing" a caller.
    if not exist "c:\javaCaller.bat" (
       echo @echo off
       echo copy "%%~nx1"  "%%temp%%\%%~nx1.bat" /Y ^>nul
       echo "%%temp%%\%%~nx1.bat"  %%*
    ) > c:\javaCaller.bat

    rem :: associating file extension
    assoc .java=javafile
    ftype javafile=c:\javaCaller "%%1" %%*
