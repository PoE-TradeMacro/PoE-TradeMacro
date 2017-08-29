; #####################################################################################################################
; # This script checks if the right AHK version is installed and runs the TradeMacro merge script.
; #####################################################################################################################
#Include, %A_ScriptDir%\resources\VersionTrade.txt

TradeMsgWrongAHKVersion := "AutoHotkey v" . TradeAHKVersionRequired . " or later is needed to run this script. `n`nYou are using AutoHotkey v" . A_AhkVersion . " (installed at: " . A_AhkPath . ")`n`nPlease go to http://ahkscript.org to download the most recent version."
If (A_AhkVersion < TradeAHKVersionRequired)
{
    MsgBox, 16, Wrong AutoHotkey Version, % TradeMsgWrongAHKVersion
    ExitApp
}

arguments := ""
Loop, %0%  ; For each parameter
{
	arguments .= " " Trim(%A_Index%)
}

Run "%A_AhkPath%" "%A_ScriptDir%\resources\ahk\Merge_TradeMacro.ahk" "%A_ScriptDir%" %arguments%
ExitApp