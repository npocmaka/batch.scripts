@echo off

for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*csc.exe") do (
    set "l="
    for /f "skip=1 tokens=2 delims=k" %%$ in ('"%%# #"') do (
        if not defined l (
            echo Installed: %%$
            set l=%%$
        )
    )
)

echo latest installed .NET %l%
