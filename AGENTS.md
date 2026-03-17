# AGENTS.md - Dotfiles Repository Guide

This is a GNU Stow-managed dotfiles repository for macOS. It contains configuration
files for terminal tools, editors, and window management.

## Repository Structure

```
dotfiles/
├── <package>/           # Stow package (e.g., nvim, fish, tmux)
│   └── .config/         # Mirrors target structure from $HOME
│       └── <app>/       # Application config directory
├── scripts/             # Setup and utility scripts (not stowed)
└── docs/                # Documentation (not stowed)
```

## Build/Lint/Test Commands

This repository contains configuration files only - no build system or tests.

### Stow Commands

```bash
# Install a package (create symlinks from $HOME)
cd ~/Developer/dotfiles && stow -t $HOME <package>

# Remove a package
cd ~/Developer/dotfiles && stow -D -t $HOME <package>

# Re-stow (remove then install)
cd ~/Developer/dotfiles && stow -R -t $HOME <package>

# Add new dotfile to repository (uses helper script)
./scripts/stow/stow_files.sh ~/.config/newapp newapp
```

### Neovim Plugin Management

```vim
:PlugInstall    " Install plugins
:PlugUpdate     " Update plugins
:PlugClean      " Remove unused plugins
:TSUpdate       " Update Treesitter parsers
:Mason          " Manage LSP servers
```

### Shell Configuration Reload

```bash
# Fish
source ~/.config/fish/config.fish

# Zsh
source ~/.zshrc

# Tmux
tmux source-file ~/.tmux.conf
# Or inside tmux: prefix + r
```

## Code Style Guidelines

### General Principles

- Use Gruvbox dark color scheme consistently across all tools
- Keep configurations modular and well-organized
- Comment sparingly - only for non-obvious settings
- Prefer 4-space indentation (except TOML which uses 2)

### VimScript (.vim files)

```vim
" Use double quotes for comments
let g:variable_name = 'value'    " Single quotes for strings
set option=value                  " No spaces around =

" Keymaps use descriptive comments
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>

" Lua blocks for complex logic
lua << EOF
require('plugin').setup({})
EOF
```

### Lua (nvim/lua/*.lua)

```lua
-- Single-line comment style
local module = require("module-name")

-- Setup pattern
require("plugin").setup({
  option = value,
  nested = {
    key = "value",
  },
})

-- Keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

-- Autocmds
vim.api.nvim_create_autocmd('Event', {
  group = vim.api.nvim_create_augroup('group-name', { clear = true }),
  callback = function(args)
    -- handler
  end,
})
```

### Fish Shell (.fish files)

```fish
# Comment style
set -gx VARIABLE "value"           # Global exported variable
set -l local_var "value"           # Local variable

# Function definition
function function_name
    if test (count $argv) -eq 0
        echo "Usage: function_name <arg>"
        return 1
    end
    # logic here
end

# Aliases
alias short="long command"
```

### Zsh/Bash (.zsh, .sh files)

```bash
#!/bin/bash

# Variables
VARIABLE="value"
export EXPORTED_VAR="value"

# Functions
function_name() {
    if [[ -n "$1" ]]; then
        echo "Argument: $1"
    else
        echo "Usage: function_name <arg>"
        return 1
    fi
}

# Aliases
alias short="long command"

# Associative arrays (zsh)
typeset -A array_name
array_name=(
    [key1]="value1"
    [key2]="value2"
)
```

### Python (ranger colorschemes/commands)

```python
from ranger.gui.color import *
from ranger.colorschemes.default import Default

class Scheme(Default):
    progress_bar_color = 106  # Gruvbox green

    def use(self, context):
        fg, bg, attr = Default.use(self, context)
        # Custom logic
        return (fg, bg, attr)
```

### TOML Configuration Files

```toml
# Section header
[section]
key = "value"
number = 42
boolean = true

# Nested sections
[section.subsection]
nested_key = "nested_value"

# Arrays
list = ["item1", "item2"]
```

## Gruvbox Color Reference

Use these colors consistently across all configurations:

| Color   | Hex       | ANSI | Usage                    |
|---------|-----------|------|--------------------------|
| bg0     | `#1d2021` | 235  | Background (hard)        |
| bg      | `#282828` | 236  | Background (normal)      |
| fg      | `#ebdbb2` | 223  | Foreground               |
| red     | `#cc241d` | 124  | Errors, deletions        |
| green   | `#98971a` | 106  | Success, additions       |
| yellow  | `#d79921` | 172  | Warnings, directories    |
| blue    | `#458588` | 109  | Info, links              |
| purple  | `#b16286` | 132  | Special                  |
| aqua    | `#689d6a` | 108  | Strings                  |
| orange  | `#d65d0e` | 166  | Modified                 |
| gray    | `#928374` | 245  | Comments                 |

## File Organization

### Adding New Application Config

1. Create package directory: `mkdir -p <package>/.config/<app>`
2. Move config: `mv ~/.config/<app>/* <package>/.config/<app>/`
3. Stow package: `stow -t $HOME <package>`
4. Commit changes

### Neovim Structure

```
nvim/.config/nvim/
├── init.vim           # Entry point, loads other files
├── basics.vim         # Core settings
├── colors.vim         # Colorscheme setup
├── maps.vim           # Key mappings
├── plug.vim           # Plugin definitions + config
├── scripts.vim        # Custom scripts
└── lua/plugins/       # Lua plugin configurations
    ├── init.lua       # Loads all Lua modules
    ├── lsp-config.lua
    ├── completion-setup.lua
    └── ...
```

### Shell Config Structure

- `config.fish` / `.zshrc`: Entry point, sources modular files
- `conf.d/*.fish` / `*.zsh`: Modular configs (aliases, functions, theme)
- Functions should be in dedicated files or sections

## Key Mappings Convention

- **Leader key**: Space (` `)
- **Vim navigation**: hjkl pattern used in tmux, aerospace, nvim
- **Prefix patterns**:
  - `<leader>f*`: File/find operations (telescope)
  - `<leader>d*`: Debugging (dap)
  - `<leader>t*`: Tab management
  - `<leader>s/v`: Split horizontal/vertical

## Error Handling

### Shell Scripts

```bash
command || { echo "Error: command failed"; exit 1; }
```

### Fish Functions

```fish
if not command
    echo "Error message"
    return 1
end
```

## Important Notes

- Never commit sensitive data (credentials, API keys)
- Files in `.gitignore`: `*.pyc`, `__pycache__/`, `.DS_Store`, `plugged/`
- Files in `.stow-local-ignore` are not symlinked
- The `scripts/` directory contains setup helpers, not stowed configs
