echo off
set updateScriptPath=%1
set installPath=%2

:: remove current script directory (install directory)
rd /s /q %installPath%
dir /b /a %installPath%"\*" | >nul findstr "^" && (set clearInstallDir=0) || set clearInstallDir=1
if %clearInstallDir% EQU 1 (
	echo install directory is empty
) else (
	echo install directory is not empty
)

if %clearInstallDir% EQU 1 (
	:: copy new script files to install directory
	:: https://ss64.com/nt/robocopy-exit.html
	robocopy /s /NFL /NDL /NJH /NJS /nc /np %updateScriptPath% %installPath%
	if %ERRORLEVEL% EQU 16 set errorL=%ERRORLEVEL% & set error="***FATAL ERROR***" & goto EndScript
	if %ERRORLEVEL% EQU 15 set errorL=%ERRORLEVEL% & set error="OKCOPY + FAIL + MISMATCHES + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 14 set errorL=%ERRORLEVEL% & set error="FAIL + MISMATCHES + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 13 set errorL=%ERRORLEVEL% & set error="OKCOPY + FAIL + MISMATCHES" & goto EndScript
	if %ERRORLEVEL% EQU 12 set errorL=%ERRORLEVEL% & set error="FAIL + MISMATCHES" & goto EndScript
	if %ERRORLEVEL% EQU 11 set errorL=%ERRORLEVEL% & set error="OKCOPY + FAIL + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 10 set errorL=%ERRORLEVEL% & set error="FAIL + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 9 set errorL=%ERRORLEVEL% & set error="OKCOPY + FAIL" & goto EndScript
	if %ERRORLEVEL% EQU 8 set errorL=%ERRORLEVEL% & set error="FAIL" & goto EndScript
	if %ERRORLEVEL% EQU 7 set errorL=%ERRORLEVEL% & set error="OKCOPY + MISMATCHES + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 6 set errorL=%ERRORLEVEL% & set error="MISMATCHES + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 5 set errorL=%ERRORLEVEL% & set error="OKCOPY + MISMATCHES" & goto EndScript
	if %ERRORLEVEL% EQU 4 set errorL=%ERRORLEVEL% & set error="MISMATCHES" & goto EndScript
	if %ERRORLEVEL% EQU 3 set errorL=%ERRORLEVEL% & set error="OKCOPY + XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 2 set errorL=%ERRORLEVEL% & set error="XTRA" & goto EndScript
	if %ERRORLEVEL% EQU 1 set errorL=%ERRORLEVEL% & set error="OKCOPY" & goto EndScript
	if %ERRORLEVEL% EQU 0 set errorL=%ERRORLEVEL% & set error="No Change" & goto EndScript
) else (
	set error="Install dir not empty. Cancelled copying files to install dir."
	set errorL=17
	goto EndScript
)

:EndScript
:: clean directory again
if exist %updateScriptPath% (
for /f %%i in ('rd /s /q %updateScriptPath%') do set test=%%i
)
echo %error%
echo %errorL%

:: write exit code to file
echo %errorL% >exitCode.txt

::pause