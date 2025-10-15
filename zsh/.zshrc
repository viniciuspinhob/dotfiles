# Path to Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    zsh-autocomplete
    kubectl
	)

source $ZSH/oh-my-zsh.sh

### My Custom Dotfiles ###
source ~/Developer/dotfiles/zsh/managed.zsh
source ~/Developer/dotfiles/zsh/aliases.zsh
source ~/Developer/dotfiles/zsh/functions.zsh
source ~/Developer/dotfiles/zsh/inter.zsh
