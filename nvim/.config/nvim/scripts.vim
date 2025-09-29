" Salva o arquivo atual ao sair do buffer
augroup auto_save_current
  autocmd!
  autocmd BufLeave * silent! w
augroup END

" Find file on new tab
" Find file on new tab, clearing input buffer
autocmd TabNewEntered * lua vim.defer_fn(function() 
    \ vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
    \ require('telescope.builtin').find_files() 
    \ end, 10)