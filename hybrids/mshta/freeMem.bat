@echo off
for  /f "usebackq" %%a in (`mshta ^"javascript^:code^(close^(new ActiveXObject^(^'Scripting.FileSystemObject^'^).GetStandardStream^(1^).Write^(GetObject^(^'winmgmts:^'^).ExecQuery^(^'Select * from Win32_PerfFormattedData_PerfOS_Memory^'^).ItemIndex^(0^).AvailableMBytes^)^)^); ^"`) do set free_mem=%%a
echo %free_mem%
