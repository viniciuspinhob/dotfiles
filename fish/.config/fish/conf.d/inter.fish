# Inter-specific configurations
# Corporate network and internal tools

# AWS Certificate for corporate network
set -gx AWS_CA_BUNDLE "/Users/Shared/aws_crt/Zscaler_root.crt"

# IAC tool
set -gx PATH "$HOME/.iac/bin" $PATH

# Nexus/PyPI configurations
set -gx PIP_EXTRA_INDEX_URL "https://nexus.sharedservices.local/repository/python-releases/simple https://nexus.sharedservices.local/repository/python/simple/"
set -gx PIP_TRUSTED_HOST "nexus.sharedservices.local"
set -gx PIPX_PIP_ARGS "--extra-index-url https://nexus.sharedservices.local/repository/python-releases/simple --extra-index-url https://nexus.sharedservices.local/repository/python/simple/ --trusted-host nexus.sharedservices.local"

# Rancher Desktop PATH
set --export --prepend PATH "/Users/bi011312/.rd/bin"
# opencode
fish_add_path /Users/bi011312/.opencode/bin
