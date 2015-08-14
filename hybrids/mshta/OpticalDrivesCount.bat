@echo off
for  /f "usebackq" %%a in (`mshta ^"javascript^:code^(close^(new ActiveXObject^(^'Scripting.FileSystemObject^'^).GetStandardStream^(1^).Write^(new ActiveXObject^(^'IMAPI2.MsftDiscMaster2.1^'^).Count^)^)^); ^"`) do set OptDrives=%%a
echo %OptDrives%
