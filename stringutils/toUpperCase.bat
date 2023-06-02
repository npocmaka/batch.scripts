:toUpperCase string [var]
	setlocal enableDelayedExpansion
	set "str=%~1"
	for %%# in (A B C D E F G H I J K L M N O P P R S T U V W X Y Z) do (set "str=!str:%%#=%%#!")
	endlocal & (
		if "%~2" equ "" (
			echo %str%
		) else (
			set "%~2=%str%"
		)	
	)
exit /b 0	
