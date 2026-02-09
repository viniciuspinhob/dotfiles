# Fish Shell Configuration

# Set shell variable
set -gx SHELL (which fish)

# Modular structure
# Files in conf.d are sourced automatically.
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/bi011312/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# opencode
fish_add_path /Users/bi011312/.opencode/bin
