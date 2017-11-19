#SingleInstance, force
#Include, %A_ScriptDir%\PoEScripts_Download.ahk
#Include, %A_ScriptDir%\DebugPrintArray.ahk

currentLocale := "de"
PoEScripts_DownloadLanguageFiles(currentLocale, false)

Return

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
	dir		= %A_ScriptDir%\data_trade\lang
	bakDir	= %A_ScriptDir%\data_trade\lang\old_data_files

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

; taken from ItemInfo.ahk
StdOutStream(sCmd, Callback = "") {
	/*
		Runs commands in a hidden cmdlet window and returns the output.
	*/
							; Modified  :  Eruyome 18-June-2017
	Static StrGet := "StrGet"	; Modified  :  SKAN 31-Aug-2013 http://goo.gl/j8XJXY
							; Thanks to :  HotKeyIt         http://goo.gl/IsH1zs
							; Original  :  Sean 20-Feb-2007 http://goo.gl/mxCdn
	64Bit := A_PtrSize=8

	DllCall( "CreatePipe", UIntP,hPipeRead, UIntP,hPipeWrite, UInt,0, UInt,0 )
	DllCall( "SetHandleInformation", UInt,hPipeWrite, UInt,1, UInt,1 )

	If 64Bit {
		VarSetCapacity( STARTUPINFO, 104, 0 )		; STARTUPINFO          ;  http://goo.gl/fZf24
		NumPut( 68,         STARTUPINFO,  0 )		; cbSize
		NumPut( 0x100,      STARTUPINFO, 60 )		; dwFlags    =>  STARTF_USESTDHANDLES = 0x100
		NumPut( hPipeWrite, STARTUPINFO, 88 )		; hStdOutput
		NumPut( hPipeWrite, STARTUPINFO, 96 )		; hStdError

		VarSetCapacity( PROCESS_INFORMATION, 32 )	; PROCESS_INFORMATION  ;  http://goo.gl/b9BaI
	} Else {
		VarSetCapacity( STARTUPINFO, 68,  0 )		; STARTUPINFO          ;  http://goo.gl/fZf24
		NumPut( 68,         STARTUPINFO,  0 )		; cbSize
		NumPut( 0x100,      STARTUPINFO, 44 )		; dwFlags    =>  STARTF_USESTDHANDLES = 0x100
		NumPut( hPipeWrite, STARTUPINFO, 60 )		; hStdOutput
		NumPut( hPipeWrite, STARTUPINFO, 64 )		; hStdError

		VarSetCapacity( PROCESS_INFORMATION, 32 )	; PROCESS_INFORMATION  ;  http://goo.gl/b9BaI
	}

	If ! DllCall( "CreateProcess", UInt,0, UInt,&sCmd, UInt,0, UInt,0 ;  http://goo.gl/USC5a
				, UInt,1, UInt,0x08000000, UInt,0, UInt,0
				, UInt,&STARTUPINFO, UInt,&PROCESS_INFORMATION )
	Return ""
	, DllCall( "CloseHandle", UInt,hPipeWrite )
	, DllCall( "CloseHandle", UInt,hPipeRead )
	, DllCall( "SetLastError", Int,-1 )

	hProcess := NumGet( PROCESS_INFORMATION, 0 )
	If 64Bit {
		hThread  := NumGet( PROCESS_INFORMATION, 8 )
	} Else {
		hThread  := NumGet( PROCESS_INFORMATION, 4 )
	}

	DllCall( "CloseHandle", UInt,hPipeWrite )

	AIC := ( SubStr( A_AhkVersion, 1, 3 ) = "1.0" )                   ;  A_IsClassic
	VarSetCapacity( Buffer, 4096, 0 ), nSz := 0

	While DllCall( "ReadFile", UInt,hPipeRead, UInt,&Buffer, UInt,4094, UIntP,nSz, Int,0 ) {
		tOutput := ( AIC && NumPut( 0, Buffer, nSz, "Char" ) && VarSetCapacity( Buffer,-1 ) )
				? Buffer : %StrGet%( &Buffer, nSz, "CP850" )

		Isfunc( Callback ) ? %Callback%( tOutput, A_Index ) : sOutput .= tOutput
	}

	DllCall( "GetExitCodeProcess", UInt,hProcess, UIntP,ExitCode )
	DllCall( "CloseHandle",  UInt,hProcess  )
	DllCall( "CloseHandle",  UInt,hThread   )
	DllCall( "CloseHandle",  UInt,hPipeRead )
	DllCall( "SetLastError", UInt,ExitCode  )

	Return Isfunc( Callback ) ? %Callback%( "", 0 ) : sOutput
}