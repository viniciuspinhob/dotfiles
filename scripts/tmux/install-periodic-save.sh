#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

LABEL="com.tmux-save"
INTERVAL_SECONDS="${TMUX_SAVE_INTERVAL:-900}"
ACTION="${1:-install}"

usage() {
    cat <<EOF
Usage: $(basename "$0") [install|uninstall|status]

Installs a periodic tmux snapshot save (default: every ${INTERVAL_SECONDS}s).

Environment:
  DOTFILES              Dotfiles root (auto-detected when unset)
  TMUX_SAVE_INTERVAL    Save interval in seconds (default: 900)

Platform support:
  macOS   launchd user agent (~/.local/share/tmux-save/com.tmux-save.plist)
  Linux   systemd user timer, or crontab fallback
EOF
}

require_save_script() {
    if [[ ! -x "$SAVE_SCRIPT" ]]; then
        echo "Error: save script not found or not executable: $SAVE_SCRIPT" >&2
        exit 1
    fi
}

install_launchd() {
    local plist_dir="$HOME/.local/share/tmux-save"
    local plist_path="$plist_dir/${LABEL}.plist"
    local domain="gui/$(id -u)"

    mkdir -p "$plist_dir"
    cat >"$plist_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${SAVE_SCRIPT}</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>DOTFILES</key>
        <string>${DOTFILES_DIR}</string>
    </dict>
    <key>StartInterval</key>
    <integer>${INTERVAL_SECONDS}</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>/dev/null</string>
    <key>StandardErrorPath</key>
    <string>/dev/null</string>
</dict>
</plist>
EOF

    launchctl bootout "$domain" "$plist_path" 2>/dev/null || true
    launchctl bootout "$domain" "$SCRIPT_DIR/com.tmux-save.plist" 2>/dev/null || true
    launchctl bootstrap "$domain" "$plist_path"

    echo "Installed launchd agent: $plist_path"
    echo "Interval: ${INTERVAL_SECONDS}s"
}

uninstall_launchd() {
    local plist_dir="$HOME/.local/share/tmux-save"
    local plist_path="$plist_dir/${LABEL}.plist"
    local domain="gui/$(id -u)"

    launchctl bootout "$domain" "$plist_path" 2>/dev/null || true
    launchctl bootout "$domain" "$SCRIPT_DIR/com.tmux-save.plist" 2>/dev/null || true
    rm -f "$plist_path"
    echo "Removed launchd agent"
}

status_launchd() {
    local plist_path="$HOME/.local/share/tmux-save/${LABEL}.plist"
    launchctl print "gui/$(id -u)/${LABEL}" 2>/dev/null || {
        echo "launchd agent not loaded"
        [[ -f "$plist_path" ]] && echo "Plist exists at: $plist_path"
        return 1
    }
}

install_systemd() {
    local unit_dir="$HOME/.config/systemd/user"
    local service_path="$unit_dir/tmux-save.service"
    local timer_path="$unit_dir/tmux-save.timer"

    mkdir -p "$unit_dir"
    cat >"$service_path" <<EOF
[Unit]
Description=Save tmux session snapshot

[Service]
Type=oneshot
Environment=DOTFILES=${DOTFILES_DIR}
ExecStart=/bin/bash ${SAVE_SCRIPT}
EOF

    cat >"$timer_path" <<EOF
[Unit]
Description=Periodic tmux session save

[Timer]
OnBootSec=5min
OnUnitActiveSec=${INTERVAL_SECONDS}s
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now tmux-save.timer

    echo "Installed systemd user timer: tmux-save.timer"
    echo "Interval: ${INTERVAL_SECONDS}s"
}

uninstall_systemd() {
    systemctl --user disable --now tmux-save.timer 2>/dev/null || true
    rm -f "$HOME/.config/systemd/user/tmux-save.service" \
          "$HOME/.config/systemd/user/tmux-save.timer"
    systemctl --user daemon-reload 2>/dev/null || true
    echo "Removed systemd user timer"
}

status_systemd() {
    systemctl --user status tmux-save.timer --no-pager 2>/dev/null || {
        echo "systemd timer not active"
        return 1
    }
}

cron_marker="# tmux-save (managed by dotfiles)"
cron_line="*/$((INTERVAL_SECONDS / 60)) * * * * DOTFILES=${DOTFILES_DIR} /bin/bash ${SAVE_SCRIPT} ${cron_marker}"

install_cron() {
    if ((INTERVAL_SECONDS % 60 != 0)); then
        echo "Error: cron fallback requires interval in whole minutes" >&2
        exit 1
    fi

    local current
    current="$(crontab -l 2>/dev/null || true)"
    current="$(printf '%s\n' "$current" | grep -Fv "$cron_marker" || true)"
    printf '%s\n%s\n' "$current" "$cron_line" | sed '/^$/d' | crontab -

    echo "Installed crontab entry (every $((INTERVAL_SECONDS / 60)) min)"
}

uninstall_cron() {
    local current
    current="$(crontab -l 2>/dev/null || true)"
    if [[ -z "$current" ]]; then
        return 0
    fi
    printf '%s\n' "$current" | grep -Fv "$cron_marker" | sed '/^$/d' | crontab - 2>/dev/null || true
    echo "Removed crontab entry"
}

status_cron() {
    crontab -l 2>/dev/null | grep -F "$cron_marker" || {
        echo "crontab entry not found"
        return 1
    }
}

detect_platform() {
    case "$(uname -s)" in
        Darwin) echo "launchd" ;;
        Linux)
            if command -v systemctl &>/dev/null && systemctl --user --version &>/dev/null 2>&1; then
                echo "systemd"
            elif command -v crontab &>/dev/null; then
                echo "cron"
            else
                echo "unsupported"
            fi
            ;;
        *) echo "unsupported" ;;
    esac
}

main() {
    case "$ACTION" in
        install|uninstall|status) ;;
        -h|--help|help) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac

    require_save_script

    local platform
    platform="$(detect_platform)"

    if [[ "$platform" == "unsupported" ]]; then
        echo "Error: no supported scheduler found on this platform" >&2
        exit 1
    fi

    case "$platform:$ACTION" in
        launchd:install) install_launchd ;;
        launchd:uninstall) uninstall_launchd ;;
        launchd:status) status_launchd ;;
        systemd:install) install_systemd ;;
        systemd:uninstall) uninstall_systemd ;;
        systemd:status) status_systemd ;;
        cron:install) install_cron ;;
        cron:uninstall) uninstall_cron ;;
        cron:status) status_cron ;;
    esac
}

main "$@"
