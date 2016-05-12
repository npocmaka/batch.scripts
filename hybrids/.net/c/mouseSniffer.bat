// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal
::del "%~n0.exe" /q
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

using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.Threading;
//https://blogs.msdn.microsoft.com/toub/2006/05/03/low-level-mouse-hook-in-c/

namespace Purify
{
    class Program
    {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern IntPtr FindWindow(string strClassName, string strWindowName);
        [DllImport("user32.dll")]
        public static extern bool GetWindowRect(IntPtr hwnd, ref Rect rectangle);
        [DllImport("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, uint wParam, uint lParam);
        [DllImport("kernel32.dll")]
        static extern bool SetConsoleMode(IntPtr hConsoleHandle, int mode);
        [DllImport("kernel32.dll")]
        static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int mode);
        [DllImport("kernel32.dll")]
        static extern IntPtr GetStdHandle(int handle);
        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern IntPtr CreateToolhelp32Snapshot(uint dwFlags, uint th32ProcessID);
        [DllImport("kernel32.dll")]
        private static extern bool Process32First(IntPtr hSnapshot, ref PROCESSENTRY32 lppe);
        [DllImport("kernel32.dll")]
        private static extern bool Process32Next(IntPtr hSnapshot, ref PROCESSENTRY32 lppe);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr SetWindowsHookEx(int idHook,
    LowLevelMouseProc lpfn, IntPtr hMod, uint dwThreadId);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);
        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode,
            IntPtr wParam, IntPtr lParam);
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern IntPtr GetModuleHandle(string lpModuleName);

        public struct Rect
        {
            public int Left { get; set; }
            public int Top { get; set; }
            public int Right { get; set; }
            public int Bottom { get; set; }
        }

        public static Process ParentProcess(Process process)
        {
            int parentPid = 0;
            int processPid = process.Id;
            uint TH32CS_SNAPPROCESS = 2;

            // Take snapshot of processes
            IntPtr hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

            if (hSnapshot == IntPtr.Zero)
            {
                return null;
            }

            PROCESSENTRY32 procInfo = new PROCESSENTRY32();
            procInfo.dwSize = (uint)Marshal.SizeOf(typeof(PROCESSENTRY32));
            // Read first
            if (Process32First(hSnapshot, ref procInfo) == false)
            {
                return null;
            }
            // Loop through the snapshot
            do
            {
                // If it's me, then ask for my parent.
                if (processPid == procInfo.th32ProcessID)
                {
                    parentPid = (int)procInfo.th32ParentProcessID;
                }
            }
            while (parentPid == 0 && Process32Next(hSnapshot, ref procInfo)); // Read next

            if (parentPid > 0)
            {
                return Process.GetProcessById(parentPid);
            }
            else
            {
                return null;
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct PROCESSENTRY32
        {
            public uint dwSize;
            public uint cntUsage;
            public uint th32ProcessID;
            public IntPtr th32DefaultHeapID;
            public uint th32ModuleID;
            public uint cntThreads;
            public uint th32ParentProcessID;
            public int pcPriClassBase;
            public uint dwFlags;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
            public string szExeFile;
        }

        static int top = 0;
        static int bottom = 0;
        static int right = 0;
        static int left = 0;

        static void Main(string[] args)
        {
            disableQuickEdit();
            if (args.Length == 0) {
                printHelp();
                Environment.Exit(0);
            }

            if (args[0].ToLower() == "-h" || args[0].ToLower() == "-hlep")
            {
                printHelp();
                Environment.Exit(0);
            }

            int seconds = -1;
            try
            {
                seconds = int.Parse(args[0]);
            }
            catch (Exception e) {
                Console.WriteLine("Error while parsing number : "+args[0]);
                Environment.Exit(1);
            }

            if (seconds > -1)
            {
                Sleeper sl = new Sleeper(seconds*1000);
                Thread thr = new Thread(new ThreadStart(sl.sleep));
                thr.Start();
            }


            _hookID = SetHook(_proc);
            Application.Run();
            UnhookWindowsHookEx(_hookID);
            Console.ReadKey();
        }

        static void printHelp() {
            //clears the extension from the script name
            String scriptName = Environment.GetCommandLineArgs()[0];
            scriptName = scriptName.Substring(0, scriptName.Length - 4);

            Console.WriteLine(scriptName + " sniffs the mouse and prints the left click coordinates, time stamp and if the click was inside the console");
            Console.WriteLine("Usage:");
            Console.WriteLine("");
            Console.WriteLine(scriptName + " [seconds to watch]");
            Console.WriteLine("If seconds are -1 will watch forvever");
        }

        class Sleeper
        {
            int sleepMs = 0;
            public Sleeper(int ms)
            {
                sleepMs = ms;
            }
            public void sleep()
            {
                Thread.Sleep(this.sleepMs);
                Environment.Exit(0);
            }
        }
        static LowLevelMouseProc _proc = HookCallback;
        static IntPtr _hookID = IntPtr.Zero;
        static IntPtr SetHook(LowLevelMouseProc proc)
        {
            using (Process curProcess = Process.GetCurrentProcess())
            using (ProcessModule curModule = curProcess.MainModule)
            {
                return SetWindowsHookEx(WH_MOUSE_LL, proc,
                    GetModuleHandle(curModule.ModuleName), 0);
            }
        }
        delegate IntPtr LowLevelMouseProc(int nCode, IntPtr wParam, IntPtr lParam);
        private static IntPtr HookCallback(
            int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 &&
                MouseMessages.WM_LBUTTONDOWN == (MouseMessages)wParam)
            {
                MSLLHOOKSTRUCT hookStruct = (MSLLHOOKSTRUCT)Marshal.PtrToStructure(lParam, typeof(MSLLHOOKSTRUCT));
                bool inside = false;
                getProcRect();

                if (hookStruct.pt.x > left && hookStruct.pt.x < right &&
                    hookStruct.pt.y < bottom && hookStruct.pt.y > top)
                {

                    inside = true;
                }
                


                Console.WriteLine("Click on: "+hookStruct.pt.x + ", " + hookStruct.pt.y + ";Time: " + hookStruct.time + ";Inside console: " + inside);
            }
            return CallNextHookEx(_hookID, nCode, wParam, lParam);
        }

        private const int WH_MOUSE_LL = 14;
        private enum MouseMessages
        {
            WM_LBUTTONDOWN = 0x0201,
            WM_LBUTTONUP = 0x0202,
            WM_MOUSEMOVE = 0x0200,
            WM_MOUSEWHEEL = 0x020A,
            WM_RBUTTONDOWN = 0x0204,
            WM_RBUTTONUP = 0x0205
        }
        [StructLayout(LayoutKind.Sequential)]
        private struct POINT
        {
            public int x;
            public int y;
        }
        [StructLayout(LayoutKind.Sequential)]
        private struct MSLLHOOKSTRUCT
        {
            public POINT pt;
            public uint mouseData;
            public uint flags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public uint mouseData;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        static void disableQuickEdit()
        {
            int STD_INPUT_HANDLE = -10;
            int DISABLE_QUICK_EDIT_MODE = 0x0080;
            IntPtr handle = GetStdHandle(STD_INPUT_HANDLE);
            SetConsoleMode(handle, DISABLE_QUICK_EDIT_MODE);
        }

        static Rect getProcRect()
        {
            Process me = Process.GetCurrentProcess();
            //Rect dims = getProcRect(me);
            Process parent = ParentProcess(me);
            //Console.WriteLine(parent.ProcessName);
            IntPtr ptr = parent.MainWindowHandle;
            Rect rect = new Rect();
            GetWindowRect(ptr, ref rect);
            Console.WriteLine("Console window position:" +rect.Left + "-" + rect.Right + "-" + rect.Top + "-" + rect.Bottom);

            top = rect.Top;
            bottom = rect.Bottom;
            right = rect.Right;
            left = rect.Left;

            return rect;
        }
    }
}
