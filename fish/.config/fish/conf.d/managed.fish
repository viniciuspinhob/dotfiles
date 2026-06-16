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
set -gx SDKMAN_DIR "$HOME/.sdkman"

# asdf Java - sets JAVA_HOME automatically
. ~/.asdf/plugins/java/set-java-home.fish

# asdf spark
set -gx SPARK_HOME (asdf where spark)
set -gx PATH $SPARK_HOME/bin $PATH
