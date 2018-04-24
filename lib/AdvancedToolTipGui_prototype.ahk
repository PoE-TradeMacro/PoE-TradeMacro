#SingleInstance,force
#Include, %A_ScriptDir%\DebugPrintArray.ahk
Sleep, 5000
SoundBeep

item := {}
item.name := "Gloom Bite"
item.basetype := "Ceremonial Axe"
item.lvl := 61
item.baselvl := 51
item.msockets := 3
item.dps := {}
item.dps.ele := 36.0
item.dps.phys := 147.0
item.dps.total := 183.0
item.dps.chaos := 0.0
item.dps.qphys := 162.3
item.dps.qtotal := 198.3

/*
Item Level:    61     Base Level:    51
Max Sockets:    3
Ele DPS:     36.0     Chaos DPS:    0.0
Phys DPS:   147.0     Q20 Phys:   162.3
Total DPS:  183.0     Q20 Total:  198.3
*/

BorderColor := "a65b24"
BorderWidth := 2
GuiMargin := BorderWidth + 5
Gui, TT:New, +AlwaysOnTop +ToolWindow +hwndTTHWnd
Gui, TT:Margin, %GuiMargin%, %GuiMargin%

;--------------
table01 := new Table("TT", "t01", "t01H", 9, "Consolas", "FEFEFE", true)
table01.AddCell(1, 1, item.name, "", "", "", "Trans", "", true)
table01.AddCell(2, 1, item.basetype, "", "", "", "Trans", "", true)

;--------------
table02 := new Table("TT", "t02", "t02H", 9, "Consolas", "FEFEFE", true)

table02.AddCell(1, 1, "Item Level:", "", "", "", "Trans", "", true)
table02.AddCell(1, 2, item.lvl)
table02.AddCell(1, 3, "", "", "", "", "", "", true)
table02.AddCell(1, 4, "Base Level:", "", "", "", "", "bold", "", true)
table02.AddCell(1, 5, item.baselvl)

table02.AddCell(2, 1, "Max Sockets:", "", "", "", "Red", "", true)
table02.AddCell(2, 2, item.msockets)
table02.AddCell(2, 3, "", "", "", "", "", "", true)
table02.AddCell(2, 4, "")
table02.AddCell(2, 5, "")
	
table02.AddCell(3, 1, "Ele DPS:", "", "", "", "", "", true)
table02.AddCell(3, 2, item.dps.ele)
table02.AddCell(3, 3, "", "", "", "", "", "", true)
table02.AddCell(3, 4, "Chaos DPS:", "", "", "", "", "italic", true)
table02.AddCell(3, 5, item.dps.chaos)

table02.AddCell(4, 1, "Phys DPS:", "", "Wingdings", "", "", "", true)
table02.AddCell(4, 2, item.dps.phys)
table02.AddCell(4, 3, "", "", "", "", "", "", true)
table02.AddCell(4, 4, "Q20 Phys:", "", "", "", "", "underline", true)
table02.AddCell(4, 5, item.dps.qphys)

table02.AddCell(5, 1, "Total DPS:", "", "", "", "", "", true)
table02.AddCell(5, 2, item.dps.total)
table02.AddCell(5, 3, "", "", "", "", "", "", true)
table02.AddCell(5, 4, "Q20 Total:", "", "", "", "", "strike", true)
table02.AddCell(5, 5, item.dps.qtotal)

table01.drawTable(GuiMargin)
table02.drawTable(GuiMargin)

Gui, TT:Color, 000000
; maximize the window before removing the borders/title bar etc
; otherwise there will be some remnants visible that aren't really part of the gui

DetectHiddenWindows, On
; make window invisible
WinSet, Transparent, 0, ahk_id %TTHWnd%
; "maximize" option or "WinMaximize" don't work because they activate/focus the window.
Gui, TT:Show, AutoSize NoActivate, CustomTooltip

; maximize window using PostMessage / WinMove
;PostMessage, 0x112, 0xF030,,, ahk_id %TTHWnd%
WinMove, ahk_id %TTHWnd%, , 0, 0 , A_ScreenWidth, A_ScreenHeight

; PostMessage would require some delay
;Sleep, 10

; make tooltip clickthrough and remove borders
WinSet, ExStyle, +0x20, ahk_id %TTHWnd% ; 0x20 = WS_EX_CLICKTHROUGH
WinSet, Style, -0xC00000, ahk_id %TTHWnd%
;Sleep, 2000

; make sure that PoE is activated/focused
;WinActivate, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe

; restore window to actual size
Gui, TT:Show, x50 y50 AutoSize Restore NoActivate, CustomTooltip
;make window visible again
WinSet, Transparent, 200, ahk_id %TTHWnd%

; add a border to the window
WinGetPos, TTX, TTY, TTW, TTH, ahk_id %TTHwnd%
GuiAddBorder(BorderColor, BorderWidth, TTW, TTH, "TT", TTHWnd)

global startMouseXPos := 0
global startMouseYPos := 0
MouseGetPos, startMouseXPos, startMouseYPos
SetTimer, ToolTipTimer, 100

Return

CloseToolTipTimer:
	Gui, TT:Destroy
Return

; Remove tooltip if mouse is moved
ToolTipTimer:
	ToolTipTimeout := 1000
	MouseGetPos, CurrX, CurrY
	MouseMoved := (CurrX - startMouseXPos) ** 2 + (CurrY - startMouseYPos) ** 2 > 100 ** 2
	If (MouseMoved)	{
		SetTimer, ToolTipTimer, Off
		Gui, TT:Destroy
	}
Return

GuiClose:
ExitApp


class Table {
	__New(GuiName, assocVar, assocHwnd, fontSize = 9, font = "Verdana", color = "Default", grid = false) {
		this.assocVar := "v" assocVar
		this.assocHwnd := "hwnd" assocHwnd
		this.GuiName := StrLen(GuiName) ? GuiName ":" : ""
		this.fontSize := fontSize
		this.font := font
		this.fColor := color
		this.rows := []
		this.maxColumns := 0
		this.showGrid := grid
	}
	
	DrawTable(guiMargin = 5, tableXPos = "", tableYPos = "") {
		columnWidths := []		
		rowHeights := []		
		Loop, % this.maxColumns {
			w := 0
			i := A_Index
			For key, row in this.rows {
				w := (w >= row[i].width) ? w : row[i].width
			}
			columnWidths[i] := w
		}
		For key, row in this.rows {
			h := 0
			For k, cell in row {
				h := (h >= cell.height) ? h : cell.height
			}
			rowHeights.push(h)
		}
		
		guiName := this.GuiName
		guiFontOptions := " s" this.fontSize
		guiFontOptions .= StrLen(this.fColor) ? " c" this.fColor : ""
		Gui, %guiName%Font, %guiFontOptions%, % this.font 
		
		shiftY := 0		
		tableXPos := not StrLen(tableXPos) ? "x" guiMargin : tableXPos
		tableYPos := not StrLen(tableYPos) ? "y+" guiMargin : tableYPos
		
		For key, row in this.rows {
			height := rowHeights[key] + Round((this.fontSize / 3))
			shiftY += height - 1
			shiftY := height - 1
			
			For k, cell in row {
				addedBackground := false
				width := columnWidths[k] + 20				

				If (k = 1 and key = 1) {
					yPos := " " tableYPos
				} Else If (k = 1) {
					yPos := " yp+" shiftY				
				} Else {
					yPos := " yp+0"
				}

				If (k = 1) {
					xPos := " " tableXPos					
				} Else {
					xPos := " x+-1"
				}
				
				options := ""
				options .= StrLen(cell.color) ? " c" cell.color : ""				
				options .= " w" width 
				options .= " h" height
				
				If (k = 1 and key = 1) {
					;options .= " Section"
				}

				If (cell.bgColor = "Trans") {
					options .= " BackGroundTrans"
				} Else If (StrLen(cell.bgColor)) {
					options .= " BackGroundTrans"
					bgColor := cell.bgColor
					Gui, %guiName%Add, Progress, w%width% h%height% %yPos% %xPos% Background%bgColor%					
					options .= " xp yp"
					addedBackground := true
				}
				
				If (not addedBackground) {
					options .= yPos
					options .= xPos
				}
				
				If (this.showGrid) {
					options .= " +Border"
				}

				If (cell.fColor or cell.font or cell.fontOptions) {
					elementFontOptions := StrLen(cell.fColor) ? " c" cell.fColor : ""
					elementFontOptions .= StrLen(cell.fontOptions) ? " " cell.fontOptions : ""
					elementFont := StrLen(cell.font) ? cell.font : this.font
					Gui, %guiName%Font, %elementFontOptions%, % elementFont 
				}
				
				If (RegExMatch(cell.alignment, "i)left|center|right")) {
					options .= " " cell.alignment
				}
				
				;msgbox % options
				Gui, %guiName%Add, Text, %options%, % cell.value
				If (cell.fColor or cell.font) {
					Gui, %guiName%Font, %guiFontOptions% " norm", % this.font 
				}				
			}
		}		
	}
	
	AddCell(rowIndex, cellIndex, value, alignment = "left", font = "", fColor = "", bgColor = "", fontOptions = "", isSpacingCell = false) {
		If (not this.rows[rowIndex]) {
			this.rows[rowIndex] := []
		}
		
		this.rows[rowIndex][cellIndex] := {}
		this.rows[rowIndex][cellIndex].value := " " value " " ; add spaces as table padding
		this.rows[rowIndex][cellIndex].font := StrLen(font) ? font : this.font
		size := this.MeasureText(this.rows[rowIndex][cellIndex].value, this.fontSize + 2, this.rows[rowIndex][cellIndex].font)
		this.rows[rowIndex][cellIndex].height := size.H
		this.rows[rowIndex][cellIndex].width := (not StrLen(value) and isSpacingCell) ? 10 : size.W
		this.rows[rowIndex][cellIndex].alignment := StrLen(alignment) ? alignment : "left"		
		this.rows[rowIndex][cellIndex].color := fColor
		this.rows[rowIndex][cellIndex].bgColor := bgColor
		this.rows[rowIndex][cellIndex].fontOptions := fontOptions
		this.maxColumns := cellIndex >= this.maxColumns ? cellIndex : cellIndex > this.maxColumns
		;debugprintarray(this.rows[rowIndex][cellIndex])
	}
	
	MeasureText(Str, FontOpts = "", FontName = "") {
		Static DT_FLAGS := 0x0520 ; DT_SINGLELINE = 0x20, DT_NOCLIP = 0x0100, DT_CALCRECT = 0x0400
		Static WM_GETFONT := 0x31
		Size := {}
		Gui, New
		If (FontOpts <> "") || (FontName <> "")
			Gui, Font, %FontOpts%, %FontName%
		Gui, Add, Text, hwndHWND
		SendMessage, WM_GETFONT, 0, 0, , ahk_id %HWND%
		HFONT := ErrorLevel
		HDC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
		DllCall("Gdi32.dll\SelectObject", "Ptr", HDC, "Ptr", HFONT)
		VarSetCapacity(RECT, 16, 0)
		DllCall("User32.dll\DrawText", "Ptr", HDC, "Str", Str, "Int", -1, "Ptr", &RECT, "UInt", DT_FLAGS)
		DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", HDC)
		Gui, Destroy
		Size.W := NumGet(RECT,  8, "Int")
		Size.H := NumGet(RECT, 12, "Int")
		Return Size
	}
}

GuiAddBorder(Color, Width, pW, pH, GuiName = "", parentHwnd = "") {
	; -------------------------------------------------------------------------------------------------------------------------------
	; Color        -  border color as used with the 'Gui, Color, ...' command, must be a "string"
	; Width        -  the width of the border in pixels
	; pW, pH	   -  the width and height of the parent window.
	; GuiName	   -  the name of the parent window.
	; parentHwnd   -  the ahk_id of the parent window.
	;                 You should not pass other control options!
	; -------------------------------------------------------------------------------------------------------------------------------
	LFW := WinExist() ; save the last-found window, if any
	If (not GuiName and parentHwnd) {		
		DefGui := A_DefaultGui ; save the current default GUI		
	}
	
	Gui, TTBorder:New, +Parent%parentHwnd% +LastFound -Caption +hwndBorderW
	Gui, TTBorder:Color, %Color%
	X1 := Width, X2 := pW - Width, Y1 := Width, Y2 := pH - Width
	WinSet, Region, 0-0 %pW%-0 %pW%-%pH% 0-%pH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%, ahk_id %BorderW%
	Gui, TTBorder:Show, x0 y0 w%pW% h%pH%
	
	If (not GuiName and parentHwnd) {	
		Gui, %DefGui%:Default ; restore the default Gui
	}
	
	If (LFW) ; restore the last-found window, if any
		WinExist(LFW)
}