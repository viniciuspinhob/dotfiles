" Salva o arquivo atual ao sair do buffer
augroup auto_save_current
  autocmd!
  autocmd BufLeave * silent! w
augroup END

" Find file on new tab
autocmd TabNewEntered * lua require('telescope.builtin').find_files()
