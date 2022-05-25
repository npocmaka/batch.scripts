:: ===============================================================================================
:: @file          BinaryTree.cmd
:: @brief         Binary tree implementation in batch file
:: @usage         BinaryTree.cmd
:: @see           https://github.com/sebetci/batch.script/[01].DataStructures/BinaryTree.cmd
:: @reference     https://en.wikipedia.org/wiki/Binary_tree
:: @reference     https://github.com/npocmaka/batch.scripts/tree/master/dataStructures
:: @reference     https://www.dostips.com/forum/viewtopic.php?t=7642
:: @todo          The FFIND method does not search after the first level of the tree.
:: @todo          The FDELETE method will be developed.
:: ===============================================================================================

@ECHO OFF
CALL :FMAIN
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function inserts new values to the tree and then finds for some values in the tree.
:: @parameter  None
:: @return     None
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:FMAIN
   SETLOCAL ENABLEDELAYEDEXPANSION

   :: This variable must be assigned a value of 1 or 0.
   :: If this variable is set to 1, the echo command in its sub-methods will work.
   SET /A VDebug=1

   :: The following commands add new nodes to the tree.
   CALL :FINSERT VTreeName 1
   CALL :FINSERT VTreeName 3
   CALL :FINSERT VTreeName 5

   :: The following commands find for the value 1 in the tree.
   :: If the FFIND method finds the value 1, the variable %ERRORLEVEL% has the value 1.
   ECHO.
   ECHO [VDebug:MAIN] Searching for value 1
   CALL :FFIND VTreeName 1
   ECHO [VDebug:MAIN] Return Value: %ERRORLEVEL%
   IF %ERRORLEVEL% EQU 0 (ECHO [VDebug:MAIN] 1 was found in the three.) ELSE (ECHO [VDebug:MAIN] 1 not found in tree.)
   
   :: The following commands find for the value 1 in the tree.
   :: If the FFIND method does not find the value 8, the variable %ERRORLEVEL% will have the value 0.
   ECHO.
   ECHO [VDebug:MAIN] Searching for value  8
   CALL :FFIND VTreeName 8
   ECHO [VDebug:MAIN] Return Value: %ERRORLEVEL%
   IF %ERRORLEVEL% EQU 0 (ECHO [VDebug:MAIN] 8 was found in the three.) ELSE (ECHO [VDebug:MAIN] 8 not found in tree.)

   :: The tree content is printed to the console.
   CALL :FPRINT VTreeName

   :: This method content will be developed.
   CALL :FDELETE VTreeName
   EXIT /B 0

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function searches the Value value in the VTreeName tree. It returns 0 if the 
::             searched value is found in the tree.
:: @parameter  VTreeName This parameter is the name of the node.
:: @parameter  VValue This parameter is the value of the node.
:: @return     Returns 0 if value is found in the tree.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:FFIND VTreeName VValue
   :: SETLOCAL ENABLEDELAYEDEXPANSION
   SET /A VValue=%~2

   IF %VDebug% EQU 1 ECHO [VDebug:FIND] Content-1: %VTreeName%
   IF %VDebug% EQU 1 ECHO [VDebug:FIND] Content-2: %VValue%
   IF %VDebug% EQU 1 ECHO [VDebug:FIND] Param-1: %1
   IF %VDebug% EQU 1 ECHO [VDebug:FIND] Param-2: %2

   IF %VTreeName% EQU %2 (
      ENDLOCAL & (
         EXIT /B 0
      )
   )

   IF %VValue% GTR %1 (
      IF DEFINED %1R (
         ENDLOCAL & (
            CALL :FFIND %1R %VValue%
         )
      ) ELSE (
         ENDLOCAL & (
            EXIT /B 1
         )
      )
   )

   IF %VValue% LSS %1 (
      IF DEFINED %1L (
         ENDLOCAL & (
            CALL :FFIND %1L %VValue%
         )
      ) ELSE (
         ENDLOCAL & (
            EXIT /B 1
         )
      )
   )

   EXIT /B 

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function adds a new node to the tree.
:: @parameter  VTreeName This parameter is the name of the node.
:: @parameter  VValue This parameter is the value of the node.
:: @return     None
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:FINSERT VTreeName VValue
   SETLOCAL
   SET /A VValue=%~2

   IF NOT DEFINED %~1 (
      ENDLOCAL & (
         SET "%~1=%VValue%"
         EXIT /B 0
      )
   )

   IF %VValue% GEQ %~1R (
      IF NOT DEFINED  %~1R (
         ENDLOCAL & (
            SET %~1R=%VValue%
            EXIT /B 0
         )
      ) ELSE (
         ENDLOCAL & (
            CALL :FINSERT %~1R %VValue%
         )
      )
   )

   IF %VValue% LSS %~1L ( 
      IF NOT DEFINED  %~1L (
         ENDLOCAL & (
            SET %~1L=%VValue%
            EXIT /B 0
         )
         ) ELSE (
            ENDLOCAL & (
               CALL :FINSERT %~1R %VValue%
            )
         )
   )
   EXIT /B 0

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function prints the names and values of the node nodes in the tree.
:: @parameter  VTreeName This parameter is the name of the node.
:: @return     None
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:FPRINT VTreeName
   ECHO.
   SET VTreeName
   EXIT /B 0

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: @function   This function deletes all nodes in a tree.
:: @parameter  VTreeName This parameter is the name of the node.
:: @return     None
:: @todo       Investigate the feasibility of this method.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:FDELETE VTreeName
   EXIT /B 0