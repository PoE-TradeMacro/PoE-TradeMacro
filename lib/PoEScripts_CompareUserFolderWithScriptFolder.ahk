PoEScripts_CompareUserFolderWithScriptFolder(userPath, scriptPath, project) {
	If (userPath = scriptPath) {
		msg := "The " project " macro can't be run from the " project " user settings folder. Please move/install the macro to a different location."
		msg .= "`n`nInvalid location: `n        " userPath
		msg .= "`n`nScript will be closed."
		
		SplashTextOff
		MsgBox,16,Invalid %project% Script Location, % msg
		ExitApp
	}
}