#SingleInstance Force
#Include, %A_ScriptDir%\lib\DebugPrintArray.ahk

; https://github.com/Aatoz/AutoHotKey/blob/master/other_scripts/Window%20Master/Window%20Master.ahk

GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe

WinGet, applicationHwnd, ID, ahk_group PoEWindowGrp

debugprintarray([MDMF_Enum(), MDMF_FromHWND(applicationHwnd)])



return
InitMonInfo(applicationHwnd)

return

; ======================================================================================================================
; Multiple Display Monitors Functions -> msdn.microsoft.com/en-us/library/dd145072(v=vs.85).aspx =======================
; ======================================================================================================================
; Enumerates display monitors and returns an object containing the properties of all monitors or the specified monitor.
; ======================================================================================================================
MDMF_Enum(HMON := "") {
   Static EnumProc := RegisterCallback("MDMF_EnumProc")
   Static Monitors := {}
   If (HMON = "") ; new enumeration
      Monitors := {}
   If (Monitors.MaxIndex() = "") ; enumerate
      If !DllCall("User32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", &Monitors, "UInt")
         Return False
   Return (HMON = "") ? Monitors : Monitors.HasKey(HMON) ? Monitors[HMON] : False
}
; ======================================================================================================================
;  Callback function that is called by the MDMF_Enum function.
; ======================================================================================================================
MDMF_EnumProc(HMON, HDC, PRECT, ObjectAddr) {
   Monitors := Object(ObjectAddr)
   Monitors[HMON] := MDMF_GetInfo(HMON)
   Return True
}
; ======================================================================================================================
;  Retrieves the display monitor that has the largest area of intersection with a specified window.
; ======================================================================================================================
MDMF_FromHWND(HWND) {
   Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", 0, "UPtr")
}
; ======================================================================================================================
; Retrieves the display monitor that contains a specified point.
; If either X or Y is empty, the function will use the current cursor position for this value.
; ======================================================================================================================
MDMF_FromPoint(X := "", Y := "") {
   VarSetCapacity(PT, 8, 0)
   If (X = "") || (Y = "") {
      DllCall("User32.dll\GetCursorPos", "Ptr", &PT)
      If (X = "")
         X := NumGet(PT, 0, "Int")
      If (Y = "")
         Y := NumGet(PT, 4, "Int")
   }
   Return DllCall("User32.dll\MonitorFromPoint", "Int64", (X & 0xFFFFFFFF) | (Y << 32), "UInt", 0, "UPtr")
}
; ======================================================================================================================
; Retrieves the display monitor that has the largest area of intersection with a specified rectangle.
; Parameters are consistent with the common AHK definition of a rectangle, which is X, Y, W, H instead of
; Left, Top, Right, Bottom.
; ======================================================================================================================
MDMF_FromRect(X, Y, W, H) {
   VarSetCapacity(RC, 16, 0)
   NumPut(X, RC, 0, "Int"), NumPut(Y, RC, 4, Int), NumPut(X + W, RC, 8, "Int"), NumPut(Y + H, RC, 12, "Int")
   Return DllCall("User32.dll\MonitorFromRect", "Ptr", &RC, "UInt", 0, "UPtr")
}
; ======================================================================================================================
; Retrieves information about a display monitor.
; ======================================================================================================================
MDMF_GetInfo(HMON) {
   NumPut(VarSetCapacity(MIEX, 40 + (32 << !!A_IsUnicode)), MIEX, 0, "UInt")
   If DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", &MIEX) {
      MonName := StrGet(&MIEX + 40, 32)    ; CCHDEVICENAME = 32
      MonNum := RegExReplace(MonName, ".*(\d+)$", "$1")
      Return {Name:      (Name := StrGet(&MIEX + 40, 32))
			, Handle:	 HMON
            , Num:       RegExReplace(Name, ".*(\d+)$", "$1")
            , Left:      NumGet(MIEX, 4, "Int")    ; display rectangle
            , Top:       NumGet(MIEX, 8, "Int")    ; "
            , Right:     NumGet(MIEX, 12, "Int")   ; "
            , Bottom:    NumGet(MIEX, 16, "Int")   ; "
            , WALeft:    NumGet(MIEX, 20, "Int")   ; work area
            , WATop:     NumGet(MIEX, 24, "Int")   ; "
            , WARight:   NumGet(MIEX, 28, "Int")   ; "
            , WABottom:  NumGet(MIEX, 32, "Int")   ; "
            , Primary:   NumGet(MIEX, 36, "UInt")} ; contains a non-zero value for the primary monitor.
   }
   Return False
}

InitMonInfo(windowHandle = "")
{
	/*
	global g_DictMonInfo := {}
	global g_aMapOrganizedMonToSysMonNdx := []

	SysGet, iVirtualScreenLeft, 76
	SysGet, iVirtualScreenTop, 77
	SysGet, iVirtualScreenRight, 78
	SysGet, iVirtualScreenBottom, 79
	
	
	
	g_DictMonInfo.Insert("VirtualScreenLeft", iVirtualScreenLeft)
	g_DictMonInfo.Insert("VirtualScreenTop", iVirtualScreenTop)
	g_DictMonInfo.Insert("VirtualScreenRight", iVirtualScreenRight)
	g_DictMonInfo.Insert("VirtualScreenBottom", iVirtualScreenBottom)
	*/
	
	SysGet, iMonCnt, MonitorCount
	
	/*
	SysGet, iPrimaryMon, MonitorPrimary
	SysGet, iPrimaryMon, Monitor, %iPrimaryMon%
	g_DictMonInfo.Insert("PrimaryMon", iPrimaryMon)
	g_DictMonInfo.Insert("PrimaryMonLeft", iPrimaryMonLeft)
	g_DictMonInfo.Insert("PrimaryMonRight", iPrimaryMonRight)
	g_DictMonInfo.Insert("PrimaryMonTop", iPrimaryMonTop)
	g_DictMonInfo.Insert("PrimaryMonBottom", iPrimaryMonBottom)
	g_DictMonInfo.Insert("PrimaryMonH", abs(iPrimaryMonTop-iPrimaryMonBottom))
	*/
	
	aDictMonInfo := []
	Loop, %iMonCnt%
	{
		vDictMonInfo := {}
		

		monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2)
		
		
		SysGet, Mon, Monitor, %A_Index%

		vDictMonInfo.Insert("Left", MonLeft)
		vDictMonInfo.Insert("Right", MonRight)
		vDictMonInfo.Insert("Top", MonTop)
		vDictMonInfo.Insert("Bottom", MonBottom)
		vDictMonInfo.Insert("W", Abs(MonRight-MonLeft))
		vDictMonInfo.Insert("H", Abs(MonTop-MonBottom))
		vDictMonInfo.Insert("Ndx", A_Index)
		vDictMonInfo.Insert("monitorHandle", monitorHandle)
		vDictMonInfo.Insert("vd", vd)
		aDictMonInfo.Insert(vDictMonInfo)
	}

	;aDictMonInfoCopy := ObjClone(aDictMonInfo)
	debugprintarray(aDictMonInfo)
	
	return
}