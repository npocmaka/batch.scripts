@echo off

	for /f %%W in (
		'mshta vbscript:Execute("createobject(""scripting.filesystemobject"").GetStandardStream(1).writeline(DatePart(""ww"",Now()))"^^^&close^)'
	) do @( 
	 set "weekn=%%W"
	)

echo %weekn%
