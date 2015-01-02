

break>"%temp%\empty"&&fc "%temp%\empty" "%file_to_process%" /lb  X /t |more +4 | findstr /B /E /V "*****"

rem comperatively brief way to show first N lines of a file
rem will fail the file contains ***** and MORE command will replace tab characters (if any) with space
rem http://stackoverflow.com/questions/27509846/batch-script-to-overwrite-a-file-with-first-5-lines
