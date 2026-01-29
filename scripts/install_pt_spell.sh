#!/usr/bin/env bash
# Download Portuguese (pt) spell file for Neovim so spelllang=en_us,pt_br works
# without the "No spell file for pt" prompt. Run once.

set -e
SPELL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/spell"
URL="https://ftp.nluug.nl/vim/runtime/spell/pt.utf-8.spl"

mkdir -p "$SPELL_DIR"
echo "Downloading Portuguese spell file to $SPELL_DIR ..."
curl -fSL -o "$SPELL_DIR/pt.utf-8.spl" "$URL"
echo "Done. Restart Neovim; pt_br spell check will work without the download prompt."
