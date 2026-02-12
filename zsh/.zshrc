# Path to Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-autocomplete
    kubectl
	)

source $ZSH/oh-my-zsh.sh

### My Custom Dotfiles ###
source ~/Developer/dotfiles/zsh/managed.zsh
source ~/Developer/dotfiles/zsh/aliases.zsh
source ~/Developer/dotfiles/zsh/functions.zsh
# source ~/Developer/dotfiles/zsh/tmux.zsh
source ~/Developer/dotfiles/zsh/theme.zsh
source ~/Developer/dotfiles/zsh/inter.zsh

export PATH="/Users/bi011312/.local/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/bi011312/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
