" Colorscheme from ~/.config/theme (use switch-theme to change)
set t_Co=256

let s:theme = 'gruvbox'
if filereadable(expand('~/.config/theme'))
    let s:theme = trim(readfile(expand('~/.config/theme'))[0])
endif
if s:theme ==# ''
    let s:theme = 'gruvbox'
endif

let s:colorscheme = s:theme
let s:background = 'dark'
let s:lightline_theme = s:theme

if s:theme ==# 'gruvbox-light'
    let s:colorscheme = 'gruvbox'
    let s:background = 'light'
elseif s:theme ==# 'everforest-light'
    let s:colorscheme = 'everforest'
    let s:background = 'light'
elseif s:theme ==# 'solarized-light'
    let s:colorscheme = 'solarized8'
    let s:background = 'light'
    let s:lightline_theme = 'solarized'
endif

if s:colorscheme ==# 'gruvbox'
    if s:background ==# 'dark'
        if exists('+termguicolors')
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        let g:gruvbox_invert_selection = '0'
    endif
elseif s:colorscheme ==# 'everforest'
    let g:everforest_background = 'hard'
    let g:everforest_better_performance = 1
endif

execute 'colorscheme ' . s:colorscheme
execute 'set background=' . s:background

let g:lightline = {
      \ 'colorscheme': s:lightline_theme,
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'fullpath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fullpath': 'LightlineFullpath'
      \ },
      \ 'tabline': {
      \   'left': [ ['tabs'] ],
      \   'right': [ ['close'] ]
      \ },
      \ }

function! LightlineFullpath()
  return expand('%')
endfunction

set showtabline=2
