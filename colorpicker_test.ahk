#SingleInstance, force
#Include, Class_ColorPicker.ahk

global ColorPickerResultColor :=
global ColorPickerResultTrans :=

ColorPickerTitle := "GDI Tooltip Text Color Picker"

colorpicker := new ColorPicker("FFFFFF", 85, "", "Text", ColorPickerTitle)
WinWaitClose, %ColorPickerTitle%

Msgbox % ColorPickerResultARGBHex "`n" ColorPickerResultColor "`n" ColorPickerResultTrans
