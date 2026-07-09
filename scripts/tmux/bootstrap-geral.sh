#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

dotfiles_path="$DOTFILES_DIR"
home_path="$HOME"

notes_path="${TMUX_NOTES_DIR:-}"
if [[ -z "$notes_path" ]]; then
    for candidate in "$HOME/Documents/obsidian" "$HOME/Documents/notes" "$HOME/Documents"; do
        if [[ -d "$candidate" ]]; then
            notes_path="$candidate"
            break
        fi
    done
fi
[[ -z "$notes_path" ]] && notes_path="$HOME"

tmux new-session -d -s GERAL -c "$home_path" -n home
tmux new-window -t GERAL -c "$notes_path" -n notes
tmux new-window -t GERAL -c "$dotfiles_path" -n dotfiles
tmux select-window -t GERAL:1
