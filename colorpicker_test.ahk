#SingleInstance, force
#Include, Class_ColorPicker.ahk

image := A_ScriptDir "\resources\images\colorPickerPreviewBg.png"
ColorPickerResults	:= new ColorPicker("FFFFFF", 85, "GDI Tooltip Text Color Picker", image)

MsgBox % ColorPickerResults[1] "`n" ColorPickerResults[2] "`n" ColorPickerResults[3]

