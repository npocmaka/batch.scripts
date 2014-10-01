@if (@X)==(@Y) @end /* JScript comment
@echo off

:: FolderSelectorJS.bat
setlocal

for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\*jsc.exe"') do (
   set "jsc=%%v"
)

if not exist "%~n0.exe" (
    "%jsc%" /nologo /out:"%~n0.exe" "%~dpsfnx0"
)

for /f "tokens=* delims=" %%p in ('"%~n0.exe"') do (
    set "folder=%%p"
)
if not "%folder%" == "" ( 
    echo selected folder  is %folder%
)

endlocal & exit /b %errorlevel%

*/

import System;
import System.Windows.Forms;

var  f=new FolderBrowserDialog();
f.SelectedPath=System.Environment.CurrentDirectory;
f.Description="Please choose a folder.";
f.ShowNewFolderButton=true;
if( f.ShowDialog() == DialogResult.OK ){
    Console.Write(f.SelectedPath);
}
