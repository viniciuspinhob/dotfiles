#!/bin/bash

# Configuring MacOS Dock

# 1. Set orientation left
defaults write com.apple.dock orientation -string "left"

# 2. Enable autohide
defaults write com.apple.dock autohide -bool true

# 3. Set dock icon to max size
defaults write com.apple.dock tilesize -int 128

# 4. Restart dock 
killall Dock
