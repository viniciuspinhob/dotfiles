# TMUX auto-start configuration
# Automatically attach to existing session or create GERAL session with 3 windows
# Only run if not already in TMUX and terminal is interactive
if not set -q TMUX; and isatty
    # Check if tmux is installed and available
    if not command -v tmux >/dev/null 2>&1
        echo "tmux not found. Skipping auto-start."
        return
    end
    
    # Check if GERAL session exists
    if tmux has-session -t GERAL 2>/dev/null
        # Session exists - attach to it
        tmux attach-session -d -t GERAL
    else
        # Session doesn't exist - create new GERAL session with 3 windows
        # Verify paths exist
        set -l dotfiles_path ~/Developer/dotfiles
        set -l obsidian_path ~/Documents/obsidian
        set -l home_path  ~/
        
        if not test -d $obsidian_path
            set obsidian_path ~/Documents
        end
        
        # Create GERAL session with first window (session must exist before new-window)
        tmux new-session -d -s GERAL -c $home_path -n home
        # Create additional windows
        tmux new-window -t GERAL -c $obsidian_path -n notes
        tmux new-window -t GERAL -c $dotfiles_path -n dotfiles
        
        # Start on first window
        tmux select-window -t GERAL:1
        
        # Attach to the newly created session
        tmux attach-session -t GERAL
    end
end
