#SingleInstance Force
#Include, %A_ScriptDir%\lib\DebugPrintArray.ahk

; https://github.com/Aatoz/AutoHotKey/blob/master/other_scripts/Window%20Master/Window%20Master.ahk

InitMonInfo()

return

InitMonInfo()
{
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

	SysGet, iMonCnt, MonitorCount

	SysGet, iPrimaryMon, MonitorPrimary
	SysGet, iPrimaryMon, Monitor, %iPrimaryMon%
	g_DictMonInfo.Insert("PrimaryMon", iPrimaryMon)
	g_DictMonInfo.Insert("PrimaryMonLeft", iPrimaryMonLeft)
	g_DictMonInfo.Insert("PrimaryMonRight", iPrimaryMonRight)
	g_DictMonInfo.Insert("PrimaryMonTop", iPrimaryMonTop)
	g_DictMonInfo.Insert("PrimaryMonBottom", iPrimaryMonBottom)
	g_DictMonInfo.Insert("PrimaryMonH", abs(iPrimaryMonTop-iPrimaryMonBottom))

	aDictMonInfo := []
	Loop, %iMonCnt%
	{
		vDictMonInfo := {}

		SysGet, Mon, MonitorWorkArea, %A_Index%

		vDictMonInfo.Insert("Left", MonLeft)
		vDictMonInfo.Insert("Right", MonRight)
		vDictMonInfo.Insert("Top", MonTop)
		vDictMonInfo.Insert("Bottom", MonBottom)
		vDictMonInfo.Insert("W", Abs(MonRight-MonLeft))
		vDictMonInfo.Insert("H", Abs(MonTop-MonBottom))
		vDictMonInfo.Insert("Ndx", A_Index)
		aDictMonInfo.Insert(vDictMonInfo)

		;~ DictMonInfo.Insert("MonLeft", vTempMonInfo%A_Index%.left)
		;~ DictMonInfo.Insert("MonRight", vTempMonInfo%A_Index%.right)
		;~ DictMonInfo.Insert("MonTop", vTempMonInfo%A_Index%.top)
		;~ DictMonInfo.Insert("MonBottom", vTempMonInfo%A_Index%.bottom)
		;~ DictMonInfo.Insert("MonW", Abs(vTempMonInfo%A_Index%.right-vTempMonInfo%A_Index%.left))
		;~ DictMonInfo.Insert("MonH", Abs(vTempMonInfo%A_Index%.top-vTempMonInfo%A_Index%.bottom))
		;~ aDictMonInfo.Insert(DictMonInfo)
	}

	;~ Msgbox % st_concat("`n"
	;~ ,	"----------Mon1----------`r`Top:`t" aDictMonInfo.1.Top, "Bottom:`t" aDictMonInfo.1.Bottom, "H:`t" aDictMonInfo.1.H, "Left:`t" aDictMonInfo.1.Left
	;~ ,	"----------Mon2----------`r`nTop:`t" aDictMonInfo.2.Top, "Bottom:`t" aDictMonInfo.2.Bottom, "H:`t" aDictMonInfo.2.H, "Left:`t" aDictMonInfo.2.Left)

	aDictMonInfoCopy := ObjClone(aDictMonInfo)
	debugprintarray(aDictMonInfoCopy)

	return
}