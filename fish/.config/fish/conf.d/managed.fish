# Managed Configurations
# External tools and PATH configurations

# Add local bin to PATH
set -gx PATH "$HOME/.local/bin" $PATH

# Add Homebrew to PATH
set -gx PATH "/opt/homebrew/bin" "/usr/local/bin" $PATH
set -gx PATH "/opt/homebrew/sbin" $PATH

# Node.js 22
set -gx PATH "/opt/homebrew/opt/node@22/bin" $PATH
set -gx LDFLAGS "-L/opt/homebrew/opt/node@22/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/node@22/include"

# SDKMAN (note: bash/zsh specific, won't work in fish)
# Consider using 'jabba' for Java version management in Fish
set -gx SDKMAN_DIR "$HOME/.sdkman"
