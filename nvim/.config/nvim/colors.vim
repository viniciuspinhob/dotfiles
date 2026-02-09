" Colorscheme from ~/.config/theme (use switch-theme to change)
set t_Co=256

let s:theme = 'gruvbox'
if filereadable(expand('~/.config/theme'))
    let s:theme = trim(readfile(expand('~/.config/theme'))[0])
endif
if s:theme ==# ''
    let s:theme = 'gruvbox'
endif

execute 'colorscheme ' . s:theme
set background=dark

if s:theme ==# 'gruvbox'
    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'
elseif s:theme ==# 'everforest'
    let g:everforest_background = 'hard'
    let g:everforest_better_performance = 1
elseif s:theme ==# 'dracula'
    " dracula doesn't need extra config
endif

let g:lightline = {
      \ 'colorscheme': s:theme,
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
