#!/usr/bin/env bash
# Saves all tmux sessions to a JSON snapshot in the dotfiles repo.
#
# Limitations:
# - Does not save running processes inside panes
# - Layout may vary slightly between tmux versions
# - Delete .session-snapshot manually to reset to the default bootstrap layout

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

SNAPSHOT="$TMUX_SNAPSHOT"
TMP="${SNAPSHOT}.tmp"

if ! tmux list-sessions &>/dev/null; then
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
done < <(tmux list-sessions -F '#{session_name} #{session_attached}')

if [[ -z "$active_session" ]]; then
    active_session=$(tmux list-sessions -F '#{session_name}|#{session_last_attached}' \
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

        active_window=$(tmux list-windows -t "$session" -F '#{window_index}|#{window_active}' \
            | awk -F'|' '$2==1{print $1; exit}')
        [[ -z "$active_window" ]] && active_window=1

        printf '    {\n'
        printf '      "name": "%s",\n' "$(json_escape "$session")"
        printf '      "active_window": %s,\n' "$active_window"
        printf '      "windows": [\n'

        first_window=true
        while IFS='|' read -r win_index win_name layout _win_active win_path; do
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
            printf '          "layout": "%s",\n' "$(json_escape "$layout")"
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
            done < <(tmux list-panes -t "${session}:${win_index}" -F '#{pane_index}|#{pane_current_path}')

            printf '\n          ]\n'
            printf '        }'
        done < <(tmux list-windows -t "$session" -F '#{window_index}|#{window_name}|#{window_layout}|#{window_active}|#{pane_current_path}')

        printf '\n      ]\n'
        printf '    }'
    done < <(tmux list-sessions -F '#{session_name}')

    printf '\n  ]\n'
    printf '}\n'
} > "$TMP"

mv "$TMP" "$SNAPSHOT"
