" Plugin definitions and their initial setup
" Make sure Vim-Plug is installed:
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.config/nvim/plugged')

" Colorscheme
Plug 'morhetz/gruvbox'

" LSP Client -> not set
" Plug 'autozimu/LanguageClient-neovim', {
"  \ 'branch': 'next',
"  \ 'do': 'bash install.sh',
"  \ }

" Autocompletion and IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" Debugging tools
Plug 'puremourning/vimspector'

call plug#end() " This line *must* be here to load the plugins and set runtime paths.

" --- Plugin-specific configuration (after plugins are loaded) ---
" These configurations need to be here, *after* call plug#end(),
" so the plugins they configure are already available.

" telescope fzy native
lua << EOF
require('telescope').load_extension('fzy_native')
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

" debugging
let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']