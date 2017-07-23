; KEYS
;-----------------------------------------------------
Hotkey, F2, destroyPicked, On
Hotkey, ^X, destroyBelow, On
;-----------------------------------------------------


destroyPicked(){
	BlockInput On
	Send {Enter}
	Sleep 2
	Send /destroy
	Send {Enter}
	BlockInput Off
	Return
}

destroyBelow(){
	BlockInput On
	Send {LButton}
	Sleep 16
	Send {Enter}
	Sleep 8
	Send /destroy
	Send {Enter}
	BlockInput Off
	Return
}