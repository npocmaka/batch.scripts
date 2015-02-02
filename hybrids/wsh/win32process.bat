
@echo off
cscript //nologo //job:win32process "%~f0?.wsf" "%~nx0" %*
exit /b %errorlevel%


<job id="win32process">
<script language="JScript">

	// strange but modulus cannot be executet in vbs part
	// and retruns error
	function modulus2(toCheck){
		return toCheck % 2;
	}
	function printHelp(scriptName){
		WScript.Echo("");
		WScript.Echo(scriptName + " command line wrapper of Win32_ProcessStartup ");
		WScript.Echo("Allows you to start process in different modes and styles")
		WScript.Echo("For more info execute:");
		WScript.Echo(scriptName +" -verboseHelp");
		WScript.Echo("");
		WScript.Echo("Usage:");
		WScript.Echo("");
		WScript.Echo(scriptName+" command [-option value ] [-option value] ...");
		WScript.Echo("");
		WScript.Echo("Options:");
		WScript.Echo("");
		WScript.Echo("-arguments command_arguments");
		WScript.Echo("");
		WScript.Echo("-directory directory_to_start_the_process");
		WScript.Echo("");
		WScript.Echo("-ErrorMode 1|2|4|8");
		WScript.Echo("");
		WScript.Echo("-CreateFlags 1|2|4|8|16|512|1024|67108864|16777216");
		WScript.Echo("");
		WScript.Echo("-EnvironmentVariables path_to_variables_file");
		WScript.Echo("        points to file with environment variables with format");
		WScript.Echo("        key=value  . lines starting with '=' are considered for comments");
		WScript.Echo("");
		WScript.Echo("-FillAttribute 1|2|4|8|16|32|64|128");
		WScript.Echo("");
		WScript.Echo("-PriorityClass 32|64|128|256|16384|32768");
		WScript.Echo("");
		WScript.Echo("-ShowWindow 0|1|2|3|4|5|6|7|8|9|10|11");
		WScript.Echo("");
		WScript.Echo("-Title title");
		WScript.Echo("");
		WScript.Echo("-WinstationDesktop winstationDesktop");
		WScript.Echo("");
		WScript.Echo("-X x -Y y");
		WScript.Echo("");
		WScript.Echo("-XCountChars xcount -YCountChars ycount");
		WScript.Echo("");
		WScript.Echo("-XSize xsize -YCountChars ysize");
		WScript.Echo("");
		WScript.Echo("-Verbose yes|no");
		WScript.Echo("      Verbose yes|no");
	}
	function printVerboseHelp(scriptName){
		printHelp(scriptName);
		fso = new ActiveXObject("Scripting.FileSystemObject");
		fileSream=fso.OpenTextFile(scriptName, 1);
		print=false;
		while ( fileSream.AtEndOfStream != true ) { 
            var str = fileSream.Readline();
			if(str == "##-->") {
				print = false;
			}
			if(print){
				WScript.Echo(str);
			}
			if(str == "<!--##") {
				print = true;
			}
         }
		
	}
	

	function loadEnvVars(fileName){
		fso = new ActiveXObject("Scripting.FileSystemObject");
		fileSream=fso.OpenTextFile(fileName, 1);
		var env_vars=[];
		while ( fileSream.AtEndOfStream != true ) { 
			var line = fileSream.Readline();
			if (! line.substring(0,1) == '"'){
				env_vars.push(line);
			}
		}
		return env_vars;
	}
</script>

<script language="VBScript">

	set ARGS = WScript.Arguments:
	scriptName=ARGS.Item(0):
	command=0:
	directory=".":
	verbose=false:
	
	set config=GetObject("winmgmts:").Get("Win32_ProcessStartup").SpawnInstance_:
	set process=GetObject("winmgmts:root\cimv2:Win32_Process"):
	
	X=-1:
	Y=-1:
	xCountChars=-1:
	yCountChars=-1:
	xSize=-1:
	ySize=-1:
	arg_mod=modulus2(ARGS.Length):
	
	function parseArgs()
		if LCase(ARGS.Item(1)) = "-help" then
			printHelp(scriptName):
			WScript.Quit(0):
		ElseIf ( LCase(ARGS.Item(1)) = "-verbosehelp" ) then
			printVerboseHelp(scriptName):
			WScript.Quit(0):
		ElseIf (  arg_mod <> 0 ) then
			WScript.Echo("invalid number of arguments"):
			WScript.Quit(4):
		end if:	
		command=ARGS.Item(1):
		for i=2 to  (ARGS.Length-1) step 2
			select case LCase(ARGS.Item(i)):
			case "-arguments":
				command=command&" "&ARGS.Item(i+1):
			case "-directory":
				directory=ARGS.Item(i+1):
			case "-variables_file":
				env_vars_location=ARGS.Item(i+1):
				config.EnvironmentVariables=loadEnvVars(ARGS.Item(i+1)):
			case "-verbose":
				if  LCase(ARGS.Item(i+1)) = "yes" then
					verbose=true:
				end if
			case "-errormode":
				config.ErrorMode= CLng(ARGS.Item(i+1)):
			case "-showwindow":
				config.showWindow=CLng(ARGS.Item(i+1)):
			case "-priorityclass":
				config.PriorityClass=CLng(ARGS.Item(i+1)):
			case "-title":
				config.Title=ARGS.Item(i+1):
			case "-fillattribute":
				config.FillAttribute=CLng(ARGS.Item(i+1)):
			case "-winstation":
				config.WinstationDesktop=ARGS.Item(i+1):
			case "-createflags":
				config.CreateFlags=CLng(ARGS.Item(i+1)):
			case "-x":
				X=CLng(ARGS.Item(i+1)):
			case "-y":
				Y=CLng(ARGS.Item(i+1)):
			case "-xcountchars":
				xCountChars=CLng(ARGS.Item(i+1)):
			case "-ycountchars":
				yCountChars=CLng(ARGS.Item(i+1)):
			case "-xsize":
				xSize=CLng(ARGS.Item(i+1)):
			case "-ysize":
				ySize=CLng(ARGS.Item(i+1)):
			case else:
				WScript.Echo("invalid argument " &  ARGS.Item(i)):
				WScript.Quit(1):
			end select:
		next
		
		if (X <> -1 and Y <> -1 ) then
			config.Y=Y:
			config.X=X:
		end if:
		If (xCountChars <> -1 and yCountChars ) then
			config.xCountChars=xCountChars:
			config.yCountChars=yCountChars:
		end if:
		If (xCountChars <> -1 and yCountChars ) then
			config.XCountChars=xCountChars:
			config.YCountChars=yCountChars:
		end if:
		If (xSize <> -1 and ySize ) then
			config.XSize=xSize:
			config.YSize=ySize:
		end if:	
	end function:
	
	parseArgs
	if verbose then
		WScript.Echo("Starting: " & command):
		WScript.Echo("Directory: " & directory):
		WScript.Echo("CreateFlags: " & config.CreateFlags):
		WScript.Echo("ErrorMore: " & config.ErrorMode):
		WScript.Echo("showWindow: " & config.showWindow):
		
		WScript.Echo("PriorityClass: " & config.PriorityClass):
		WScript.Echo("Title: " & config.Title):
		WScript.Echo("FillAttribute: " & config.FillAttribute):
		WScript.Echo("WinstationDesktop: " & config.WinstationDesktop):
		WScript.Echo("showWindow: " & config.showWindow):
		
		WScript.Echo("X: " & config.X):
		WScript.Echo("Y: " & config.Y):
		WScript.Echo("XCountChars: " & config.XCountChars):
		WScript.Echo("YCountChars: " & config.YCountChars):
		WScript.Echo("XSize: " & config.XSize):
		WScript.Echo("YSize: " & config.YSize):
	end if
	
	'pid = 0;
	errorCode=process.Create(command,directory,config,pid):
	
	if errorCode = 0 then 
		WScript.Echo("Started process: " & command):
		WScript.Echo("PID:" & pid):
	end if
	
	WScript.Echo("Return code: " & errorCode):
	if errorCode <> 0 then
		WScript.Echo("Error codes info:"):
		WScript.Echo("0-Successful Completion"):
		WScript.Echo("2-Access Denied"):
		WScript.Echo("3-Insufficient Privilege"):
		WScript.Echo("8-Unknown failure"):
		WScript.Echo("9-Path Not Found"):
		WScript.Echo("21-Invalid Parameter"):
	end if
</script>

</job>

<!--##

https://msdn.microsoft.com/en-us/library/aa394375(v=vs.85).aspx

CreateFlags
	Value -	Name - Meaning
	1 - Debug_Process  - If this flag is set, the calling process is treated as a debugger, and the new process is being debugged. The system notifies the debugger of all debug events that occur in the process being debugged.
	2 - Debug_Only_This_Process - If this flag is not set and the calling process is being debugged, the new process becomes another process being debugged. If the calling process is not a process of being debugged, no debugging-related actions occur.
	4 - Create_Suspended - The primary thread of the new process is created in a suspended state and does not run until the ResumeThread method is called.
	8 - Detached_Process - For console processes, the new process does not have access to the console of the parent process. This flag cannot be used if the Create_New_Console flag is set.
	16 - Create_New_Console - This new process has a new console, instead of inheriting the parent console. This flag cannot be used with the Detached_Process flag.
	512 - Create_New_Process_Group - This new process is the root process of a new process group. The process group includes all of the processes that are descendants of this root process. The process identifier of the new process group is the same as the process identifier that is returned in the ProcessID property of the Win32_Process class. Process groups are used by the GenerateConsoleCtrlEvent method to enable the sending of either a CTRL+C signal or a CTRL+BREAK signal to a group of console processes.
	1024 - Create_Unicode_Environment - The environment settings listed in the EnvironmentVariables property use Unicode characters. If this flag is not set, the environment block uses ANSI characters.
	67108864 - Create_Default_Error_Mode - Newly created processes are given the system default error mode of the calling process instead of inheriting the error mode of the parent process. This flag is useful for multithreaded shell applications that run with hard errors disabled.
	16777216 - CREATE_BREAKAWAY_FROM_JOB - Used for the created process not to be limited by the job object.
	 
EnvironmentVariables - List of settings for the configuration of a computer. Environment variables specify search paths for files, directories for temporary files, application-specific options, and other similar information. The system maintains a block of environment settings for each user and one for the computer. The system environment block represents environment variables for all of the users of a specific computer. A user's environment block represents the environment variables that the system maintains for a specific user, and includes the set of system environment variables. By default, each process receives a copy of the environment block for its parent process. Typically, this is the environment block for the user who is logged on. A process can specify different environment blocks for its child processes.
	On some non-x86 processors, misaligned memory references cause an alignment fault exception. The No_Alignment_Fault_Except flag lets you control whether or not an operating system automatically fixes such alignment faults, or makes them visible to an application. On a millions of instructions per second (MIPS) platform, an application must explicitly call SetErrorMode with the No_Alignment_Fault_Except flag to have the operating system automatically fix alignment faults.
	How an operating system processes several types of serious errors. You can specify that the operating system process errors, or an application can receive and process errors.
	The default setting is for the operating system to make alignment faults visible to an application. Because the x86 platform does not make alignment faults visible to an application, the No_Alignment_Fault_Except flag does not make the operating system raise an alignment fault error—even if the flag is not set. The default state for SetErrorMode is to set all of the flags to 0 (zero).

ErrorMode
	If this flag is set, the operating system does not display the critical error handler message box when such an error occurs. Instead, the operating system sends the error to the calling process.
	2 - No_Alignment_Fault_Except - If this flag is set, the operating system automatically fixes memory alignment faults and makes them invisible to the application. It does this for the calling and descendant processes. This flag applies to reduced instruction set computing (RISC) only, and has no effect on x86 processors.
	4 - No_GP_Fault_Error_Box - If this flag is set, the operating system does not display the general protection (GP) fault message box when a GP error occurs. This flag should only be set by debugging applications that handle GP errors.
	8 - No_Open_File_Error_Box - If this flag is set, the operating system does not display a message box when it fails to find a file. Instead, the error is returned to the calling process. This flag is currently ignored.
	 
FillAttribute
	The text and background colors if a new console window is created in a console application. These values are ignored in graphical user interface (GUI) applications. To specify both foreground and background colors, add the values together. For example, to have red type (4) on a blue background (16), set the FillAttribute to 20.
	Value - Meaning
	1 - Foreground_Blue
	2 - Foreground_Green
	4 - Foreground_Red
	8 - Foreground_Intensity
	16 - Background_Blue
	32 - Background_Green
	64 - Background_Red
	128 - Background_Intensity
 
PriorityClass
	Priority class of the new process. Use this property to determine the schedule priorities of the threads in the process. If the property is left null, the priority class defaults to Normal—unless the priority class of the creating process is Idle or Below_Normal. In these cases, the child process receives the default priority class of the calling process.
	Value -	Name - Meaning
	32 - Normal - Indicates a normal process with no special schedule needs.
	64 - Idle - Indicates a process with threads that run only when the system is idle and are preempted by the threads of any process running in a higher priority class. An example is a screen saver. The idle priority class is inherited by child processes.
	128 - High - Indicates a process that performs time-critical tasks that must be executed immediately to run correctly. The threads of a high-priority class process preempt the threads of normal-priority or idle-priority class processes. An example is Windows Task List, which must respond quickly when called by the user, regardless of the load on the operating system. Use extreme care when using the high-priority class, because a high-priority class CPU-bound application can use nearly all of the available cycles. Only a real-time priority preempts threads set to this level.
	256 - Realtime - Indicates a process that has the highest possible priority. The threads of a real-time priority class process preempt the threads of all other processes—including high-priority threads and operating system processes performing important tasks. For example, a real-time process that executes for more than a very brief interval can cause disk caches not to flush, or cause a mouse to be unresponsive.
	16384 - Below_Normal - Windows Server 2003:  Indicates a process that has a priority higher than Idle but lower than Normal.
	32768 - Above_Normal - Windows Server 2003:  Indicates a process that has a priority higher than Normal but lower than High.
	 
ShowWindow
	How the window is displayed to the user.
	Value -	Name - Meaning
	0 - SW_HIDE - Hides the window and activates another window.
	1 - SW_NORMAL - Activates and displays a window. If the window is minimized or maximized, the system restores it to the original size and position. An application specifies this flag when displaying the window for the first time.
	2 - SW_SHOWMINIMIZED - Activates the window, and displays it as a minimized window.
	3 - SW_SHOWMAXIMIZED - Activates the window, and displays it as a maximized window.
	4 - SW_SHOWNOACTIVATE - Displays a window in its most recent size and position. This value is similar to SW_NORMAL, except that the window is not activated.
	5 - SW_SHOW - Activates the window, and displays it at the current size and position.
	6 - SW_MINIMIZE - Minimizes the specified window, and activates the next top-level window in the Z order.
	7 - SW_SHOWMINNOACTIVE - Displays the window as a minimized window. This value is similar to SW_SHOWMINIMZED, except that the window is not activated.
	8 - SW_SHOWNA - Displays the window at the current size and position. This value is similar to SW_SHOW, except that the window is not activated.
	9 - SW_RESTORE - Activates and displays the window. If the window is minimized or maximized, the system restores it to the original size and position. An application specifies this flag when restoring a minimized window.
	10 - SW_SHOWDEFAULT - Sets the show state based on the SW_* value that is specified in the STARTUPINFO structure passed to the CreateProcess function by the program that starts the application.
	11 - SW_FORCEMINIMIZE - Windows Server 2003:  Minimizes a window, even when the thread that owns the window stops responding. Only use this flag when minimizing windows from a different thread.
	 
Title
	Text displayed in the title bar when a new console window is created; used for console processes. If NULL, the name of the executable file is used as the window title. This property must be NULL for GUI or console processes that do not create a new console window.

WinstationDesktop
	The name of the desktop or the name of both the desktop and window station for the process. A backslash in the string indicates that the string includes both desktop and window station names. If WinstationDesktop is NULL, the new process inherits the desktop and window station of its parent process. If WinstationDesktop is an empty string, the process does not inherit the desktop and window station of its parent process. The system determines if a new desktop and window station must be created. A window station is a secure object that contains a clipboard, a set of global atoms, and a group of desktop objects. The interactive window station that is assigned to the logon session of the interactive user also contains the keyboard, mouse, and display device. A desktop is a secure object contained within a window station. A desktop has a logical display surface and contains windows, menus, and hooks. A window station can have multiple desktops. Only the desktops of the interactive window station can be visible and receive user input.
	
X
	The X offset of the upper left corner of a window if a new window is created—in pixels. The offsets are from the upper left corner of the screen. For GUI processes, the specified position is used the first time the new process calls CreateWindow to create an overlapped window if the X parameter of CreateWindow is CW_USEDEFAULT.
	Note  X and Y cannot be specified independently.

XCountChars
	Screen buffer width in character columns. This property is used for processes that create a console window, and is ignored in GUI processes.
	Note  XCountChars and YCountChars cannot be specified independently.

XSize
	Pixel width of a window if a new window is created. For GUI processes, this is only used the first time the new process calls CreateWindow to create an overlapped window if the nWidth parameter of CreateWindow is CW_USEDEFAULT.
	Note  XSize and YSize cannot be specified independently.

Y
	Pixel offset of the upper-left corner of a window if a new window is created. The offsets are from the upper-left corner of the screen. For GUI processes, the specified position is used the first time the new process calls CreateWindow to create an overlapped window if the y parameter of CreateWindow is CW_USEDEFAULT.
	Note  X and Y cannot be specified independently.

YCountChars
	Screen buffer height in character rows. This property is used for processes that create a console window, but is ignored in GUI processes.
	Note  XCountChars and YCountChars cannot be specified independently.

YSize
	Pixel height of a window if a new window is created. For GUI processes, this is used only the first time the new process calls CreateWindow to create an overlapped window if the nWidth parameter of CreateWindow is CW_USEDEFAULT.
	Note  XSize and YSize cannot be specified independently.
##-->
