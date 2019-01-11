PoEScripts_CheckInvalidScriptFolder(currentDir,  critical = true) {
	valid := true
	
	SplitPath, currentDir, FileName, Dir, Extension, NameNoExt, Drive
	
	;msgbox % currentDir "`n" filename  "`n" dir  "`n" extension "`n" namenoext "`n" drive  "`n"  "`n" A_Desktop  "`n" A_ScriptDir "`n" A_ScriptName "`n" 
	
	msg := ""
	If (InStr(currentDir, A_Desktop)) {
		valid := false
		msg := "your Desktop (or any of its subfolders)"
	}
	If (currentDir = drive) {
		valid := false
		msg := "any drive root"
	}
	
	If (not valid) {
		msg := "Invalid Installation Path, Executing PoE-TradeMacro from " msg " may cause script errors, please choose a different directory."
		Msgbox, 0x1010, % msg
		
		If (critical) {
			ExitApp
		}
	}
}