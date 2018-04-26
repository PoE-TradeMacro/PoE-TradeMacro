; AutoHotkey
; Language:       	English 
; Authors:			Eruyome |	https://github.com/eruyome
;
; Class Function:
;	Advanced ToolTip for table-like contents using a GUI.
;	
;
; Arguments:


#SingleInstance,force
#Include, %A_ScriptDir%\DebugPrintArray.ahk

global StopWatchStart := A_TickCount
global StopWatchTextMeasure := 0

global measurementObj := {}

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

/*
	Init tooltip gui
*/
AdvTT := new AdvancedToolTipGui()
AdvTT.CreateGui()

/*
	add tables/content to the tooltip
*/
;--------------
table01 := new AdvTT.Table(AdvTT.getF(), AdvTT.getFS(), "t01", 9, "", "FEFEFE", false)

table01.AddCell(1, 1, measurementObj, item.name, "", "", "", true, "", "")
table01.AddCell(2, 1, measurementObj, item.basetype, "", "", "", true, "", "")

;--------------
table02 := new AdvTT.Table(AdvTT.getF(), AdvTT.getFS(), "t02", 9, "Consolas", "FEFEFE", true)

table02.AddCell(1, 1, measurementObj, "Item Level:", "", "", "", true, "", "")
table02.AddCell(1, 2, measurementObj,  item.lvl)
table02.AddCell(1, 3, measurementObj,  "", "", "", "", true, "", "")
table02.AddCell(1, 4, measurementObj,  "Base Level:", "", "bold", "", true, "", "")
table02.AddCell(1, 5, measurementObj,  item.baselvl)

table02.AddCell(2, 1, measurementObj,  "Max Sockets:", "", "", "", true, "", "")
table02.AddCell(2, 2, measurementObj,  item.msockets)
table02.AddCell(2, 3, measurementObj,  "", "", "", "", true, "", "")
table02.AddCell(2, 4, measurementObj,  "")
table02.AddCell(2, 5, measurementObj,  "")
	
table02.AddCell(3, 1, measurementObj,  "Ele DPS:", "", "", "", true, "", "")
table02.AddCell(3, 2, measurementObj,  item.dps.ele)
table02.AddCell(3, 3, measurementObj,  "", "", "", "", true, "", "")
table02.AddCell(3, 4, measurementObj,  "Chaos DPS:", "", "italic", "", true, "", "")
table02.AddCell(3, 5, measurementObj,  item.dps.chaos)

table02.AddCell(4, 1, measurementObj,  "Phys DPS:", "", "", "", true, "", "Wingdings")
table02.AddCell(4, 2, measurementObj,  item.dps.phys)
table02.AddCell(4, 3, measurementObj,  "", "", "", "", true, "", "")
table02.AddCell(4, 4, measurementObj,  "Q20 Phys:", "", "underline", "", true, "", "")
table02.AddCell(4, 5, measurementObj,  item.dps.qphys)

table02.AddCell(5, 1, measurementObj,  "Total DPS:", "", "", "", true, "", "")
table02.AddCell(5, 2, measurementObj,  item.dps.total)
table02.AddCell(5, 3, measurementObj,  "", "", "", "", true, "", "")
table02.AddCell(5, 4, measurementObj,  "Q20 Total:", "", "strike", "", true, "", "")
table02.AddCell(5, 5, measurementObj,  item.dps.qtotal)

;--------------
table03 := new AdvTT.Table(AdvTT.getF(), AdvTT.getFS(), "t03", 9, "Consolas", "FEFEFE", true)

table03.AddCell(1, 1, measurementObj,  "Mod", "", "bold", "26292d", true, "", "")
table03.AddCell(1, 2, measurementObj,  "Tier/Affix", "", "bold", "26292d", true, "", "")
table03.AddCell(1, 3, measurementObj,  "Stuff", "", "bold", "26292d", true, "", "")

table03.AddCell(2, 1, measurementObj,  "+20 to Maximum Life", "", "", "", true, "", "")
table03.AddCell(2, 2, measurementObj,  "test", "", "", "", "", false, "", "")
table03.AddSubCell(2, 2, 1, measurementObj,  "6", "", "", "", true)
table03.AddSubCell(2, 2, 2, measurementObj,  "P", "center", "", "red", true, "", "", true)
table03.AddSubCell(2, 2, 3, measurementObj,  "S", "center", "", "blue", true, "", "", true)
table03.AddCell(2, 3, measurementObj,  "text", "", "", "", true, "", "")

;--------------
table04 := new AdvTT.Table(AdvTT.getF(), AdvTT.getFS(), "t05", 9, "Consolas", "", false)

multilineText := "Multiline Text (no auto breaks):`n`n"
multilineText .= "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut ex arcu.`nMaecenas elit dui, ullamcorper tempus cursus eu, gravida eu lacus, `nMaecenas elit dui, ullamcorper tempus cursus eu, gravida eu lacus."
table04.AddCell(1, 1, measurementObj,  multilineText, "", "", "", true, "", "")

/*
	draw tables onto the tooltip gui
*/
table01.drawTable()
table02.drawTable()
table03.drawTable(5, 10)
table04.drawTable(5, 10)

/*
	size, position and show the tooltip
*/
AdvTT.ShowToolTip()
debugprintarray(measurementObj)
Return


GuiClose:
ExitApp

class AdvancedToolTipGui
{
	static guiName := "TT"

	__New(params*)
	{
		c := params.MaxIndex()
		If (c > 9) {
			throw "Too many parameters passed to AdvancedToolTipGui.New()"
		}
		
		; set defaults
		this.borderColor		:= (params[1] = "" or not params[1]) ? "a65b24" : params[1]
		this.backgroundColor	:= (params[2] = "" or not params[2]) ? "000000" : params[2]
		this.borderWidth		:= (params[3] = "" or not params[3]) ? 2 : params[3]
		this.opacity			:= (params[4] = "" or not params[4]) ? 200 : params[4]
		this.defTTFont			:= (params[5] = "" or not params[4]) ? "Consolas" : params[5]
		this.defTTFontSize		:= (params[6] = "" or not params[4]) ? 9 : params[6]
		this.toolTipTimeout		:= (params[7] = "" or not params[4]) ? 1000 : params[7]
		this.xPos				:= (params[8] = "" or not params[8]) ? 0 : params[8]
		this.yPos				:= (params[9] = "" or not params[9]) ? 0 : params[9]
		this.guiMargin			:= borderWidth + 5

		this.parentWindow := 
	}
	
	CreateGui()
	{
		GuiMargin := this.guiMargin
		GuiName := this.guiName

		Gui, %GuiName%:New, +AlwaysOnTop +ToolWindow +hwndTTHWnd
		Gui, %GuiName%:Margin, %GuiMargin%, %GuiMargin%
		
		Gui, %GuiName%:Color, 000000
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

		this.parentWindow := TTHwnd
	}
	
	SetToolTipSizeAndPosition() {
		xPos := this.xPos
		yPos := this.yPos
		GuiName := this.guiName
		TTHwnd := this.parentWindow
		
		; restore window to actual size
		Gui, %GuiName%:Show, x%xPos% y%yPos% AutoSize Restore NoActivate, CustomTooltip

		; add a border to the window, has to be done after auto-resizing the window
		WinGetPos, TTX, TTY, TTW, TTH, ahk_id %TTHwnd%
		this.GuiAddBorder(this.borderColor, this.borderWidth, TTW, TTH, GuiName, TTHWnd)
	}
	
	ShowToolTip() {		
		Opacity := this.opacity
		TTHwnd := this.parentWindow
		
		this.SetToolTipSizeAndPosition()
		
		;make window visible again
		WinSet, Transparent, %Opacity%, ahk_id %TTHWnd%
	}
		
	getF() {
		return this.defTTFont
	}
	getFS() {
		return this.defTTFontSize
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
		
		Gui, %GuiName%Border:New, +Parent%parentHwnd% +LastFound -Caption +hwndBorderW
		Gui, %GuiName%Border:Color, %Color%
		X1 := Width, X2 := pW - Width, Y1 := Width, Y2 := pH - Width
		WinSet, Region, 0-0 %pW%-0 %pW%-%pH% 0-%pH% 0-0   %X1%-%Y1% %X2%-%Y1% %X2%-%Y2% %X1%-%Y2% %X1%-%Y1%, ahk_id %BorderW%
		Gui, %GuiName%Border:Show, x0 y0 w%pW% h%pH%
		
		If (not GuiName and parentHwnd) {	
			Gui, %DefGui%:Default ; restore the default Gui
		}
		
		If (LFW) ; restore the last-found window, if any
			WinExist(LFW)
	}
	
	
	/*
		Table class

		guiDefFont		: default font used by the entire tooltip gui
		guiDefFontSize	: default font size used by the entire tooltip gui
		assocVar		: 
		fontSize		: table-wide font size, if "-1" the tooltip gui default font size is being used
		font			: table-wide font, if "-1" the tooltip gui default font is being used
		color			: table-wide font color in hex or a valid name like "white"
		grid			: show table grid/borders
	*/
	class Table {
		__New(guiDefFont, guiDefFontSize, assocVar, fontSize = -1, font = -1, color = "Default", grid = false) {
			class_parent := SubStr(this.__class,1,InStr(this.__class,".",0,-1)-1)
			
			this.guiName := %class_parent%.guiName ":"

			this.assocVar := "v" assocVar
			this.assocHwnd := "hwnd" assocVar "H"
			
			this.defaultFont := guiDefFont
			this.defaultFontSize := guiDefFontSize			
			this.font := (font >= 0 or StrLen(font)) ? font : this.defaultFont
			this.fontSize := (fontSize >= 0) ? fontSize : this.defaultFontSize
			this.fColor := color
			
			this.rows := []
			this.maxColumns := 0
			this.showGrid := grid
		}
		
		/*
			rowIndex		:
			cellIndex		:
			measurementObj	: object with saved text measurements, will only be used when the default fons and fontsize are used for text output, should be global in the calling script
			value			: cell contents
			alignment		: horizontal text-alignment (left, right, center)
			fontOptions		: additional options like "bold", "italic", "strikethrough", "underline"
			bgColor			: background color in hex or a valid name like "red"
			isSpacingCell	: if the cell is empty, make it a 10 pixel width spacing cell
			fColor			: font color in hex or a valid name like "white"
			font			: font family
		*/
		AddCell(rowIndex, cellIndex, ByRef measurementObj, value, alignment = "left", fontOptions = "", bgColor = "Trans", isSpacingCell = false, fColor = "", font = "") {
			If (not this.rows[rowIndex]) {
				this.rows[rowIndex] := []
			}
			
			this.rows[rowIndex][cellIndex] := {}
			this.rows[rowIndex][cellIndex].subCells := []
			this.rows[rowIndex][cellIndex].font := StrLen(font) ? font : this.font
			
			StopWatchTextMeasure_start := A_TickCount
			/*
				text width and height measuring for single and multiline text (no auto line breaks)
			*/
			newValue := ""
			width := 0
			height := 0
			value := Trim(value)
			Loop, Parse, value, `n, `r
			{
				string := A_LoopField			
				StringReplace, string, string, `r,, All
				StringReplace, string, string, `n,, All
				
				emptyLine := false
				If (not StrLen(string)) {
					string := "A"				; don't prevent emtpy lines, just having a linebreak will break the text measuring 
					emptyLine := true				
				}
				string := " " Trim(string) " "	; add spaces as table padding
				
				If (emptyLine) {
					newValue .= "`n"
				} Else {
					newValue .= string "`n"
				}		
				
				If (StrLen(string)) {
					size := this.MeasureText(string, measurementObj, "s" this.fontSize, this.rows[rowIndex][cellIndex].font)
					width := width > size.W ? width : size.W
					height += size.H
				}
			}

			this.rows[rowIndex][cellIndex].value := newValue
			this.rows[rowIndex][cellIndex].height := height
			this.rows[rowIndex][cellIndex].width := (not StrLen(value) and isSpacingCell) ? 10 : width	
			/*
			*/		
			StopWatchTextMeasure_end := A_TickCount
			StopWatchTextMeasure += StopWatchTextMeasure_end - StopWatchTextMeasure_start
			
			this.rows[rowIndex][cellIndex].alignment := StrLen(alignment) ? alignment : "left"		
			this.rows[rowIndex][cellIndex].color := fColor
			this.rows[rowIndex][cellIndex].bgColor := bgColor
			this.rows[rowIndex][cellIndex].fontOptions := fontOptions
			this.maxColumns := cellIndex >= this.maxColumns ? cellIndex : cellIndex > this.maxColumns
			;debugprintarray(this.rows[rowIndex][cellIndex])
		}
		
		/*
			rowIndex		:
			cellIndex		:
			measurementObj	: object with saved text measurements, will only be used when the default fons and fontsize are used for text output, should be global in the calling script
			value			: cell contents
			alignment		: horizontal text-alignment (left, right, center)
			fontOptions		: additional options like "bold", "italic", "strikethrough", "underline"
			bgColor			: background color in hex or a valid name like "red"
			isSpacingCell	: if the cell is empty, make it a 10 pixel width spacing cell
			fColor			: font color in hex or a valid name like "white"
			font			: font family
			noSpacing		: don't add table padding (left/right)
		*/
		AddSubCell(rI, cI, sCI, ByRef measurementObj, value, alignment = "left", fontOptions = "", bgColor = "Trans", isSpacingCell = false, fColor = "", font = "", noSpacing = false) {
			If (not this.rows[rI]) {
				this.rows[rI] := []
			}
			
			If (not this.rows[rI][cI].haskey("value")) {
				this.AddCell(rI, cI)			
			}
			this.rows[rI][cI].value := " " ; empty cell, only show subcell contents		
			this.rows[rI][cI].subCells[sCI] := {}
			this.rows[rI][cI].subCells[sCI].value := noSpacing ? value : " " value "  " ; add spaces as table padding
			
			; font priority: subcell > cell > table
			this.rows[rI][cI].subCells[sCI].font := StrLen(font) ? font : this.rows[rI][cI]
			If (not StrLen(this.rows[rI][cI].subCells[sCI].font)) {
				this.rows[rI][cI].subCells[sCI].font := this.font
			}		
			
			this.rows[rI][cI].subCells[sCI].alignment := StrLen(alignment) ? alignment : "left"		
			this.rows[rI][cI].subCells[sCI].color := fColor
			this.rows[rI][cI].subCells[sCI].bgColor := bgColor
			this.rows[rI][cI].subCells[sCI].fontOptions := fontOptions
			
			StopWatchTextMeasure_start := A_TickCount
			/*
				text width and height measuring for singleline text
			*/
			measuringText := noSpacing ? this.rows[rI][cI].subCells[sCI].value " " : this.rows[rI][cI].subCells[sCI].value
			size := this.MeasureText(measuringText, measurementObj, "s" this.fontSize, this.rows[rI][cI].subCells[sCI].font)
			this.rows[rI][cI].subCells[sCI].width := (not StrLen(value) and isSpacingCell) ? 10 : size.W
			this.rows[rI][cI].subCells[sCI].height := size.H

			For key, subcell in this.rows[rI][cI].subCells {
				If (key = 1) {
					this.rows[rI][cI].width := 0
				}
				this.rows[rI][cI].width += subcell.width
			}
			/*
			*/
			
			StopWatchTextMeasure_end := A_TickCount
			StopWatchTextMeasure += StopWatchTextMeasure_end - StopWatchTextMeasure_start
			;debugprintarray(this.rows[rI][cI].subCells[sCI])
		}
		
		DrawTable(guiMargin = 5, topMargin = 0, tableXPos = "", tableYPos = "") {	
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
			tableYPos := not StrLen(tableYPos) ? "y+" guiMargin + topMargin : tableYPos + topMargin
			
			For key, row in this.rows {
				height := rowHeights[key] + Round((this.fontSize / 3))
				shiftY += height - 1
				shiftY := height - 1
				
				For k, cell in row {
					width := columnWidths[k] + 20
					this.DrawCell(cell, guiName, k, key, guiFontOptions, tableXPos, tableYPos, shiftY, width, height)				
				}
			}		
		}
		
		DrawCell(cell, guiName, k, key, guiFontOptions, tableXPos, tableYPos, shiftY, width, height, recurse = false) {
			addedBackground := false
			
			; loop to overlay an empty cell over all subcells (easier positioning of the following column in the row)
			Loop, 2 {
				If (k = 1 and key = 1) {
					yPos := " " tableYPos
					yPosProgress := yPos
				} Else If (k = 1) {
					yPos := " yp+" shiftY
					yPosProgress := yPos
				} Else {
					yPos := (recurse and tableYPos != "null") ? " yp+" tableYPos : " yp+0"
					yPos := A_Index = 2 ? " ys+0" : yPos
					
					If (recurse) {
						yPosProgress := (tableYPos != "null") ? " yp+" tableYPos + 1 : " yp+1"				
					} Else {
						yPosProgress := "yp+0"				
					}				
				}

				If (k = 1 and not recurse) {
					xPos := " " tableXPos
					xPos := A_Index = 2 ? xPos : xPos
				} Else {
					xPos := (recurse and tableXPos != "null") ? tableXPos : " x+-1"
					xPos := A_Index = 2 ? " xs+0" : xPos
				}
				
				If (A_Index = 2) {
					cell.bgColor := "Trans"
				}
				
				options := ""
				options .= StrLen(cell.color) ? " c" cell.color : ""				
				options .= " w" width 
				options .= " h" height
				
				If (cell.subCells.length() and not recurse and not A_Index = 2) {
					options .= " Section"
				}

				If (cell.bgColor = "Trans") {
					options .= " BackGroundTrans"
				} Else If (StrLen(cell.bgColor)) {
					options .= " BackGroundTrans"
					bgColor := cell.bgColor
					Gui, %guiName%Add, Progress, w%width% h%height% %yPosProgress% %xPos% Background%bgColor%			
					options .= recurse ? " xp yp-1" : " xp yp"
					addedBackground := true
				}
				
				If (not addedBackground) {
					options .= yPos
					options .= xPos
				}
				
				If (this.showGrid and not recurse) {
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
				
				Gui, %guiName%Add, Text, %options%, % cell.value
				If (cell.fColor or cell.font) {
					Gui, %guiName%Font, %guiFontOptions% " norm", % this.font 
				}
				
				If (cell.subCells.length() and not recurse and A_Index = 1) {
					For j, subcell in cell.subcells {
						_recurse := true
						_width := subcell.width
						_xPosShift := (j = 1) ? " xs+0" : "null"
						_yPosShift := (j = 1) ? 1 : "null"		
						_height := height - 4
						this.DrawCell(subcell, guiName, 0, 0, guiFontOptions, _xPosShift, _yPosShift, shiftY, _width, _height, _recurse)	
					}
				}			
				
				If (not cell.subCells.length()) {
					Break
				}
			}
		}
		
		MeasureText(Str, ByRef measurementObj, FontOpts = "", FontName = "") {
			; take results from previous calculations if the same font options (size + family) where being used			
			useSavedResults := InStr(FontOpts, "s" this.defaultFontSize) and FontName = this.defaultFont
			saveKey := StrLen(Str)

			If (useSavedResults) {
				If (measurementObj[saveKey].haskey("width")) {
					Size := {}
					Size.H := measurementObj[saveKey].height
					Size.W := measurementObj[saveKey].width
					
					If (not measurementObj.haskey("skipped")) {
						measurementObj["skipped"] := 0	
					}
					measurementObj["skipped"] += 1
					
					Return Size
				}
			}
			
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
			
			; save measurements
			If (useSavedResults) {
				measurementObj[saveKey] := {}
				measurementObj[saveKey].height := Size.H
				measurementObj[saveKey].width := Size.W				
			}

			Return Size		
		}
	}
}