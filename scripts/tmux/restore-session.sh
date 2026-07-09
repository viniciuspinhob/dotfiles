#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

SNAPSHOT="$TMUX_SNAPSHOT"

if [[ ! -f "$SNAPSHOT" ]]; then
    echo "Snapshot not found: $SNAPSHOT" >&2
    exit 1
fi

if tmux has-session 2>/dev/null; then
    echo "Tmux server already has sessions; refusing to restore." >&2
    exit 1
fi

python3 - "$SNAPSHOT" <<'PY'
import json
import os
import subprocess
import sys

snapshot_path = sys.argv[1]
home = os.environ["HOME"]

with open(snapshot_path, encoding="utf-8") as handle:
    data = json.load(handle)

if data.get("version") != 1:
    sys.exit("Unsupported snapshot version")

sessions = data.get("sessions", [])
if not sessions:
    sys.exit("Snapshot has no sessions")


def resolve_path(path):
    return path if os.path.isdir(path) else home


def run(*args, check=True):
    result = subprocess.run(args, capture_output=True, text=True)
    if check and result.returncode != 0:
        message = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(f"{' '.join(args)} failed: {message}")
    return result


try:
    for session_index, session in enumerate(sessions):
        name = session["name"]
        windows = sorted(session.get("windows", []), key=lambda item: item["index"])
        if not windows:
            continue

        active_window = session.get("active_window", windows[0]["index"])
        active_window_name = next(
            (window["name"] for window in windows if window["index"] == active_window),
            windows[0]["name"],
        )

        for window_index, window in enumerate(windows):
            win_name = window.get("name", f"window-{window['index']}")
            win_path = resolve_path(window.get("path", home))
            target = f"{name}:{win_name}"

            if window_index == 0:
                run(
                    "tmux", "new-session", "-d",
                    "-s", name,
                    "-n", win_name,
                    "-c", win_path,
                )
            else:
                run(
                    "tmux", "new-window", "-t", name,
                    "-n", win_name,
                    "-c", win_path,
                )

            panes = sorted(window.get("panes", []), key=lambda item: item["index"])
            for pane in panes[1:]:
                pane_path = resolve_path(pane.get("path", home))
                run("tmux", "split-window", "-t", target, "-c", pane_path)

            layout = window.get("layout")
            if layout:
                run("tmux", "select-layout", "-t", target, layout, check=False)

        run("tmux", "select-window", "-t", f"{name}:{active_window_name}", check=False)
except RuntimeError as error:
    subprocess.run(["tmux", "kill-server"], capture_output=True)
    sys.exit(str(error))
PY
