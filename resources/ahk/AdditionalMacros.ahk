;###########----------------------- Additional Macros -------------------------###########
;# Use AdditionaMacros.ini in the user folder to enable/disable hotkeys and set a key    #
;# combination.                                                                          #
;#                                                                                       #
;# You shouldn't add your own macros here, but you can add them in the user folders      #
;# subfolder "CustomMacros\". All files there will be appended.                          #
;# Please make sure that any issues that you are experiencing aren't related to your own #
;# macros before reporting them.                                                         #
;# For example, paste the line "^Space::SendInput {Enter}/oos{Enter}" in an ".ahk" file, #
;# place it in the CustomMacros folder and you have your macro ready. It's that easy.    #
;#                                                                                       #
;# Hotkeys you can use: https://autohotkey.com/docs/KeyList.htm.                         #
;# Autohotkey Quick Reference: https://autohotkey.com/docs/AutoHotkey.htm.               #
;# Using a hotkey in your custom macro that is assigned in this scrip but set to "off"   #
;# won't work since that hotkey exists but is disabled. Use the hotkey command to        #
;# overwrite and enable it: https://autohotkey.com/docs/commands/Hotkey.htm.             #
;#                                                                                       #
;# Declaring variables or executing code outside of functions, labels or hotkeys won't   #
;# work in AdditionalMacros or your custom macros. Read more about it here:              #
;# https://autohotkey.com/docs/Scripts.htm#auto (script auto-execute section).           #
;# Function calls via hotkeys work though.                                               #
;#                                                                                       #
;# AutoHotkey IDE's and Editor setups (NotePad++, Sublime, Vim):                         #
;# https://github.com/ahkscript/awesome-AutoHotkey#integrated-development-environment    #
;#                                                                                       #
;# Curated list of awesome AHK libs, lib distributions, scripts, tools and resources:    #
;# https://github.com/ahkscript/awesome-AutoHotkey                                       #
;#                                                                                       #
;#                                                                                       #
;# AdditionalMacros Wiki entry:                                                          #
;#     https://github.com/PoE-TradeMacro/POE-TradeMacro/wiki/AdditionalMacros            #
;###########-------------------------------------------------------------------###########

AM_Init:

	class AM_Options extends UserOptions {
		
	}	
	global AM_Opts := new AM_Options()
	
	AM_Config := {}
	AM_ConfigDefault := class_EasyIni(A_ScriptDir "\resources\default_UserFiles\AdditionalMacros.ini")
	AM_ReadConfig(AM_Config)
	Sleep, 150
	
	;global AM_Config := class_EasyIni(argumentUserDirectory "\AdditionalMacros.ini")
Return

AM_AssignHotkeys:
	If (not AM_Config) {
		GoSub, AM_Init
	}
	; TODO: Refactor
	global AM_CharacterName		:= AM_Config["KickYourself"].Character
	global AM_ChannelName		:= AM_Config["JoinChannel"].Channel
	global AM_HighlightArg1		:= AM_Config["HighlightItems"].Arg1
	global AM_HighlightArg2		:= AM_Config["HighlightItems"].Arg2
	global AM_HighlightAltArg1	:= AM_Config["HighlightItemsAlt"].Arg1
	global AM_HighlightAltArg2	:= AM_Config["HighlightItemsAlt"].Arg2
	global AM_KeyToSCState		:= (TradeOpts.KeyToSCState != "") ? TradeOpts.KeyToSCState : AM_Config["General"].General_KeyToSCState

	; AdditionalMacros hotkeys.
	AM_SetHotkeys()

	GoSub, CM_ExecuteCustomMacrosCode_Label
Return

AM_TogglePOEItemScript_HKey:
	TogglePOEItemScript()			; Pause item parsing with the pause key (other macros remain).
Return

AM_Minimize_HKey:
	WinMinimize, A					; Winkey+D minimizes the active PoE window (PoE stays minimized this way).
Return

AM_HighlightItems_HKey:
	HighlightItems(AM_HighlightArg1, AM_HighlightArg2)		; Ctrl+F fills search bars in the stash or vendor screens with the item's name or info you're hovering over.
													; Function parameters, change if needed or wanted:
													;	1. Use broader terms, default = false.
													;	2. Leave the search field after pasting the search terms, default = true.
Return

AM_HighlightItemsAlt_HKey:
	HighlightItems(AM_HighlightAltArg1, AM_HighlightAltArg2)		; Ctrl+Alt+F uses much broader search terms for the highlight function.
Return

AM_LookUpAffixes_HKey:
	LookUpAffixes()				; Opens poeaffix.net in your browser, navigating to the item that you're hovering over.
Return

AM_CloseScripts_HKey:
	CloseScripts()					; Ctrl+Esc closes all running scripts specified by (and including) ItemInfo or TradeMacro.
Return

AM_KickYourself_HKey:
	; Ingame names use underscores and never spaces, but you can easily forget that when typing your name in the ini file.
	; Consequently replacing all spaces here.
	CharName := StrReplace(AM_CharacterName, " ", "_")
	SendInput {Enter}/kick %CharName%{Enter}		; Quickly leave a group by kicking yourself. Only works for one specific character name.
Return

AM_Hideout_HKey:
	SendInput {Enter}/hideout{Enter}					; Go to hideout with F5.
Return

AM_ScrollTabRight_HKey:
	SendInput {Right}		; Ctrl+scroll down scrolls through stash tabs rightward.
Return
AM_ScrollTabLeft_HKey:
	SendInput {Left}		; Ctrl+scroll up scrolls through stash tabs leftward.
Return

AM_ScrollTabRightAlt_HKey:
	Send {Right}			; Holding right mouse button+scroll down scrolls through stash tabs rightward
Return
AM_ScrollTabLeftAlt_HKey:
	Send {Left}			; Holding right mouse button+scroll up scrolls through stash tabs leftward.
Return

AM_SendCtrlC_HKey:
	SendInput ^c			; Ctrl+right mouse button sends ctrl+c.
Return

AM_Remaining_HKey:
	SendInput {Enter}/remaining{Enter}			; Mobs remaining with F9.
Return

AM_JoinChannel_HKey:
	SendInput {Enter}/%AM_ChannelName%{Enter}		; Join a channel with F10. Default = global 820.
Return

AM_SetAfkMessage_HKey:
	setAfkMessage()						; Pastes afk message to your chat and marks "X" so you can type in the estimated time.
Return

AM_AdvancedItemInfo_HKey:
	AdvancedItemInfoExt()					; Opens an item on pathof.info for an advanced affix breakdown.
Return

AM_WhoisLastWhisper_HKey:
	KeyWait, Ctrl							; Sends "/whois lastWhisperCharacterName" when keys are released (not when pressed).
	KeyWait, Alt
	SendInput {Enter}{Home}{Del}/whois{Space}{Enter}
Return

setAfkMessage(){
	T1 := A_Now
	T2 := A_NowUTC
	EnvSub, T1, %T2%, M
	TZD := "UTC +" Round( T1/60, 2 )
	FormatTime, currentTime, A_NowUTC, HH:mm
	clipboard := "/afk AFK for about X minutes, since " currentTime " (" TZD "). Leave a message and I'll reply."

	IfWinActive, Path of Exile ahk_class POEWindowClass
	{
		SendInput {Enter} ^{v} {Home}
		Pos := RegExMatch(clipboard, " X ")
		If (Pos) {
			Loop {
				SendInput {Right}
				If (A_Index > Pos) {
					Break
				}
			}
			Send {Shift Down}
			Sleep 100
			Send {Right}
			Sleep 100
			Send {Shift Up}
		}
	}
}

AM_SetHotkeys() {
	Global AM_Opts, AM_Config
	
	;console.clear()
	;debugprintarray(AM_ConfigObj)
	If (AM_Config.General.Enable) {
		For labelIndex, labelName in StrSplit(AM_Config.GetSections("|", "C"), "|") {
			If (labelName != "General") {
				For labelKeyIndex, labelKeyName in StrSplit(AM_Config[labelName].Hotkeys, ", ") {
					If (labelKeyName and labelKeyName != A_Space) {
						AM_Config[labelName].State := AM_ConvertState(AM_Config[labelName].State)						
						stateValue := AM_Config[labelName].State ? "on" : "off"
						
						; TODO: Fix hotkeys not being correctly set without restart
						;console.log(labelKeyName ", " KeyNameToKeyCode(labelKeyName, AM_KeyToSCState) ", " labelName "_HKey, " stateValue)
						Hotkey, % KeyNameToKeyCode(labelKeyName, AM_KeyToSCState), AM_%labelName%_HKey, % stateValue
					}
				}
			}
		}
	}
}

AM_ReadConfig(ByRef ConfigObj, ConfigDir = "", ConfigFile = "AdditionalMacros.ini")
{
	defaultFile := A_ScriptDir . "\resources\default_UserFiles\" . ConfigFile
	ConfigDir  := StrLen(ConfigDir) < 1 ? userDirectory : ConfigDir	; userDirectory is global
	ConfigPath := StrLen(ConfigDir) > 0 ? ConfigDir . "\" . ConfigFile : defaultFile
	
	ConfigObj  := class_EasyIni(ConfigPath)
	ConfigObj.Update(defaultFile)
	debugprintarray(ConfigObj)
}

AM_WriteConfig(ConfigDir = "", ConfigFile = "AdditionalMacros.ini")
{
	Global AM_Opts, AM_ConfigObj, AM_Config
	
	If (StrLen(ConfigDir) < 1) {
		ConfigDir := userDirectory
	}
	ConfigPath := StrLen(ConfigDir) > 0 ? ConfigDir . "\" . ConfigFile : ConfigFile
	
	AM_ConfigObj := class_EasyIni(ConfigPath)
	
	AM_ScanUI()
	; TODO: Refactor, especially the the General section exceptions
	For key, val in AM_Opts {
		section := "AM_" RegExReplace(key, "i)(.*)_.*", "$1")
		keyName := RegExReplace(key, "i).*_(.*)", "$1")
		value := ""
		
		If (keyName = "Enable" or keyName = "KeyToSCState") {
			section := "AM_General"
		}
		If (keyName = "Hotkeys" and AM_Opts[key].MaxIndex()) {			
			For k, v in AM_Opts[key] {
				value .= ", " . v
			}
			value := SubStr(value, 1 + StrLen(", "))
		} Else If (keyName = "State") {
			value := AM_ConvertState(AM_Opts[key], true)
		} Else {
			value := AM_Opts[key]
		}
		
		IniWrite(value, section, keyName, AM_ConfigObj)	
	}	
	
	AM_ConfigObj.Save(ConfigPath)
	AM_SetHotkeys()
}

AM_ScanUI() {
	Global AM_Opts, AM_ConfigObj

	; the inherited AM_Opts.ScanUI() doesn't work here (ListViews, hotkey arrays)
	; TODO: Refactor this shit
	/*
	For section, keys in AM_ConfigObj {		
		sectionName := RegExReplace(section, "i)^(AM_)?")
		If (not sectionName = "General") {
			CheckBoxID := sectionName "_State"
			
			_get := GuiGet(CheckBoxID, "", Error)
			If (not Error) {
				AM_Opts[CheckBoxID] := _get
			}			
			
			Loop, % AM_Opts[sectionName "_Hotkeys"].MaxIndex()
			{
				HotKeyID := sectionName "_HotKeys_" A_Index
				AM_Opts[sectionName "_Hotkeys"][A_Index] := AM_GetHotkeyListViewValue(HotKeyID)
			}
			
			For k, v in keys {
				If (not RegExMatch(k, "i)State|Hotkeys|Description")) {
					If (RegExMatch(sectionName, "i)HighlightItems|HighlightItemsAlt")) {
						If (k = "Arg2") {						
							ChkBoxID := sectionName "_Arg2"
							_get := GuiGet(ChkBoxID, "", Error)
							AM_Opts[ChkBoxID] := not Error ? _get : AM_Opts[ChkBoxID]						
						}			
					}
					Else {
						EditID := sectionName "_" k
						_get := GuiGet(EditID, "", Error)
						AM_Opts[EditID] := not Error ? _get : AM_Opts[EditID]
					}					
				}
			}
		}
	}
	
	_get := GuiGet("EnableAdditionalMacros", "", Error)
	AM_Opts.General_Enable := not Error ? _get : AM_Opts[General_Enable]
	*/
}

AM_ConvertState(state, reverse = false) {
	If (reverse) {
		state := state = 1 ? "on" : state
		state := state = 0 ? "off" : state	
	} Else {
		state := state = "on" ? 1 : state
		state := state = "off" ? 0 : state	
	}	
	Return state
}

AM_UpdateSettingsUI() {
	Global AM_Opts, AM_ConfigObj
	/*
	For section, keys in AM_ConfigObj {
		sectionName := RegExReplace(section, "i)^(AM_)?")
		CheckBoxID := sectionName "_State"
		GuiControl,, %CheckBoxID%, % AM_Opts[CheckBoxID]	
		
		Loop, % AM_Opts[sectionName "_Hotkeys"].MaxIndex()
		{
			HotKeyID := sectionName "_HotKeys_" A_Index
			AM_UpdateHotkeyListView(HotKeyID, AM_Opts[sectionName "_Hotkeys"][A_Index])
		}
		
		For k, v in keys {
			If (not RegExMatch(k, "i)State|Hotkeys|Description")) {
				If (RegExMatch(sectionName, "i)HighlightItems|HighlightItemsAlt")) {
					If (k = "Arg2") {						
						ChkBoxID := sectionName "_Arg2"
						GuiControl,, %ChkBoxID%, % AM_Opts[ChkBoxID]						
					}			
				}
				Else {
					EditID := sectionName "_" k
					GuiControl,, %EditID%, % AM_Opts[EditID]
				}					
			}
		}
	}
	GuiControl,, EnableAdditionalMacros, % AM_Opts.General_Enable
	*/
}

AM_UpdateHotkeyListView(controlID, value) {
	Gui, ListView, %controlID%
	LV_Delete(1)
	LV_Add("","",value)
}

AM_GetHotkeyListViewValue(controlID) {
	Gui, ListView, %controlID%
	LV_GetText(value, 1, 2)
	Return value
}