@echo off
setlocal enabledelayedexpansion
title Sculpt Audio Plugin Installer for Windows

echo ========================================================
echo          Sculpt - Audio Plugin Installer
echo ========================================================
echo.

:: Check for Administrator Privileges
net session >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ATTENZIONE] Sono richiesti i privilegi di Amministratore per installare
    echo i plugin nelle cartelle di sistema ("Program Files").
    echo.
    echo Riavvio dello script come Amministratore in corso...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

set "BASE_DIR=%~dp0"
set "INSTALLED_ANY=0"

:: ----------------------------------------------------------
:: 1. VST3 Installation
:: ----------------------------------------------------------
set "VST3_SRC=%BASE_DIR%Sculpt.vst3"
if not exist "%VST3_SRC%" set "VST3_SRC=%BASE_DIR%build\plugin\Sculpt_artefacts\Release\VST3\Sculpt.vst3"
set "VST3_DEST=C:\Program Files\Common Files\VST3\Sculpt.vst3"

if exist "%VST3_SRC%" (
    echo [1/4] Installazione VST3...
    if not exist "C:\Program Files\Common Files\VST3" mkdir "C:\Program Files\Common Files\VST3"
    xcopy /E /I /Y "%VST3_SRC%" "%VST3_DEST%" >nul
    if !ERRORLEVEL! EQU 0 (
        echo      - VST3 installato con successo in:
        echo        "%VST3_DEST%"
        set "INSTALLED_ANY=1"
    ) else (
        echo      - [ERRORE] Impossibile copiare VST3.
    )
) else (
    echo [1/4] Sculpt.vst3 non presente (saltato).
)
echo.

:: ----------------------------------------------------------
:: 2. CLAP Installation
:: ----------------------------------------------------------
set "CLAP_SRC=%BASE_DIR%Sculpt.clap"
if not exist "%CLAP_SRC%" set "CLAP_SRC=%BASE_DIR%build\plugin\Sculpt_artefacts\Release\CLAP\Sculpt.clap"
set "CLAP_DEST=C:\Program Files\Common Files\CLAP\Sculpt.clap"

if exist "%CLAP_SRC%" (
    echo [2/4] Installazione CLAP...
    if not exist "C:\Program Files\Common Files\CLAP" mkdir "C:\Program Files\Common Files\CLAP"
    copy /Y "%CLAP_SRC%" "%CLAP_DEST%" >nul
    if !ERRORLEVEL! EQU 0 (
        echo      - CLAP installato con successo in:
        echo        "%CLAP_DEST%"
        set "INSTALLED_ANY=1"
    ) else (
        echo      - [ERRORE] Impossibile copiare CLAP.
    )
) else (
    echo [2/4] Sculpt.clap non presente (saltato).
)
echo.

:: ----------------------------------------------------------
:: 3. AAX (Pro Tools) Installation
:: ----------------------------------------------------------
set "AAX_SRC=%BASE_DIR%Sculpt.aaxplugin"
if not exist "%AAX_SRC%" set "AAX_SRC=%BASE_DIR%build\plugin\Sculpt_artefacts\Release\AAX\Sculpt.aaxplugin"
set "AAX_DEST=C:\Program Files\Common Files\Avid\Audio\Plug-Ins\Sculpt.aaxplugin"

if exist "%AAX_SRC%" (
    echo [3/4] Installazione AAX (Pro Tools)...
    if not exist "C:\Program Files\Common Files\Avid\Audio\Plug-Ins" mkdir "C:\Program Files\Common Files\Avid\Audio\Plug-Ins"
    xcopy /E /I /Y "%AAX_SRC%" "%AAX_DEST%" >nul
    if !ERRORLEVEL! EQU 0 (
        echo      - AAX installato con successo in:
        echo        "%AAX_DEST%"
        set "INSTALLED_ANY=1"
    ) else (
        echo      - [ERRORE] Impossibile copiare AAX.
    )
) else (
    echo [3/4] Sculpt.aaxplugin non presente (saltato).
)
echo.

:: ----------------------------------------------------------
:: 4. Standalone Application
:: ----------------------------------------------------------
set "EXE_SRC=%BASE_DIR%Sculpt.exe"
if not exist "%EXE_SRC%" set "EXE_SRC=%BASE_DIR%build\plugin\Sculpt_artefacts\Release\Standalone\Sculpt.exe"

if exist "%EXE_SRC%" (
    echo [4/4] Applicazione Standalone trovata in:
    echo      "%EXE_SRC%"
    echo      (Eseguibile standalone pronto all'uso, non richiede installazione).
) else (
    echo [4/4] Applicazione Standalone non presente (saltata).
)
echo.

:: ----------------------------------------------------------
:: Conclusion
:: ----------------------------------------------------------
echo ========================================================
if !INSTALLED_ANY! EQU 1 (
    echo   [SUCCESSO] Installazione completata con successo!
    echo.
    echo   Prossimi passi:
    echo   1. Apri la tua DAW (Ableton, FL Studio, Cubase, Reaper, Bitwig, Pro Tools, Studio One).
    echo   2. Esegui un rescan dei plugin VST3 / CLAP / AAX.
    echo   3. Troverai "Sculpt" nella lista dei plugin di equalizzazione (EQ).
) else (
    echo   [AVVISO] Nessun file di plugin trovato da installare.
    echo   Assicurati di aver estratto l'intero archivio zip o di aver compilato il progetto.
)
echo ========================================================
echo.
pause
