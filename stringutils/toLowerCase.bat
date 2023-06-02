:toLowerCase string [var]
	setlocal enableDelayedExpansion
	set "str=%~1"
	for %%# in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (set "str=!str:%%#=%%#!")
	endlocal & (
		if "%~2" equ "" (
			echo %str%
		) else (
			set "%~2=%str%"
		)	
	)
exit /b 0	
