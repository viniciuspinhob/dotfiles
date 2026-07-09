# TMUX auto-start: attach, restore snapshot, or bootstrap GERAL
if not set -q TMUX; and isatty
    if not command -v tmux >/dev/null 2>&1
        echo "tmux not found. Skipping auto-start."
        return
    end

    set -l _dotfiles "$DOTFILES"
    test -z "$_dotfiles"; and set _dotfiles ~/Developer/dotfiles

    exec bash $_dotfiles/scripts/tmux/auto-start.sh
end
