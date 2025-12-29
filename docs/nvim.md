Neovim Commands Reference
This document lists essential Neovim commands, including standard ones and custom mappings identified from your configuration files (basics.vim, colors.vim, init.vim, maps.vim, plug.vim).

1. Standard Neovim Commands (Normal Mode)
Navigation

h, j, k, l: Move cursor (left, down, up, right)

w: Jump to the start of the next word

b: Jump to the start of the previous word

e: Jump to the end of the current word

0 or ^: Go to the beginning of the line

$: Go to the end of the line

gg: Go to the beginning of the file

G: Go to the end of the file

{number}gg or {number}G: Go to line {number}

%: Jump to the matching bracket (), [], {}

Ctrl-f: Scroll one page down

Ctrl-b: Scroll one page up

zz: Center the current line on the screen

zt: Place the current line at the top of the screen

zb: Place the current line at the bottom of the screen

Editing

i: Enter insert mode (before cursor)

a: Enter insert mode (after cursor)

o: Insert new line below and enter insert mode

O: Insert new line above and enter insert mode

x: Delete character under cursor

dd: Delete the current line

dw: Delete word

d$: Delete from cursor to end of line

yy: Yank (copy) the current line

yw: Yank word

y$: Yank from cursor to end of line

p: Paste after cursor (or line below)

P: Paste before cursor (or line above)

cc: Delete line and enter insert mode

cw: Delete word and enter insert mode

r: Replace a single character

s: Substitute a character and enter insert mode

u: Undo

Ctrl-r: Redo

.: Repeat the last command

J: Join the current line with the next

Visual Modes

v: Character visual mode (text selection)

V: Line visual mode (entire line selection)

Ctrl-v: Block visual mode (rectangular selection)

Once in a visual mode, use navigation commands to select text, then editing commands (d, y, c) to operate on the selection.

Search

/term: Search for term forwards

?term: Search for term backwards

n: Go to the next occurrence

N: Go to the previous occurrence

*: Search for the word under the cursor forwards

#: Search for the word under the cursor backwards

Windows (Splits)

:sp or :split: Split the window horizontally

:vs or :vsplit: Split the window vertically

Ctrl-w h: Move to the window on the left

Ctrl-w l: Move to the window on the right

Ctrl-w j: Move to the window below

Ctrl-w k: Move to the window above

Ctrl-w w or Ctrl-w Ctrl-w: Cycle through windows

Ctrl-w =: Make all windows equal size

Ctrl-w +: Increase current window height

Ctrl-w -: Decrease current window height

Ctrl-w >: Increase current window width

Ctrl-w <: Decrease current window width

:only: Close all other windows, keeping the current one

:close or :q: Close the current window

Buffers

:ls or :buffers: List all open buffers

:b {number}: Go to the buffer with {number}

:bnext or :bn: Go to the next buffer

:bprev or :bp: Go to the previous buffer

:bd: Close the current buffer (and the window if it's the last for that buffer)

Save and Quit

:w: Save the current file

:q: Quit the current window (or Neovim if it's the last window)

:wq: Save and quit

:x: Save and quit (only if changes were made)

:qa: Quit all windows

:wqa: Save and quit all windows

2. Custom Commands and Mappings (Your Configuration)
Your mapleader is set to <Space> (spacebar). All shortcuts starting with <leader> must be preceded by the spacebar.

Navigation and Editing

Y: Yanks (copies) text from the cursor to the end of the line (y$).

nzzzv: Navigates to the next search occurrence and centers the screen on the cursor.

Nzzzv: Navigates to the previous search occurrence and centers the screen on the cursor.

J (Normal Mode): Joins the current line with the next, keeping the cursor position.

, (Insert Mode): Inserts a comma and creates an "undo" breakpoint (<c-g>u).

. (Insert Mode): Inserts a period and creates an "undo" breakpoint (<c-g>u).

J (Visual Mode): Moves the selected line(s) one line down.

K (Visual Mode): Moves the selected line(s) one line up.

<C-j> (Insert Mode): Moves the current line one line down.

<C-k> (Insert Mode): Moves the current line one line up.

<leader>j: Moves the current line one line down.

<leader>k: Moves the current line one line up.

Autocompletion (CoC.nvim)

<TAB> (Insert Mode):

If the autocompletion popup window is visible, navigates to the next item.

Otherwise, if there's whitespace before the cursor, inserts a tab.

If no whitespace, tries to refresh CoC.nvim suggestions.

<S-TAB> (Insert Mode): If the autocompletion popup window is visible, navigates to the previous item. Otherwise, functions as backspace.

File and Content Search (Telescope.nvim)

<leader>fs: Searches for a string you type (grep string).

Usage: Press <Space>fs, then type your search term and Enter.

<leader>fw: Searches for the word under the cursor (grep word).

Usage: Position the cursor over a word and press <Space>fw.

<leader>ff: Searches for files (find files).

Usage: Press <Space>ff, then start typing the file name and Enter.

<leader>fg: Searches for a string in all files in the current directory (live grep).

Usage: Press <Space>fg, then type your search term and Enter.

<leader>fb: Lists and allows navigation through open buffers.

Usage: Press <Space>fb.

<leader>fh: Searches Neovim help tags.

Usage: Press <Space>fh, then type the help topic and Enter.

Debugging (nvim-dap)

<leader>dl: Starts/continues debugging session.

<leader>dr: Restarts the debugging session.

<leader>ds: Stops the debugging session.

<leader>db: Toggles a breakpoint at the current line.

<leader>dB: Sets a conditional breakpoint (asks for condition).

<leader>dp: Pauses the debugging session.

<leader>do: Steps over (next line).

<leader>di: Steps into (enters function).

<leader>du: Steps out (exits function).

<leader>de: Evaluates expression under cursor.

<leader>dw: Opens watches window.

<leader>dt: Toggles DAP UI.

3. Important Configurations and Plugins
basics.vim

set nocompatible: Disables vi compatibility mode.

filetype off, syntax on: File type management and syntax highlighting.

set guicursor=: Ensures the cursor shape doesn't change.

set termguicolors: Enables true colors in the terminal.

set relativenumber, set number: Displays relative and absolute line numbers.

set nohlsearch: Disables persistent search highlighting.

set hidden: Allows modified buffers to be in the background.

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab: Configures indentation to 4 spaces.

set smartindent: Smart indentation.

set noswapfile, set nobackup: Does not create swap or backup files.

set undodir=~/.vim/undodir, set undofile: Persists undo history.

set incsearch: Incremental search highlighting.

set scrolloff=8: Keeps 8 lines of context above and below the cursor when scrolling.

set noshowmode: Does not show the current mode in the status line (managed by Lightline).

set encoding=utf-8: Sets character encoding.

set clipboard=unnamedplus: Integrates with the system clipboard.

colors.vim

colorscheme gruvbox: Sets the Gruvbox color scheme.

set background=dark: Ensures the dark version of the theme.

let g:gruvbox_contrast_dark = 'hard': Configures Gruvbox contrast.

let g:lightline = { 'colorscheme': 'gruvbox' }: Configures Lightline to use the Gruvbox theme.

plug.vim (Installed Plugins)

morhetz/gruvbox: Color scheme.

neoclide/coc.nvim: Autocompletion and IDE features.

jpalardy/vim-slime: Interactive code execution (sends to tmux).

itchyny/lightline.vim: Customizable status line.

dense-analysis/ale: Asynchronous linter and fixer.

vimwiki/vimwiki: Personal wiki manager.

folke/todo-comments.nvim: Highlights TODO/FIXME comments.

nvim-treesitter/nvim-treesitter: Enhanced syntax highlighting.

nvim-lua/popup.nvim, nvim-lua/plenary.nvim, nvim-telescope/telescope.nvim, nvim-telescope/telescope-fzy-native.nvim: Requirements and Telescope itself for searching.

puremourning/vimspector: Debugging tool.

I hope this reference is useful for you! If you have more questions or need details about a specific command, just ask.

