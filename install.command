#!/bin/bash
set -e

# ========================================================
#   Sculpt - macOS Audio Plugin Installer
#   Supports: AU (.component), VST3, CLAP, AAX, Standalone (.app)
# ========================================================

echo "========================================================"
echo "          Sculpt - macOS Plugin Installer"
echo "========================================================"
echo ""

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Errore: questo script e progettato esclusivamente per macOS."
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLED_ANY=0

echo "🔍 Rilevamento file in: $SCRIPT_DIR"
echo ""

# ----------------------------------------------------------
# 0. Rimuovi attributi di quarantena Apple (Gatekeeper)
# ----------------------------------------------------------
echo "🔓 Rimozione attributi di quarantena macOS (Gatekeeper)..."
xattr -cr "$SCRIPT_DIR" 2>/dev/null || true
echo "   Fatto."
echo ""

# ----------------------------------------------------------
# 1. Installazione AU (Audio Unit - Logic Pro, GarageBand)
# ----------------------------------------------------------
AU_SRC="$SCRIPT_DIR/Sculpt.component"
if [ ! -d "$AU_SRC" ]; then AU_SRC="$SCRIPT_DIR/build/plugin/Sculpt_artefacts/Release/AU/Sculpt.component"; fi
AU_DEST="$HOME/Library/Audio/Plug-Ins/Components"

if [ -d "$AU_SRC" ]; then
    echo "📦 [1/5] Installazione Audio Unit (AU)..."
    mkdir -p "$AU_DEST"
    rm -rf "$AU_DEST/Sculpt.component"
    cp -R "$AU_SRC" "$AU_DEST/"
    xattr -cr "$AU_DEST/Sculpt.component" 2>/dev/null || true
    echo "   ✅ Installato in: $AU_DEST/Sculpt.component"
    INSTALLED_ANY=1
else
    echo "ℹ️  [1/5] Sculpt.component non trovato (saltato)."
fi
echo ""

# ----------------------------------------------------------
# 2. Installazione VST3 (Ableton, Cubase, Reaper, Studio One, etc.)
# ----------------------------------------------------------
VST3_SRC="$SCRIPT_DIR/Sculpt.vst3"
if [ ! -d "$VST3_SRC" ]; then VST3_SRC="$SCRIPT_DIR/build/plugin/Sculpt_artefacts/Release/VST3/Sculpt.vst3"; fi
VST3_DEST="$HOME/Library/Audio/Plug-Ins/VST3"

if [ -d "$VST3_SRC" ]; then
    echo "📦 [2/5] Installazione VST3..."
    mkdir -p "$VST3_DEST"
    rm -rf "$VST3_DEST/Sculpt.vst3"
    cp -R "$VST3_SRC" "$VST3_DEST/"
    xattr -cr "$VST3_DEST/Sculpt.vst3" 2>/dev/null || true
    echo "   ✅ Installato in: $VST3_DEST/Sculpt.vst3"
    INSTALLED_ANY=1
else
    echo "ℹ️  [2/5] Sculpt.vst3 non trovato (saltato)."
fi
echo ""

# ----------------------------------------------------------
# 3. Installazione CLAP (Bitwig, REAPER, etc.)
# ----------------------------------------------------------
CLAP_SRC="$SCRIPT_DIR/Sculpt.clap"
if [ ! -d "$CLAP_SRC" ] && [ ! -f "$CLAP_SRC" ]; then CLAP_SRC="$SCRIPT_DIR/build/plugin/Sculpt_artefacts/Release/CLAP/Sculpt.clap"; fi
CLAP_DEST="$HOME/Library/Audio/Plug-Ins/CLAP"

if [ -e "$CLAP_SRC" ]; then
    echo "📦 [3/5] Installazione CLAP..."
    mkdir -p "$CLAP_DEST"
    rm -rf "$CLAP_DEST/Sculpt.clap"
    cp -R "$CLAP_SRC" "$CLAP_DEST/"
    xattr -cr "$CLAP_DEST/Sculpt.clap" 2>/dev/null || true
    echo "   ✅ Installato in: $CLAP_DEST/Sculpt.clap"
    INSTALLED_ANY=1
else
    echo "ℹ️  [3/5] Sculpt.clap non trovato (saltato)."
fi
echo ""

# ----------------------------------------------------------
# 4. Installazione AAX (Avid Pro Tools)
# ----------------------------------------------------------
AAX_SRC="$SCRIPT_DIR/Sculpt.aaxplugin"
if [ ! -d "$AAX_SRC" ]; then AAX_SRC="$SCRIPT_DIR/build/plugin/Sculpt_artefacts/Release/AAX/Sculpt.aaxplugin"; fi
AAX_DEST="/Library/Application Support/Avid/Audio/Plug-Ins"

if [ -d "$AAX_SRC" ]; then
    echo "📦 [4/5] Installazione AAX (Pro Tools)..."
    echo "   (La cartella Avid di sistema richiede privilegi amministratore):"
    sudo mkdir -p "$AAX_DEST"
    sudo rm -rf "$AAX_DEST/Sculpt.aaxplugin"
    sudo cp -R "$AAX_SRC" "$AAX_DEST/"
    sudo xattr -cr "$AAX_DEST/Sculpt.aaxplugin" 2>/dev/null || true
    echo "   ✅ Installato in: $AAX_DEST/Sculpt.aaxplugin"
    INSTALLED_ANY=1
else
    echo "ℹ️  [4/5] Sculpt.aaxplugin non trovato (saltato)."
fi
echo ""

# ----------------------------------------------------------
# 5. Installazione Standalone (.app)
# ----------------------------------------------------------
APP_SRC="$SCRIPT_DIR/Sculpt.app"
if [ ! -d "$APP_SRC" ]; then APP_SRC="$SCRIPT_DIR/build/plugin/Sculpt_artefacts/Release/Standalone/Sculpt.app"; fi
APP_DEST="/Applications"

if [ -d "$APP_SRC" ]; then
    echo "📦 [5/5] Installazione Applicazione Standalone..."
    rm -rf "$APP_DEST/Sculpt.app"
    cp -R "$APP_SRC" "$APP_DEST/"
    xattr -cr "$APP_DEST/Sculpt.app" 2>/dev/null || true
    echo "   ✅ Installato in: $APP_DEST/Sculpt.app"
    INSTALLED_ANY=1
else
    echo "ℹ️  [5/5] Sculpt.app non trovato (saltato)."
fi
echo ""

# ----------------------------------------------------------
# Riepilogo e istruzioni DAW
# ----------------------------------------------------------
echo "========================================================"
if [ $INSTALLED_ANY -eq 1 ]; then
    echo "🎉 Installazione completata con successo!"
    echo ""
    echo "Prossimi passi per la tua DAW:"
    echo "• Logic Pro / GarageBand: Preferences → Plug-In Manager → Full AudioUnit Reset"
    echo "• Ableton Live: Preferences → Plug-ins → Rescan"
    echo "• Bitwig / REAPER: Rescan VST3 / CLAP plugins"
    echo "• Cubase / Studio One: Rescan VST3 plugins"
    echo "• Pro Tools: Riavvia Pro Tools"
else
    echo "⚠️  Nessun plugin trovato da installare."
    echo "Assicurati di aver estratto l'intero pacchetto zip o compilato il progetto."
fi
echo "========================================================"
echo ""
read -p "Premi Invio per chiudere questa finestra..."
