@cScript.EXE //noLogo "%~f0?.WSF"  //job:info %~nx0 %*
@exit /b 0

   <job id="info">
      <script language="VBScript">
		if WScript.Arguments.Count < 2 then
			WScript.Echo "No drive letter passed"
			WScript.Echo "Usage: " 
			WScript.Echo "  " & WScript.Arguments.Item(0) & " {LETTER|*}"
			WScript.Echo "  * will eject all cd drives"
			WScript.Quit 1
		end if
		driveletter = WScript.Arguments.Item(1):
		driveletter = mid(driveletter,1,1):
		
		Public Function ejectDrive (drvLtr)
			Set objApp = CreateObject( "Shell.Application" ):
			Set objF=objApp.NameSpace(&H11&):
			'WScript.Echo(objF.Items().Count):
			set MyComp = objF.Items():
			for each item in objF.Items() :
				iName = objF.GetDetailsOf (item,0): 
				iType = objF.GetDetailsOf (item,1): 
				iLabels = split (iName , "(" ) :
				iLabel = iLabels(1):
								
				if Ucase(drvLtr & ":)") = iLabel and iType = "CD Drive" then
					set verbs=item.Verbs():
					set verb=verbs.Item(verbs.Count-4):
					verb.DoIt():
					item.InvokeVerb replace(verb,"&","") :
					ejectDrive = 1:
					exit function:
					
				end if
			next	
			ejectDrive = 2:
		End Function
		
		Public Function ejectAll ()
			Set objApp = CreateObject( "Shell.Application" ):
			
			Set objF=objApp.NameSpace(&H11&):
			'WScript.Echo(objF.Items().Count):
			set MyComp = objF.Items():
			for each item in objF.Items() :
				iType = objF.GetDetailsOf (item,1): 								
				if  iType = "CD Drive" then
					set verbs=item.Verbs():
					set verb=verbs.Item(verbs.Count-4):
					verb.DoIt():
					item.InvokeVerb replace(verb,"&","") :
				end if

			next
		End Function
		if driveletter = "*" then 
			call ejectAll
			WScript.Quit 0
		end if
		result = ejectDrive (driveletter):
		
		if result = 2 then
			WScript.Echo "no cd drive found with letter " & driveletter & ":"
			WScript.Quit 2
		end if
		
      </script>
  </job>
