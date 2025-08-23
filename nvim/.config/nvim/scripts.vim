" Salva o arquivo atual ao sair do buffer
augroup auto_save_current
  autocmd!
  autocmd BufLeave * silent! w
augroup END
