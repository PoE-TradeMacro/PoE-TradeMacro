;#SingleInstance, force
;#Include, %A_ScriptDir%\PoEScripts_Download.ahk
;#Include, %A_ScriptDir%\DebugPrintArray.ahk

PoEScripts_DownloadLanguageFiles(currentLocale, dlAll = false) {
	lang := ParseAvailableLanguages()
	
	If (dlAll) {
		For key, l in lang {
			DownloadFileSet(key, l)
		}
	} Else If (not currentLocale = "en" and currentLocale) {
		DownloadFileSet(currentLocale, lang[currentLocale])
	}
	
	;msgbox done
}

DownloadFileSet(short, long) {
	prefix := short = "en" ? "www" : short	
	
	options	:= ""

	files := []
	files.push(["https://" prefix ".pathofexile.com/api/trade/data/stats", short "_stats.json"])
	files.push(["https://" prefix ".pathofexile.com/api/trade/data/static", short "_static.json"])
	files.push(["https://" prefix ".pathofexile.com/api/trade/data/items", short "_items.json"])
	If (short != "en") {		
		files.push(["http://web.poecdn.com/js/translate." long ".js", short "_basic.json"])
	}

	; disabled while using debug mode
	dir		= %A_ScriptDir%\data\lang
	bakDir	= %A_ScriptDir%\data\lang\old_data_files

	; download (overwrite) data files
	; if downloaded files have a size rename them, overwriting the ones already existing
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
			ioHdr.push("Host: " short ".pathofexile.com")
		}	

		options := "SaveAs: " filePath "_temp"
		output :=  PoEScripts_Download(url, postData := "", ioHdr := reqHeaders, options, true, false, true)
		options := ""
		
		FileGetSize, sizeOnDisk, %filePath%_temp
		If (sizeOnDisk) {
			FileDelete, %filePath%
			FileMove, %filePath%_temp, %filePath%
		}
		FileDelete, %filePath%_temp
	}	
}

ParseAvailableLanguages() {
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