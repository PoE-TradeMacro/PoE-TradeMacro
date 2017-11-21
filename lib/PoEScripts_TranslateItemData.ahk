PoEScripts_TranslateItemData(data, langData, locale, ByRef status = "") {
	If (not StrLen(locale) or locale = "en") {
		status := "Translation aborted"
		Return data
	}
	
	rarityTags := ["Seltenheit", "Rareté", "Raridade", "Редкость", "ความหายาก", "Rareza"]	; hardcoded, no reliable translation source
	rareTranslation := ["Selten", "Rare", "Raro", "Редкий", "แรร์", "Raro"]	; hardcoded, at least the german term for "rare" is "wrong" and differently translated elsewhere
	lang := new TranslationHelpers(langData)
	
	;---- Not every item has every section,  depending on BaseType and Corruption/Enchantment
	; Section01 = NamePlate (Rarity, ItemName, ItemBaseType)
	; Section02 = Armour/Weapon innate stats like EV, ES, AR, Quality, PhysDmg, EleDmg, APs, CritChance AND Flask Charges/Duration etc
	; Section03 = Requirements (dex, int, str, level)
	; Section04 = Implicit Mod / Enchantment
	; Section05 = Explicit Mods
	; Section06 = Corruption tag
	; Section07+ = Descriptions/Flavour Texts
	
	; push all sections to array
	sections	:= []
	sectionsT := []
	Pos		:= 0
	_data := data "--------"
	
	While Pos := RegExMatch(_data, "is)(.*?)(\r\n-{8})", section, Pos + (StrLen(section) ? StrLen(section) : 1)) {
		sectionLines := []
		Loop, parse, section1, `n, `r 
		{			
			If (StrLen(Trim(A_LoopField))) {
				sectionLines.push(Trim(A_LoopField))
			}
		}
		sections.push(sectionLines)
	}
	
	ItemBaseType := ""
	_item := {}
	For key, section in sections {
		; nameplate section, look for ItemBaseType which is important for further parsing.
		If (key = 1) {
			For i, line in section {
				; rarity
				RegExMatch(line, "i)(.*?):(.*)", keyValuePair)
				If (LangUtils.IsInArray(keyValuePair1, rarityTags, posFound)) {
					_s := "Rarity: " Trim(keyValuePair1)	
					_item.rarity := lang.GetBasicInfo(Trim(keyValuePair2))
					; TODO: improve this, only works for "rare", not sure if needed
					If (not _item.rarity) {
						_item.rarity := lang.GetBasicInfo(rareTranslation[posFound])
					}					
				}	
			}	
		}
	}

	Return data
}

class TranslationHelpers {
	__New(dataObj)
	{
		this.data := dataObj
	}
	
	GetBasicInfo(needle) {
		basic := this.data.localized.basic

		For key, val in basic {
			If (needle = val.localized and StrLen(needle)) {
				Return val.default
			}
		}
	}
	
	GetItemInfo(needleType, needleName = "") {
		localized	:= this.data.localized
		default 	:= this.data.default
		
		_arr := {}
		Loop, % localized.items.MaxIndex() {
			i := A_Index
			For key, val in localized.items[i] {
				label := localized.items[i].label
				If (key = "entries") {
					For k, v in val {
						foundName := v.name = Trim(needleName) and Strlen(v.name) ? true : false
						foundType := v.type = Trim(needleType) and Strlen(v.type) ? true : false
						
						If (foundName and foundType) {
							_arr.name				:= v.name
							_arr.baseType			:= v.type
							_arr.type				:= label
							_arr.default_name		:= default.items[i][key][k].name
							_arr.default_basetype	:= default.items[i][key][k].type
							_arr.default_type		:= default.items[i].label
							Return _arr
						}
						Else If (foundType) {
							_arr.baseType			:= v.type
							_arr.type				:= label
							_arr.default_basetype	:= default.items[i][key][k].type
							_arr.default_type		:= default.items[i].label
							Return _arr
						}
					}
				}
			}
		}
	}
}

class LangUtils {
	IsArray(obj) {
		Return !!obj.MaxIndex()
	}

	; Trim trailing zeros from numbers
	ZeroTrim(number) {
		RegExMatch(number, "(\d+)\.?(.+)?", match)
		If (StrLen(match2) < 1) {
			Return number
		} Else {
			trail := RegExReplace(match2, "0+$", "")
			number := (StrLen(trail) > 0) ? match1 "." trail : match1
			Return number
		}
	}

	IsInArray(el, array, ByRef i) {
		For i, element in array {
			If (el = "") {
				Return false
			}
			If (element = el) {
				Return true
			}
		}
		Return false
	}

	CleanUp(in) {
		StringReplace, in, in, `n,, All
		StringReplace, in, in, `r,, All
		Return Trim(in)
	}


	Arr_concatenate(p*) {
		res := Object()
		For each, obj in p
			For each, value in obj
				res.Insert(value)
		return res
	}	
}