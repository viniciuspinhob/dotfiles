### Managed Configurations ###

# Initializes the Starship prompt, making the shell prompt customizable.
# eval "$(starship init zsh)"

# Adds the Rancher Desktop binary directory to the PATH, allowing its commands to be used.
export PATH="/$HOME/.rd/bin:$PATH"

# Adds the Node.js 22 binary directory to the PATH.
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@22/include"

# Sets the SDKMAN_DIR environment variable to the installation path of SDKMAN.
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Sources the Zsh completion script for kubectl, if the command is available.
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Export PATHs
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
