### Managed Configurations ###

# Export a trusted root certificate for AWS services, likely for corporate network access.
export AWS_CA_BUNDLE="/Users/Shared/aws_crt/Zscaler_root.crt"

# Initializes the Starship prompt, making the shell prompt customizable.
eval "$(starship init zsh)"

# Adds the Rancher Desktop binary directory to the PATH, allowing its commands to be used.
export PATH="/Users/fo126029/.rd/bin:$PATH"

# Sets up a trusted location for pipx to install applications.
export PATH="$PATH:~/.local/bin"

# Adds the Node.js 22 binary directory to the PATH.
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# Sets the linker flags for Node.js 22 to locate libraries.
export LDFLAGS="-L/opt/homebrew/opt/node@22/lib"

# Sets the C preprocessor flags for Node.js 22 to locate include files.
export CPPFLAGS="-I/opt/homebrew/opt/node@22/include"

# Adds the bin directory for an "IAC" (Infrastructure as Code) tool to the PATH.
export PATH=$PATH:$HOME/.iac/bin

# Sets the SDKMAN_DIR environment variable to the installation path of SDKMAN.
export SDKMAN_DIR="$HOME/.sdkman"

# Sources the SDKMAN initialization script if it exists.
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Sources the Zsh completion script for kubectl, if the command is available.
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
