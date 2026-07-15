# Attach to tmux or restore the last snapshot (bootstrap only on first run)
if not set -q TMUX; and isatty
    if not command -v tmux >/dev/null 2>&1
        echo "tmux not found. Skipping auto-start." >&2
        return
    end

    set -l _dotfiles "$DOTFILES"
    test -z "$_dotfiles"; and set _dotfiles ~/Developer/dotfiles

    if not test -x "$_dotfiles/scripts/tmux/auto-start.sh"
        echo "tmux auto-start not found: $_dotfiles/scripts/tmux/auto-start.sh" >&2
        return
    end

    bash "$_dotfiles/scripts/tmux/auto-start.sh"
end
