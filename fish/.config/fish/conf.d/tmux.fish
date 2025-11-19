# TMUX auto-start configuration
# Automatically attach to existing session or create new one

# Only run if not already in TMUX and terminal is interactive
if not set -q TMUX; and isatty
    # Try to get existing session
    set -l existing_session (tmux list-sessions -F '#S' 2>/dev/null | head -n 1)

    # If session exists, attach to it
    if test -n "$existing_session"
        exec tmux attach-session -t "$existing_session"
    else
        # Otherwise create new session
        exec tmux new-session
    end
end
