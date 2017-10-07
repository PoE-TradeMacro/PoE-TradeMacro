#SingleInstance, force
#Include, Class_ColorPicker.ahk

;ByRef RGBv, ByRef Av, GuiIdentifier = "", ColorIdentifier = "", PickerTitle = ""
picker := new ColorPicker("FFFFFF", 85, "", "Text", "GDI Tooltip Text Color Picker")