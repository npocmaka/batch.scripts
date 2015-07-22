// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal

:: find csc.exe
set "frm=%SystemRoot%\Microsoft.NET\Framework\"
for /f "tokens=* delims=" %%v in ('dir /b /a:d  /o:-n "%SystemRoot%\Microsoft.NET\Framework\v?.*"') do (
   set netver=%%v
   goto :break_loop
)
:break_loop
set csc=%frm%%netver%\csc.exe

if not exist "%~n0.exe" (
	%csc% /nologo /out:"%~n0.exe" "%~dpsfnx0" || (
		exit /b %errorlevel% 
	)
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/

// reference  
// https://gallery.technet.microsoft.com/scriptcenter/eeff544a-f690-4f6b-a586-11eea6fc5eb8

using System; 
using System.Runtime.InteropServices; 
using System.Drawing; 
using System.Drawing.Imaging; 

  /// Provides functions to capture the entire screen, or a particular window, and save it to a file. 

  public class ScreenCapture 
  { 

    /// Creates an Image object containing a screen shot the active window 

    public Image CaptureActiveWindow() 
    { 
      return CaptureWindow( User32.GetForegroundWindow() ); 
    } 

    /// Creates an Image object containing a screen shot of the entire desktop 

    public Image CaptureScreen() 
    { 
      return CaptureWindow( User32.GetDesktopWindow() ); 
    }     

    /// Creates an Image object containing a screen shot of a specific window 

    private Image CaptureWindow(IntPtr handle) 
    { 
      // get te hDC of the target window 
      IntPtr hdcSrc = User32.GetWindowDC(handle); 
      // get the size 
      User32.RECT windowRect = new User32.RECT(); 
      User32.GetWindowRect(handle,ref windowRect); 
      int width = windowRect.right - windowRect.left; 
      int height = windowRect.bottom - windowRect.top; 
      // create a device context we can copy to 
      IntPtr hdcDest = GDI32.CreateCompatibleDC(hdcSrc); 
      // create a bitmap we can copy it to, 
      // using GetDeviceCaps to get the width/height 
      IntPtr hBitmap = GDI32.CreateCompatibleBitmap(hdcSrc,width,height); 
      // select the bitmap object 
      IntPtr hOld = GDI32.SelectObject(hdcDest,hBitmap); 
      // bitblt over 
      GDI32.BitBlt(hdcDest,0,0,width,height,hdcSrc,0,0,GDI32.SRCCOPY); 
      // restore selection 
      GDI32.SelectObject(hdcDest,hOld); 
      // clean up 
      GDI32.DeleteDC(hdcDest); 
      User32.ReleaseDC(handle,hdcSrc); 
      // get a .NET image object for it 
      Image img = Image.FromHbitmap(hBitmap); 
      // free up the Bitmap object 
      GDI32.DeleteObject(hBitmap); 
      return img; 
    } 

    public void CaptureActiveWindowToFile(string filename, ImageFormat format) 
    { 
      Image img = CaptureActiveWindow(); 
      img.Save(filename,format); 
    } 

    public void CaptureScreenToFile(string filename, ImageFormat format) 
    { 
      Image img = CaptureScreen(); 
      img.Save(filename,format); 
    }
	
	static bool fullscreen=true;
	static String file="screenshot.bmp";
	static System.Drawing.Imaging.ImageFormat format=System.Drawing.Imaging.ImageFormat.Bmp;
	
	static void parseArguments()
	{
		String[] arguments = Environment.GetCommandLineArgs();
		if (arguments.Length == 1)
		{
			printHelp();
			Environment.Exit(0);
		}
		if (arguments[1].ToLower().Equals("/h") || arguments[1].ToLower().Equals("/help"))
		{
			printHelp();
			Environment.Exit(0);
		}
		
		file=arguments[1];
		
		if (arguments.Length > 2) 
		{
			switch(arguments[2].ToLower())
			{
				case "bmp":
					format=System.Drawing.Imaging.ImageFormat.Bmp;
					break;
				case "emf":
					format=System.Drawing.Imaging.ImageFormat.Emf;
					break;
				case "exif":
					format=System.Drawing.Imaging.ImageFormat.Exif;
					break;
				case "gif":
					format=System.Drawing.Imaging.ImageFormat.Gif;
					break;
				case "icon":
					format=System.Drawing.Imaging.ImageFormat.Icon;
					break;
				case "jpeg":
				case "jpg":
					format=System.Drawing.Imaging.ImageFormat.Jpeg;
					break;
				case "png":
					format=System.Drawing.Imaging.ImageFormat.Png;
					break;
				case "tiff":
					format=System.Drawing.Imaging.ImageFormat.Tiff;
					break;
				default:
					Console.WriteLine("invalid image format " + arguments[2]);
					Environment.Exit(5);
					break;
					
			}
		}
		
		if (arguments.Length > 3) 
		{
			switch(arguments[3].ToLower()){
				case "y":
					fullscreen=true;
					break;
				case "n":
					fullscreen=false;
					break;
				default:
					Console.WriteLine("invalid image mode " + arguments[3]);
					Environment.Exit(6);
					break;
			}
		}
		
	}
	
	static void  printHelp()
	{
		String scriptName=Environment.GetCommandLineArgs()[0];
		scriptName=scriptName.Substring (0,scriptName.Length);
		Console.WriteLine(scriptName + " captures the screen or the active window and saves it to a file");
		Console.WriteLine(scriptName + " filename [format] [Y|N]");
		Console.WriteLine("finename - the file where the screen capture will be saved");
		Console.WriteLine("format - Bmp,Emf,Exif,Gif,Icon,Jpeg,Png,Tiff and are supported - default is bmp");
		Console.WriteLine("Y|N - either or not the whole screen to be captured (if no only active window will be processed).Defalut is Y");
	}
	
	public static void Main()
	{
		parseArguments();
		ScreenCapture sc=new ScreenCapture();
		try
		{
			if (fullscreen){
				Console.WriteLine("Taking a capture of the whole screen to " + file + " as " + format);
				sc.CaptureScreenToFile(file,format);
			} else {
				Console.WriteLine("Taking a capture of the active window to " + file + " as " + format);
				sc.CaptureActiveWindowToFile(file,format);
			}
		} catch (Exception e) {
			Console.WriteLine("Check if file path is valid");
			Console.WriteLine(e.ToString());
		}
	}

    /// Helper class containing Gdi32 API functions 
 
    private class GDI32 
    { 
       
      public const int SRCCOPY = 0x00CC0020; // BitBlt dwRop parameter 
      [DllImport("gdi32.dll")] 
      public static extern bool BitBlt(IntPtr hObject,int nXDest,int nYDest, 
        int nWidth,int nHeight,IntPtr hObjectSource, 
        int nXSrc,int nYSrc,int dwRop); 
      [DllImport("gdi32.dll")] 
      public static extern IntPtr CreateCompatibleBitmap(IntPtr hDC,int nWidth, 
        int nHeight); 
      [DllImport("gdi32.dll")] 
      public static extern IntPtr CreateCompatibleDC(IntPtr hDC); 
      [DllImport("gdi32.dll")] 
      public static extern bool DeleteDC(IntPtr hDC); 
      [DllImport("gdi32.dll")] 
      public static extern bool DeleteObject(IntPtr hObject); 
      [DllImport("gdi32.dll")] 
      public static extern IntPtr SelectObject(IntPtr hDC,IntPtr hObject); 
    } 
 

    /// Helper class containing User32 API functions 

    private class User32 
    { 
      [StructLayout(LayoutKind.Sequential)] 
      public struct RECT 
      { 
        public int left; 
        public int top; 
        public int right; 
        public int bottom; 
      } 
      [DllImport("user32.dll")] 
      public static extern IntPtr GetDesktopWindow(); 
      [DllImport("user32.dll")] 
      public static extern IntPtr GetWindowDC(IntPtr hWnd); 
      [DllImport("user32.dll")] 
      public static extern IntPtr ReleaseDC(IntPtr hWnd,IntPtr hDC); 
      [DllImport("user32.dll")] 
      public static extern IntPtr GetWindowRect(IntPtr hWnd,ref RECT rect); 
      [DllImport("user32.dll")] 
      public static extern IntPtr GetForegroundWindow();       
    } 
  } 
