   :: Goto to not  existing label exits the script and put in commpand prompt context
   :: so commands with negative conditional execution will be executed
   :: First I proposed using negative conditiontional execution here:
   :: http://stackoverflow.com/questions/23318951/how-to-treat-user-input-as-two-words-instead-of-one-in-batch
   :: later the user that I've answered to discovered that only the conditions on the same line will be executed:
   :: http://stackoverflow.com/questions/23327304/my-goto-redirect-is-not-working-but-works-with-echo
   :: Where jeb's found that the script goes to command prompt context
   :: And here I've found that the brackets and FOR contexts are not broken :
   :: http://www.dostips.com/forum/viewtopic.php?f=3&t=5928
   
   
   @echo off
   setlocal enableDelayedExpansion
   
   for /f "tokens=1,2,3" %%a in ("1 2 3 ") do (
      set /a n=1+1
      goto :no_label_ >nul 2>&1 ||  break just fills the end of line
      echo brackets context is not broken
      echo(
      echo and so variables cannot be accessed
      set "n2=something else"
      echo -%n%- and -%n2%-
      echo but more delayed expansioon does not work --^> !n!  :-(
      echo(
      echo and for context is not broken!!!!
      echo %%a--%%b--%%c
      echo pass a command line parameter to check the output of this:
      echo ~"%~1"~
   
   )
    echo never printed
