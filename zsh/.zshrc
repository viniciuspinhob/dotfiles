# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
	git
 	zsh-syntax-highlighting
  	zsh-autosuggestions
	thefuck
	)

source $ZSH/oh-my-zsh.sh

# User configuration


source /Users/viniciuspinhob/.docker/init-zsh.sh || true # Added by Docker Desktop


eval $(thefuck --alias)

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/viniciuspinhob/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="/opt/homebrew/bin:$PATH"

source ~/Developer/dotfiles/zsh/aliases.zsh

