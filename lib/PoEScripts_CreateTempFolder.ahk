PoEScripts_CreateTempFolder(ScriptDir, project) {	
	FileRemoveDir, %ScriptDir%\temp, 1
	FileCreateDir, %ScriptDir%\temp	
	
	StringTrimLeft, pathNoDrive, ScriptDir, 3
	userFolder	:= "Users\" A_UserName "\"
	isInUserFolder := InStr(pathNoDrive, userFolder)
	
	While !FileExist(ScriptDir "\temp") {
		Sleep, 100
		FileCreateDir, %ScriptDir%\temp
		If (ErrorLevel or !FileExist(ScriptDir "\temp")) {		
			msg := "Directory " ScriptDir "\temp could not be created.`n`n"
			msg .= isInUserFolder ? "It seems you're running the script from inside your windows user folder. Windows asking you for admin privileges or simply not having them can interfere with the script in this case.`n`n" : ""
			msg .= "You can try again a few times, confirm admin privileges if asked or try running this file as administrator (right-click to open context menu).`n`n"
			msg .= "You can also move the script location to somewhere else on your pc, for example " A_ProgramFiles ". This should solve all issues and is considered the best solution."
			
			MsgBox, 5, PoE-TradeMacro, % msg
			IfMsgBox, Cancel
			{
				SplashTextOn, , 20, %project%, Exiting script...
				Sleep, 2000
				SplashTextOff
				Return False
			}
		}
		Else {
			Return True
		}
	}
	
	Return True
}