#!/bin/bash

# Set MacOS Appearance

# Set accent color to green
defaults write -g AppleAccentColor -int 3

# Set Appearance to auto
defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true

killall cfprefsd
