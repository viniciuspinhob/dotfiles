#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

SNAPSHOT="$TMUX_SNAPSHOT"

if [[ -n "${TMUX:-}" ]]; then
    exit 0
fi

if ! command -v tmux &>/dev/null; then
    echo "tmux not found. Skipping auto-start." >&2
    exit 1
fi

read_active_session() {
    if [[ -f "$SNAPSHOT" ]]; then
        python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get('active_session',''))" "$SNAPSHOT" 2>/dev/null || true
    fi
}

attach_session() {
    local preferred="${1:-}"

    if [[ -n "$preferred" ]] && tmux has-session -t "$preferred" 2>/dev/null; then
        exec tmux attach-session -d -t "$preferred"
    fi

    if tmux has-session -t GERAL 2>/dev/null; then
        exec tmux attach-session -d -t GERAL
    fi

    exec tmux attach-session -d
}

if tmux has-session 2>/dev/null; then
    attach_session "$(read_active_session)"
fi

if [[ -f "$SNAPSHOT" ]]; then
    if bash "$DOTFILES_DIR/scripts/tmux/restore-session.sh"; then
        attach_session "$(read_active_session)"
    fi

    echo "tmux: snapshot restore failed." >&2
    exit 1
fi

bash "$DOTFILES_DIR/scripts/tmux/bootstrap-geral.sh"
exec tmux attach-session -t GERAL
