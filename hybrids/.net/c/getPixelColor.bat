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
   call %csc% /nologo /warn:0 /out:"%~n0.exe" "%~dpsfnx0" || (
      exit /b %errorlevel% 
   )
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/
  
  
  
  
  
  
  using System;
  using System.Drawing;
  using System.Runtime.InteropServices;

  public class Win32
  {
      [DllImport("user32.dll")]
      static extern IntPtr GetDC(IntPtr hwnd);

      [DllImport("user32.dll")]
      static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

      [DllImport("gdi32.dll")]
      static extern uint GetPixel(IntPtr hdc, int nXPos, int nYPos);

      static public System.Drawing.Color GetPixelColor(int x, int y)
      {
       IntPtr hdc = GetDC(IntPtr.Zero);
       uint pixel = GetPixel(hdc, x, y);
       ReleaseDC(IntPtr.Zero, hdc);
       Color color = Color.FromArgb((int)(pixel & 0x000000FF),
                    (int)(pixel & 0x0000FF00) >> 8,
                    (int)(pixel & 0x00FF0000) >> 16);
       return color;
      }
	  
	   public static void Main(string[] args)
	   {
		  int X= Int32.Parse(args[0]);
		  int Y=Int32.Parse(args[1]);
		  System.Console.WriteLine(GetPixelColor(X,Y));
	   }
   }
