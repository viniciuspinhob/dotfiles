## Inter configs

# Export a trusted root certificate for AWS services, likely for corporate network access.
export AWS_CA_BUNDLE="/Users/Shared/aws_crt/Zscaler_root.crt"
# Adds the bin directory for an "IAC" (Infrastructure as Code) tool to the PATH.
export PATH=$PATH:$HOME/.iac/bin
