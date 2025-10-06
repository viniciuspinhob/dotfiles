# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    zsh-autocomplete
    kubectl
	)

source $ZSH/oh-my-zsh.sh

# User configuration

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/viniciuspinhob/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="/opt/homebrew/bin:$PATH"

source ~/Developer/dotfiles/zsh/aliases.zsh
