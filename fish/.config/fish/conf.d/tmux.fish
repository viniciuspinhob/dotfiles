# TMUX auto-start configuration
# Automatically attach to existing session or create GERAL session with 3 windows
# Only run if not already in TMUX and terminal is interactive
if not set -q TMUX; and isatty
    # Try to get existing sessions
    set -l existing_sessions (tmux list-sessions -F '#S' 2>/dev/null)
    
    # If sessions exist, attach to first one
    if test -n "$existing_sessions"
        set -l first_session (echo $existing_sessions | head -n 1)
        exec tmux attach-session -t "$first_session"
    else
        # No sessions exist - create GERAL session with 3 windows
        # Verify paths exist
        set -l dotfiles_path ~/Developer/dotfiles
        set -l obsidian_path ~/Documents/obsidian
        set -l downloads_path ~/Downloads
        
        if not test -d $obsidian_path
            set obsidian_path ~/Documents
        end
        
        # Create GERAL session with 3 windows
        tmux new-session -d -s GERAL -c $dotfiles_path -n dotfiles
        tmux new-window -t GERAL -c $obsidian_path -n notes  
        tmux new-window -t GERAL -c $downloads_path -n downloads
        
        # Go back to first window
        tmux select-window -t GERAL:1
        
        # Attach to the session
        exec tmux attach-session -t GERAL
    end
end
