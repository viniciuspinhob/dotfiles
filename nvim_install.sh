#!/bin/bash

# Neovim Configuration Installer Script
# This script sets up Neovim with your custom configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS. Exiting."
        exit 1
    fi
}

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed. Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    print_success "Homebrew is installed"
}

# Check if Neovim is installed
check_neovim() {
    if ! command -v nvim &> /dev/null; then
        print_status "Neovim not found. Installing via Homebrew..."
        brew install neovim
        print_success "Neovim installed"
    else
        print_success "Neovim is already installed"
    fi
}

# Install Node.js (required for CoC plugin)
install_nodejs() {
    if ! command -v node &> /dev/null; then
        print_status "Node.js not found. Installing via Homebrew..."
        brew install node
        print_success "Node.js installed"
    else
        print_success "Node.js is already installed"
    fi
}

# Set up configuration symlink
setup_config_symlink() {
    local config_dir="$HOME/.config/nvim"
    local dotfiles_config="$HOME/Developer/dotfiles/nvim/.config/nvim"
    
    # Check if dotfiles config exists
    if [[ ! -d "$dotfiles_config" ]]; then
        print_error "Dotfiles config not found at: $dotfiles_config"
        print_error "Make sure your dotfiles are in ~/Developer/dotfiles/nvim/.config/nvim/"
        exit 1
    fi
    
    # Remove existing config if it exists
    if [[ -e "$config_dir" ]]; then
        print_warning "Existing Neovim config found. Backing up to ~/.config/nvim.backup"
        mv "$config_dir" "$config_dir.backup"
    fi
    
    # Create symlink
    print_status "Creating symlink to dotfiles config..."
    ln -s "$dotfiles_config" "$config_dir"
    print_success "Configuration symlink created"
}

# Install Vim-Plug
install_vim_plug() {
    local plug_file="$HOME/.local/share/nvim/site/autoload/plug.vim"
    
    if [[ -f "$plug_file" ]]; then
        print_success "Vim-Plug is already installed"
        return
    fi
    
    print_status "Installing Vim-Plug..."
    curl -fLo "$plug_file" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    print_success "Vim-Plug installed"
}

# Install Neovim plugins
install_plugins() {
    print_status "Installing Neovim plugins..."
    nvim --headless +PlugInstall +qall
    print_success "Plugins installed"
}

# Run health check
run_health_check() {
    print_status "Running Neovim health check..."
    nvim --headless +checkhealth +qall > /tmp/nvim_health.log 2>&1
    
    if grep -q "ERROR" /tmp/nvim_health.log; then
        print_warning "Some health check issues found. Check /tmp/nvim_health.log for details"
    else
        print_success "Health check passed"
    fi
}

# Main installation function
main() {
    echo "🚀 Neovim Configuration Installer"
    echo "================================="
    echo
    
    check_os
    check_homebrew
    check_neovim
    install_nodejs
    setup_config_symlink
    install_vim_plug
    install_plugins
    run_health_check
    
    echo
    print_success "🎉 Neovim setup complete!"
    echo
    echo "Next steps:"
    echo "  • Run 'nvim' to start using your configured Neovim"
    echo "  • Your leader key is set to <Space>"
    echo "  • Use <Space>ff to find files with Telescope"
    echo "  • Use <Space>fg to live grep with Telescope"
    echo "  • Run ':checkhealth' inside Neovim to verify everything is working"
    echo
}

# Run the installer
main "$@"

