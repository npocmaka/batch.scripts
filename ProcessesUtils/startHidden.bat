@echo off
:: Starts a hidden process and tries and gets its PID on 
:: a machines with OS higher than Vista
:: requires Admin permissions

:: it uses SCHTASKS with a task 'on demand'
:: PID is get from the event logs with WEVTUTIL command

:: todo - start the process on a remote machine
:: todo - start the process with a different user
:: todo - start the process in different mode

setlocal
:: check for elevated permissions
fltmc 1>nul 2>&1 || (
	echo you need an admin permissions
	exit /b 5
) 
if "%1" EQU "" (
	echo %~nx0 path_to_executable [arguments]
	exit /b 1
)
 
if "%1" EQU "-help" (
	echo %~nx0 path_to_executable [arguments]
	exit /b 0
)

set "arguments="
if "%2" NEQ "" (
	set "arguments=%2"
)

::escape quotes if there are any
if defined arguments (
    set "arguments=%arguments:"=\"%"
)


set "executable=%~s1"
set "inpath=%~dp$PATH:1"

:: check if executable exists.Both with its value and within %PATH% variable
if not exist "%executable%" (
	if "%inpath%" equ "" (
		echo path to executable item does not exist
		exit /B 2		
	) else (
 	 	for %%f in ("%~dp$PATH:1%~1") do set "executable='%%~sf'" 
	)
)

:: getting the current time
:: if the machine has SCHTASKS it has also WMIC
FOR /F "skip=1 tokens=1-3" %%A IN ('WMIC Path Win32_LocalTime Get Hour^,Minute^,Second /Format:value') DO (
	for /f "delims=" %%# in ("%%A") do if "%%#" NEQ "" set "%%A"
)
  
set  time_stamp=%Hour%%Minute%%Second%


if "%time_stamp%" equ "" (
	echo "some kind of error"
	exit /B 2
)

::exit /b
:: A trick that will create a task on demand but will log a warning
SCHTASKS /Create /sc ONCE /sd 01/01/1910 /st 00:00 /TN created_%time_stamp%  /TR "%executable% %arguments%"   /RU SYSTEM /F /RL HIGHEST 1>nul 2>&1 || (
	echo Error while creating the task
	exit /b 3
)
::w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:2  >nul 2>&1
SCHTASKS /Run /TN created_%time_stamp% 1>nul 2>&1 || (
	echo Error while starting the task
	exit /b 4
)
SCHTASKS /Delete /TN created_%time_stamp% /f  1>nul 2>&1 || (
    echo Error deleting  the task
)
:: Attempt to acquire the PID of the started process trough task scheduler event logs
:: not possible for WinXP/2003 but there task scheduler logs are located elsewhere
:: so this check will stop execution for older machines

if exist "%__APPDIR__%winevt\Logs\" (
	setlocal enableDelayedExpansion
    echo ----
	rem sleep for 2 seconds to give a time for event logging
	w32tm /stripchart /computer:localhost /period:1 /dataonly /samples:2  >nul 2>&1
	rem WEVTUTIL should be available from Vista and above
	for /f "usebackq tokens=13 delims==" %%# in (
		`"wevtutil qe Microsoft-Windows-TaskScheduler/Operational /q:*[System/EventID=129]/EventData[@Name='CreatedTaskProcess']/Data[@Name='TaskName']='\created_!time_stamp!'"`
	) do (
		for /f "tokens=2 delims=><" %%$ in ("%%#") do (
			echo Started: "%executable% %arguments%"  
			echo PID: %%$
		)
	)
	
	endlocal
)

endlocal
