@echo off
setlocal
   
   rem ::: check if help need to be called :::
   rem :
   
   for /f "usebackq tokens=1,2,3,4,5,6,7 delims= " %%A in ('-h -help /help /h "" /? -?') do (
      for %%# in (%%A %%B %%C %%D "%%~E" ) do if /i "%~1" equ "%%~#" goto :help
	  
      if "%~1" equ "%%~F" goto :help
      if "%~1" equ "%%~G" goto :help
   )

   rem :
   rem :::  end help checks                 :::
   
   
   rem ::: arg parsing and checking         :::
   rem :
   set /A shifter=1
   set "workdir=."
   set "commandline= "
   set "exec="
   
   
   :arg_parser
   
   
   if "%~1" equ "-exec" set "exec=%~2"
   if "%~1" equ "-commandline" set "commandline=%~2" 
   if "%~1" equ "-workdir" set "workdir=%~2"
   
   shift & shift
   set /A shifter=shifter + 1
   
   if %shifter% EQU 4 goto :end_arg_parser
   if "%~1" EQU "" goto :end_arg_parser
   goto :arg_parser
   
      
   :end_arg_parser
   rem :
   rem ::: end of arg parsing               :::
   
   rem ::: validate arguments               :::
   rem :
   
   set "exec_path="
   if not defined exec echo executable not defined && exit /b 1
   if exist "%exec%" for /f "usebackq" %%E in ("%exec%") do set "exec_path=%%~dpfsnxE"
   if not defined exec_path for %%E in ("%exec%") do set "exec_path=%%~dpfsnx$PATH:E"
   if not defined exec_path echo executable "%exec%" does not exist && exit /b 2
   for %%W in ("%workdir%") do set "workdir=%%~dpW"
   if not exist "%workdir%" echo target directory  "%workdir%" not exist && exit /b 3
   echo %commandline% | find """" >nul 2>&1 && ( echo command line contains quotes and you don't want this & exit /b 4)

   rem :
   rem ::: end of validation                :::
   
   rem ::: construct mshta command          :::
   rem :
   set "vbs_w32process=vbscript:execute("set w32ps=GetObject(""winmgmts:"").Get(""Win32_ProcessStartup"").SpawnInstance_():w32ps.ShowWindow=0:"
   set "vbs_stream_writer=CreateObject(""Scripting.FileSystemObject"").GetStandardStream(1).Write(""Rerurn code: ""&"
   set "vbs_start_process=GetObject(""winmgmts:"").Get(""Win32_Process"").Create(""%exec_path% %commandline%"",""%workdir%"",w32ps,pid)&vbCrLf&""PID: ""&pid)"
   set "vbs_end=:Close")"
   
   rem :
   rem ::: end construct mshta command      :::
   
   rem ::: call mshta                       :::
   rem :
   mshta %vbs_w32process%%vbs_stream_writer%%vbs_start_process%%vbs_end%| findstr "^"
   rem :
   rem ::: end  mshta call                   :::


endlocal
exit /b 0

:help
echo %~nx0 starts a background/invisible process and return its PID
echo %~nx0 -exec executable [-commandline commandLine] [-workdir workdir]
echo uses mshta/vbscript and does not require enabled WSH
echo by Vasil "npocmaka" Arnaudov
exit /b 0
