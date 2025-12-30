" Plugin definitions and their initial setup
" Make sure Vim-Plug is installed:
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.config/nvim/plugged')

" Colorscheme
Plug 'morhetz/gruvbox'

" LSP Configuration
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Snippet engine (required for nvim-cmp)
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Auto pairs (parentheses, quotes, brackets)
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Interactive code execution
Plug 'jpalardy/vim-slime'

" Status line
Plug 'itchyny/lightline.vim'

" Asynchronous Lint Engine
Plug 'dense-analysis/ale'

" Personal Wiki
Plug 'vimwiki/vimwiki'

" TODO Comments
Plug 'folke/todo-comments.nvim'

" Syntax Highlighting (Treesitter)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Telescope requirements
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Folder structure
Plug 'nvim-tree/nvim-tree.lua'

" View buffers
Plug 'akinsho/bufferline.nvim'
" For nice icons
Plug 'nvim-tree/nvim-web-devicons' 

" Debugging tools (nvim-dap - não requer Python3+ compilado no Neovim)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-neotest/nvim-nio'
Plug 'mfussenegger/nvim-dap-python'

" Toggle comments
Plug 'numToStr/Comment.nvim'

" Markdown Rendering
Plug 'MeanderingProgrammer/render-markdown.nvim'

" Git viewer on file
Plug 'lewis6991/gitsigns.nvim'

"undotree 
Plug 'mbbill/undotree'

call plug#end() " This line *must* be here to load the plugins and set runtime paths.
" --- Plugin-specific configuration (after plugins are loaded) ---
" These configurations need to be here, *after* call plug#end(),
" so the plugins they configure are already available.

" Python LSP
" let g:coc_global_extensions = ['coc-pyright']
" Load LSP configuration
lua << EOF
require('plugins.lsp-config')
require('plugins.autopairs-config')
require('plugins.completion-setup')
EOF
" lua << EOF
" require('lsp-setup')
" require('completion-setup')
" EOF

" telescope fzy native
lua << EOF
require('telescope').load_extension('fzy_native')
EOF

"Telescope hidden files
lua << EOF
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {"node_modules", ".git/", ".venv/", ".env/"},
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
    },
  },
  pickers = {
    find_files = {
      hidden = true
    }
  }
}
EOF

" todo-comments.nvim setup
lua << EOF
require('todo-comments').setup {}
EOF

" Vim-slime
let g:slime_target = "tmux"

" nertw as NERDtree style
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" nvim-tree
lua << EOF
-- setup nvim-tree
require("nvim-tree").setup()

-- setup keymap to toggle nvim-tree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
EOF
autocmd TabNewEntered * NvimTreeOpen

" view buffers
lua << EOF
require("bufferline").setup({})
EOF

" Toggle comments
lua << EOF
require('Comment').setup()
EOF

" nvim-dap configuration (loaded after plugins)
lua << EOF
require('plugins.dap-config')
EOF

" Git viwer
lua << EOF
require('gitsigns').setup()
EOF
