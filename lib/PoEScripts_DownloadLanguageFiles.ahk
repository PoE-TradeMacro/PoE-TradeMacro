PoEScripts_DownloadLanguageFiles(currentLocale, dlAll = false) {
	lang := PoEScripts_ParseAvailableLanguages()
	translationData := {}
	
	If (dlAll) {
		For key, l in lang {
			translationData := PoEScripts_DownloadFileSet(key, l)
		}
	} Else If (not currentLocale = "en" and currentLocale) {
		translationData.currentLocale := currentLocale
		translationData["localized"]	:= PoEScripts_DownloadFileSet(currentLocale, lang[currentLocale])
		translationData["default"] 	:= PoEScripts_DownloadFileSet("en", lang["en"])
	}
	
	
	For key, val in translationData {
		console.log(key)	
		If (translationData[key]) {
			console.log(val)
		}		
	}
	
	
	
	Return translationData
}

PoEScripts_DownloadFileSet(short, long) {
	returnObj := {}
	prefix := short = "en" ? "www" : short

	files := []
	For key, val in ["stats", "static", "items"] {
		files.push(["https://" prefix ".pathofexile.com/api/trade/data/" val, short "_" val ".json", val])
		;files.push(["https://" prefix ".pathofexile.com/api/trade/data/" static, short "_" key ".json", "static"])
		;files.push(["https://" prefix ".pathofexile.com/api/trade/data/" items, short "_" key ".json", "item"])	
	}	
	If (short != "en") {
		files.push(["http://web.poecdn.com/js/translate." long ".js", short "_basic.json", "basic"])
	}

	; download (overwrite) data files
	; if downloaded files have a size rename them, overwriting the ones already existing
	dir = %A_ScriptDir%\data\lang
	If (not FileExist(dir)) {
		FileCreateDir, %dir%
	}
	
	Loop % files.MaxIndex() {
		url := files[A_Index][1]
		file:= files[A_Index][2]
		filePath = %dir%\%file%
		
		reqHeaders	:= []
		reqHeaders.push("Connection: keep-alive")
		reqHeaders.push("Cache-Control: max-age=0")
		reqHeaders.push("Upgrade-Insecure-Requests: 1")
		reqHeaders.push("Accept: */*")
		reqHeaders.push("Accept-Language: de,en-US;q=0.7,en;q=0.3")
		
		ioHdr := reqHeaders
		If (InStr(url, "web.poecdn.com")) {
			ioHdr.push("Host: web.poecdn.com")
		} Else {
			ioHdr.push("Host: " prefix ".pathofexile.com")
		}
		console.log(url)
		output :=  PoEScripts_Download(url, postData := "", ioHdr := reqHeaders, "SaveAs: " filePath "_temp", true, false, true)		
		
		FileGetSize, sizeOnDisk, %filePath%_temp
		If (sizeOnDisk) {
			FileDelete, %filePath%
			If (RegExMatch(url, ".*\.js$")) {
				FileRead, jsFile, %filepath%_temp
				JSON := PoEScripts_ConvertJSVariableFileToJSON(jsFile)				
				FileAppend, %JSON%, %filePath%, utf-8
			} Else {				
				FileMove, %filePath%_temp, %filePath%
			}
		}
		FileDelete, %filePath%_temp
		
		returnObj := {}
		If (sizeOnDisk) {
			FileRead, JSONFile, %filePath%
			Try {
				parsedJSON := JSON.Load(JSONFile)
				returnObj[files[A_Index][3]] := parsedJSON.result
			} Catch e {
				MsgBox, % "Failed to parse: " filePath 
			}
		}
	}

	Return returnObj
}

PoEScripts_ConvertJSVariableFileToJSON(file) {
	return file
}

PoEScripts_ParseAvailableLanguages() {
	url 	:= "https://www.pathofexile.com/trade"
	options	:= ""

	reqHeaders	:= []
	reqHeaders.push("Host: www.pathofexile.com")
	reqHeaders.push("Connection: keep-alive")
	reqHeaders.push("Cache-Control: max-age=0")
	reqHeaders.push("Upgrade-Insecure-Requests: 1")
	reqHeaders.push("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8")

	html := PoEScripts_Download(url, postData, reqHeaders, options, false)
	
	languages := {}
	If (StrLen(html)) {
		Pos := 0
		While Pos := RegExMatch(html, "i)hreflang=""(\w*)-?(\w*)""", lang, Pos + (StrLen(lang) ? StrLen(lang) : 1)) {
			If (lang2) {
				StringLower, lang, lang2
			} Else {
				StringLower, lang, lang1
			}			
			languages[lang] := lang2 ? lang1 "_" lang2 : lang
		}
	} 
	If (not languages.en) {
		languages["br"] := "pt_BR"
		languages["de"] := "de_DE"
		languages["en"] := "en"
		languages["es"] := "es_ES"
		languages["fr"] := "fr_FR"
		languages["ru"] := "ru_RU"
		languages["th"] := "th_TH"
	}

	Return languages
}