#!/bin/bash

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install packages

# CLI tools / Code 
brew install neovim fzf ranger bat fish stow tmux
brew install --cask alacritty # deprecated
brew install --cask visual-studio-code
brew install --cask rancher

# Customizations
brew install --cask nikitabobko/tap/aerospace
brew install --cask monitorcontrol
brew install --cask logi-options+