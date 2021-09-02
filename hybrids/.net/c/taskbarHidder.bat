// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal

:: find csc.exe
set "csc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*csc.exe") do  set "csc=%%#"

if not exist "%csc%" (
   echo no .net framework installed
   exit /b 10
)

if not exist "%~n0.exe" (
   call %csc% /nologo /w:0 /out:"%~n0.exe" "%~dpsfnx0" || (
      exit /b %errorlevel% 
   )
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/

// Credit: https://stackoverflow.com/a/19024531/388389
using System;
using System.Runtime.InteropServices;

public class Taskbar
{
    [DllImport("user32.dll")]
    private static extern int FindWindow(string className, string windowText);
	
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    private static extern int ShowWindow(int hwnd, int command);

    [DllImport("user32.dll")]
    public static extern int FindWindowEx(int parentHandle, int childAfter, string className, int windowTitle);

    [DllImport("user32.dll")]
    private static extern int GetDesktopWindow();

    private const int SW_HIDE = 0;
    private const int SW_SHOW = 1;

    protected static int Handle
    {
        get
        {
            return FindWindow("Shell_TrayWnd", "");
        }
    }

    protected static int HandleOfStartButton
    {
        get
        {
            int handleOfDesktop = GetDesktopWindow();
            int handleOfStartButton = FindWindowEx(handleOfDesktop, 0, "button", 0);
            return handleOfStartButton;
        }
    }

    private Taskbar()
    {
        // hide ctor
    }

    public static void Show()
    {
        ShowWindow(Handle, SW_SHOW);
        ShowWindow(HandleOfStartButton, SW_SHOW);
    }

    public static void Hide()
    {
        ShowWindow(Handle, SW_HIDE);
        ShowWindow(HandleOfStartButton, SW_HIDE);
    }
	
	public static void GetStatus()
    {
		IntPtr xAsIntPtr = new IntPtr(Handle);
        Console.WriteLine("TaskBar visible : " + IsWindowVisible(xAsIntPtr));
		xAsIntPtr = new IntPtr(HandleOfStartButton);
        Console.WriteLine("StartButton visible : " + IsWindowVisible(xAsIntPtr));
    }
	
	static void printHelp()
    {
        //clears the extension from the script name
        String scriptName = Environment.GetCommandLineArgs()[0];
        scriptName = scriptName.Substring(0, scriptName.Length-4);
        Console.WriteLine(scriptName + " hides or shows the task bar");
        Console.WriteLine("");
        Console.WriteLine("Hide:");
        Console.WriteLine(" " + scriptName + "  1");
        Console.WriteLine("Show:");
        Console.WriteLine(" " + scriptName + "  2");
        Console.WriteLine("Get State:");
        Console.WriteLine(" " + scriptName + "  3");
    }
	
	static void Main(string[] args)
    {
        if (args.Length != 1) {
            printHelp();
            Environment.Exit(1);
        }
        if (args[0].ToLower() == "-h") {
            printHelp();
            Environment.Exit(0);
        }
        int sw;
        try
        {
            int mode;
            sw = int.Parse(args[0]);
            switch (sw) {
                case 1:
					//hide
                    Taskbar.Hide();
                    break;
                case 2:
				    //show
                    Taskbar.Show();
                    break;
                case 3:
				    // get state
					Taskbar.GetStatus();
                    break;
                default:
                    Console.WriteLine("Invalid argument: "+args[0]);
                    Environment.Exit(10);
                    break;
            }

        }
        catch (Exception e) {
            Console.WriteLine("Problem while parsing state " + args[0]);
            Environment.Exit(5);
        }

    }
}
