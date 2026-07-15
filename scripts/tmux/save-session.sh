#!/usr/bin/env bash
# Saves all tmux sessions to a JSON snapshot in the dotfiles repo.
#
# Limitations:
# - Does not save running processes inside panes
# - Does not save pane sizes or layout (adapts to current terminal on restore)
# - Auto-saved on window/pane changes via tmux hooks in .tmux.conf

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

SNAPSHOT="$TMUX_SNAPSHOT"
TMP="${SNAPSHOT}.tmp"

if [[ -f "$SAVE_SUSPEND_FILE" ]]; then
    exit 0
fi

resolve_tmux_bin() {
    local candidate

    if [[ -n "${TMUX_BIN:-}" && -x "${TMUX_BIN}" ]]; then
        printf '%s' "${TMUX_BIN}"
        return 0
    fi

    for candidate in /opt/homebrew/bin/tmux /usr/local/bin/tmux /usr/bin/tmux; do
        if [[ -x "$candidate" ]]; then
            printf '%s' "$candidate"
            return 0
        fi
    done

    if command -v tmux >/dev/null 2>&1; then
        command -v tmux
        return 0
    fi

    printf ''
}

resolve_tmux_socket() {
    local socket_dir="/private/tmp/tmux-$(id -u)"
    local from_tmux="${TMUX:-}"
    local candidate

    from_tmux="${from_tmux%%,*}"

    if [[ -n "${TMUX_SOCKET:-}" && -S "${TMUX_SOCKET}" ]]; then
        printf '%s' "${TMUX_SOCKET}"
        return 0
    fi

    if [[ -n "$from_tmux" && -S "$from_tmux" ]]; then
        printf '%s' "$from_tmux"
        return 0
    fi

    if [[ -S "${socket_dir}/default" ]]; then
        printf '%s' "${socket_dir}/default"
        return 0
    fi

    for candidate in "$socket_dir"/*; do
        if [[ -S "$candidate" ]]; then
            printf '%s' "$candidate"
            return 0
        fi
    done

    printf ''
}

TMUX_BIN="$(resolve_tmux_bin)"
[[ -z "$TMUX_BIN" ]] && exit 0

TMUX_SOCKET="$(resolve_tmux_socket)"

tmux_cmd() {
    if [[ -n "$TMUX_SOCKET" ]]; then
        "$TMUX_BIN" -S "$TMUX_SOCKET" "$@"
    else
        "$TMUX_BIN" "$@"
    fi
}

if ! tmux_cmd list-sessions &>/dev/null; then
    exit 0
fi

json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

saved_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

active_session=""
while IFS=' ' read -r name attached; do
    if [[ "${attached:-0}" -gt 0 ]]; then
        active_session="$name"
        break
    fi
done < <(tmux_cmd list-sessions -F '#{session_name} #{session_attached}')

if [[ -z "$active_session" ]]; then
    active_session=$(tmux_cmd list-sessions -F '#{session_name}|#{session_last_attached}' \
        | sort -t'|' -k2 -rn | head -1 | cut -d'|' -f1)
fi

mkdir -p "$(dirname "$SNAPSHOT")"

{
    printf '{\n'
    printf '  "version": 1,\n'
    printf '  "saved_at": "%s",\n' "$(json_escape "$saved_at")"
    printf '  "active_session": "%s",\n' "$(json_escape "$active_session")"
    printf '  "sessions": [\n'

    first_session=true
    while IFS= read -r session; do
        [[ -z "$session" ]] && continue

        if [[ "$first_session" == true ]]; then
            first_session=false
        else
            printf ',\n'
        fi

        active_window=$(tmux_cmd list-windows -t "$session" -F '#{window_index}|#{window_active}' \
            | awk -F'|' '$2==1{print $1; exit}')
        [[ -z "$active_window" ]] && active_window=1

        printf '    {\n'
        printf '      "name": "%s",\n' "$(json_escape "$session")"
        printf '      "active_window": %s,\n' "$active_window"
        printf '      "windows": [\n'

        first_window=true
        while IFS='|' read -r win_index win_name _layout _win_active win_path; do
            [[ -z "$win_index" ]] && continue

            if [[ "$first_window" == true ]]; then
                first_window=false
            else
                printf ',\n'
            fi

            printf '        {\n'
            printf '          "index": %s,\n' "$win_index"
            printf '          "name": "%s",\n' "$(json_escape "$win_name")"
            printf '          "path": "%s",\n' "$(json_escape "$win_path")"
            printf '          "panes": [\n'

            first_pane=true
            while IFS='|' read -r pane_index pane_path; do
                [[ -z "$pane_index" ]] && continue

                if [[ "$first_pane" == true ]]; then
                    first_pane=false
                else
                    printf ',\n'
                fi

                printf '            {"index": %s, "path": "%s"}' \
                    "$pane_index" "$(json_escape "$pane_path")"
            done < <(tmux_cmd list-panes -t "${session}:${win_index}" -F '#{pane_index}|#{pane_current_path}')

            printf '\n          ]\n'
            printf '        }'
        done < <(tmux_cmd list-windows -t "$session" -F '#{window_index}|#{window_name}|#{window_layout}|#{window_active}|#{pane_current_path}')

        printf '\n      ]\n'
        printf '    }'
    done < <(tmux_cmd list-sessions -F '#{session_name}')

    printf '\n  ]\n'
    printf '}\n'
} > "$TMP"

mv "$TMP" "$SNAPSHOT"
