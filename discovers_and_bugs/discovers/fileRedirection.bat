::Only the last file in the sequence will be affected.Not existing files will be not created
echo #>a>b>c>d>e>f
::Info will be red only from the last file in the row.Not existing files will be ignored
set /p=<a<b<d<d<e<f
::All quotes in redirecte in or out files will be ignored
echo #>"a"b"""c"""
type abc
set /p=<a""""b"c"""
