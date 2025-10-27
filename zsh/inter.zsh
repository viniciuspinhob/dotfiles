## Inter configs

# Export a trusted root certificate for AWS services, likely for corporate network access.
export AWS_CA_BUNDLE="/Users/Shared/aws_crt/Zscaler_root.crt"
# Adds the bin directory for an "IAC" (Infrastructure as Code) tool to the PATH.
export PATH=$PATH:$HOME/.iac/bin

# configs do nexus pro pip
export PIP_EXTRA_INDEX_URL="https://nexus.sharedservices.local/repository/python-releases/simple https://nexus.sharedservices.local/repository/python/simple/"
export PIP_TRUSTED_HOST="nexus.sharedservices.local"
export PIPX_PIP_ARGS="--extra-index-url https://nexus.sharedservices.local/repository/python-releases/simple --extra-index-url https://nexus.sharedservices.local/repository/python/simple/ --trusted-host nexus.sharedservices.local"
