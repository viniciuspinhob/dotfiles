#!/usr/bin/env bash

_tmux_scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resolve_dotfiles_dir() {
    if [[ -n "${DOTFILES:-}" ]]; then
        printf '%s\n' "$DOTFILES"
        return 0
    fi

    local candidate
    candidate="$(cd "$_tmux_scripts_dir/../.." && pwd)"
    if [[ -f "$candidate/AGENTS.md" ]]; then
        printf '%s\n' "$candidate"
        return 0
    fi

    printf '%s\n' "$HOME/Developer/dotfiles"
}

DOTFILES_DIR="$(resolve_dotfiles_dir)"
TMUX_SNAPSHOT="$DOTFILES_DIR/scripts/tmux/.session-snapshot"
SAVE_SCRIPT="$DOTFILES_DIR/scripts/tmux/save-session.sh"
