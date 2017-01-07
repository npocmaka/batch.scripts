<!-- :
    @echo off
	:: checks if a port on a remote server is open
        setlocal
		for %%h in (/h /help -help -h "") do (
			if /I "%~1" equ "%%~h" (
				goto :printHelp
			)
		)
		
		if "%~2" equ ""  goto :printHelp
		
		set "HOST=%~1"
		set /a PORT=%~2
		
        ::::::  Starting C# code :::::::
        :: searching for msbuild location
        for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*msbuild.exe") do  set "msb=%%#"

        if not defined  msb (
           echo no .net framework installed
           endlocal & exit /b 10
        )

        rem ::::::::::  calling msbuid :::::::::
        call %msb% /nologo /noconsolelogger  "%~dpsfnx0"
        rem ::::::::::::::::::::::::::::::::::::
        endlocal & exit /b %errorlevel%
		
		:printHelp
		echo Checks if port is open on a remote server
		echo(
		echo Usage:
		echo    %~nx0 host port
		echo(
		echo if port is not accessible will return errorlevel 1
		endlocal & exit /b 0
		
      
--> 


<Project ToolsVersion="$(MSBuildToolsVersion)" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <Target Name="_"><_/></Target>
  <UsingTask TaskName="_" TaskFactory="CodeTaskFactory" AssemblyFile="$(MSBuildToolsPath)\Microsoft.Build.Tasks.v$(MSBuildToolsVersion).dll" > 

    <Task>
      <Using Namespace="System" />
	  <Using Namespace="System.Net.Sockets" />
 
      <Code Type="Method" Language="cs"><![CDATA[

      public override bool Execute(){
			String host=Environment.GetEnvironmentVariable("HOST").ToLower();
			int port=Int32.Parse(Environment.GetEnvironmentVariable("PORT"));
			
			Console.WriteLine("Checking host {0} and port {1}",host,port);
			using(TcpClient client = new TcpClient()) {
			try {
				client.Connect(host, port);
			} catch(Exception) {
				Console.WriteLine("Closed");
				return false;
			}
			client.Close();
			Console.WriteLine("Open");
			return true;
		}	 	
      }
        ]]>
      </Code>
    </Task>
  </UsingTask>
</Project>
