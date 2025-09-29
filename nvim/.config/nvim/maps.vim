let mapleader = " "

nnoremap Y y$

" Keeping cursor centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Find files using Lua functions
nmap <leader>fs <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<cr>
nmap <leader>fw <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<word>")})<cr>
nmap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nmap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nmap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nmap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" debugging mappings
nmap <leader>dl :call vimspector#Launch()<cr>
nmap <leader>dr :VimspectorReset<cr>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
nmap <leader>do :VimspectorShowOutput
nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" Ntree toogle
nnoremap <leader>n :NvimTreeToggle<CR>

" Tab management mappings
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tm :tabmove<CR>

" Tab navigation (alternative to gt/gT)
nnoremap <leader>th :tabprev<CR>
nnoremap <leader>tl :tabnext<CR>

" Or use numbers to jump to specific tabs
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

" Code navigation
nmap <silent> gd <Cmd>call CocAction('jumpDefinition', 'tabe')<CR>
nmap <silent> gv <Cmd>vsplit<CR><Cmd>call CocAction('jumpDefinition')<CR>
nmap <silent> gs <Cmd>botright split<CR><Cmd>call CocAction('jumpDefinition')<CR>
nmap <silent> gr <Cmd>call CocAction('jumpReferences', 'tabe')<CR>
nmap <silent> gi <Cmd>call CocAction('jumpImplementation', 'tabe')<CR>
nmap <silent> giv <Cmd>vsplit<CR><Cmd>call CocAction('jumpImplementation')<CR>
nmap <silent> gy <Cmd>call CocAction('jumpTypeDefinition', 'tabe')<CR>
nmap <silent> gyv <Cmd>vsplit<CR><Cmd>call CocAction('jumpTypeDefinition')<CR>

" Search and replace with confirmation
nnoremap <leader>sr :%s//gc<Left><Left><Left>
vnoremap <leader>sr :s//gc<Left><Left><Left>

"undo tree
nnoremap <leader>ut :UndotreeToggle<CR>
