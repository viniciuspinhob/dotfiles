" Set colorscheme
set t_Co=256
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

"lightline colorscheme
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
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
