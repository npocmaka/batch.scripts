<# : batch portion
@echo off & setlocal

	for /f "tokens=*" %%a in ('powershell -noprofile "iex (${%~f0} | out-string)"') do set "number=%%a"
	echo you've entered %number%

endlocal
goto :EOF

: end batch / begin powershell #>

do {
  [Console]::Error.Write("Enter a number:")
  $inputString = read-host
  $value = $inputString -as [Double]
  $ok = $value -ne $NULL
  if ( -not $ok ) {[Console]::Error.WriteLine("You must enter a numeric value") }
}
until ( $ok )

write-host "$value"
