# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
 	zsh-syntax-highlighting
  	zsh-autosuggestions
	thefuck
	)

source $ZSH/oh-my-zsh.sh

# User configuration

# Unix General
alias shn="sudo hostname -s 127.0.0.1"
alias cdd="cd  ~/Developer"
alias cddd="cd  ~/Developer/dede"
alias cdh="cd ~"
# Development
## Python
alias pyenv39="python3.9 -m venv .venv"
alias py39="python3.9"
alias pyenv="python3 -m venv .venv"
alias activate="source .venv/bin/activate"
alias rm_pycache="find . | grep -E '(/__pycache__$|\.pyc$|\.pyo$)' | xargs rm -rf"
# Git & code formating
alias run_flake8="python3 -m flake8 --exclude .git,cicd/,__pycache__,.hg,.mypy_cache,.tox,.venv,venv,_build,buck-out,build,dist --max-line-length 120"
alias pregit="gaa & pre-commit run"
alias gmj="gitmoji -c"
# Default Environment Variables
alias awsenvs="printenv | grep AWS"
alias sparkenvs="printenv | grep SPARK"
# Docker
alias d='docker'
# kubernets
alias k='kubectl'
alias kgp="kubectl get pods"
alias kconf_rancher="kubectl config use-context rancher-desktop"
alias kconf_uat2="kubectl config use-context arn:aws:eks:us-east-1:020162860002:cluster/EKSDT-UAT-CLUSTER-V2"
alias kconf_prd2="kubectl config use-context arn:aws:eks:sa-east-1:812128893680:cluster/EKSDT-PRD-CLUSTER-V2"
# Parquet cli
alias pq='parquet'
alias pqm='parquet meta'
alias pqh='parquet head'
# Tools
alias zup='source ~/.zshrc'
alias zconf='zed ~/.zshrc'
alias sconf='zed ~/.config/starship.toml'
alias toolbox='open ~/Developer/tools'
alias cdtoolbox='cd ~/Developer/tools'

source /Users/viniciuspinhob/.docker/init-zsh.sh || true # Added by Docker Desktop

eval "$(starship init zsh)"
eval $(thefuck --alias)

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/viniciuspinhob/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="/opt/homebrew/bin:$PATH"


