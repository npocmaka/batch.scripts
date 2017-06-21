// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal
rem del /q /f "%~n0.exe" >nul 2>nul
:: find csc.exe
set "csc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*csc.exe") do  set "csc=%%#"

if not exist "%csc%" (
   echo no .net framework installed
   exit /b 10
)

if not exist "%~n0.exe" (
   call %csc% /nologo /warn:0 /out:"%~n0.exe" "%~dpsfnx0" || (
      exit /b %errorlevel% 
   )
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/


using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Collections.Generic;

class HadlerWrapper {
 public System.IntPtr handler;

 public HadlerWrapper(System.IntPtr handler) {
  this.handler = handler;
 }
}

public class ScreenCapture {

 static Int32 mode = 1;
 static Dictionary < String, Int32 > modes = new Dictionary < String, Int32 > ();

 static String title = null;
 static Int32 pid = -1;





 [DllImport("user32.dll")]
 private static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);


 public static void Main(String[] args) {

  modes.Add("hidden", 0);
  modes.Add("normal", 1);
  modes.Add("minimized", 2);
  modes.Add("maximized", 3);
  modes.Add("force_minimized", 11);
  modes.Add("maximize_next", 6);
  modes.Add("restore", 9);
  modes.Add("show", 5);
  modes.Add("show_default", 10);
  modes.Add("no_active_minimized", 7);
  modes.Add("no_active_show", 8);
  modes.Add("no_active_normal", 4);


  parseArgs();

  if (!string.IsNullOrEmpty(title)) {
   HadlerWrapper hw = windowByString(title);
   if (hw != null) {
    ShowWindowAsync(hw.handler, mode);
   } else {
    Console.WriteLine("Cannot find a window with title [" + title + "]");
    Environment.Exit(6);
   }
  } else if (pid != -1) {
   HadlerWrapper hw = windowByPID(pid);
   if (hw != null) {
    ShowWindowAsync(hw.handler, mode);
   } else {
    Console.WriteLine("Cannot find a window with pid [" + pid + "]");
    Environment.Exit(7);
   }
  } else {
   Console.WriteLine("Neither process id not title were passed to the script");
   printHelp();
   Environment.Exit(8);
  }

 }

 static HadlerWrapper windowByString(String title) {
  Process[] processlist = Process.GetProcesses();
  foreach(Process process in processlist) {
   if (!String.IsNullOrEmpty(process.MainWindowTitle)) {
    if (process.MainWindowTitle.Equals(title)) {
     return new HadlerWrapper(process.MainWindowHandle);
    }
   }
  }

  foreach(Process process in processlist) {
   if (!String.IsNullOrEmpty(process.MainWindowTitle)) {
    if (process.MainWindowTitle.StartsWith(title)) {
     return new HadlerWrapper(process.MainWindowHandle);
    }
   }
  }

  return null;
 }

 static HadlerWrapper windowByPID(Int32 pid) {
  Process[] processlist = Process.GetProcesses();
  foreach(Process process in processlist) {
   if (!String.IsNullOrEmpty(process.MainWindowTitle)) {
    if (process.Id == pid) {
     return new HadlerWrapper(process.MainWindowHandle);
    }
   }
  }
  return null;
 }

 static void parseArgs() {

  String[] args = Environment.GetCommandLineArgs();
  if (args.Length == 1) {
   printHelp();
   Environment.Exit(0);
  }
  if (args.Length % 2 == 0) {
   Console.WriteLine("Wrong arguments");
   Environment.Exit(1);
  }
  for (int i = 1; i < args.Length - 1; i = i + 2) {

   switch (args[i].ToLower()) {
    case "-help":
    case "-h":
    case "/h":
    case "/help":
    case "/?":
     printHelp();
     Environment.Exit(5);
     break;
    case "-pid":
     if (int.TryParse(args[i + 1], out pid)) {} else {
      Console.WriteLine("Process id should be a number");
      Environment.Exit(2);
     }
     break;
    case "-title":
     title = args[i + 1];
     break;
    case "-mode":
     if (modes.TryGetValue(args[i + 1].ToLower(), out mode)) {} else {
      Console.WriteLine("Invalid mode passed: " + args[i + 1]);
      Environment.Exit(3);
     }
     break;
    default:
     Console.WriteLine("Wrong parameter " + args[i]);
     Environment.Exit(4);
     break;

   }
  }
 }

 public static void printHelp() {
  String script = Environment.GetCommandLineArgs()[0];
  Console.WriteLine(script + " - changed the mode of a window by given process id or window title");
  Console.WriteLine("");
  Console.WriteLine("Usage:");
  Console.WriteLine("");
  Console.WriteLine(script + " {[-title \"Title\"]|[-pid PID_Number]} [-mode mode]");
  Console.WriteLine("");
  Console.WriteLine("Possible modes are hidden,normal,minimized,maximized.");
  Console.WriteLine("If both title and pid are passed only the title will be taken into account");
  Console.WriteLine("If there's no title matching the given string a");
  Console.WriteLine("	title starting with it will be searched for");
  Console.WriteLine("");
  Console.WriteLine("Examples:");
  Console.WriteLine("");
  Console.WriteLine("	" + script + " -title \"Untitled - Notepad\" -mode normal");
  Console.WriteLine("	" + script + " -title \"Untitled\" -mode normal");
  Console.WriteLine("	" + script + " -pid 1313 -mode normal");

 }

}
