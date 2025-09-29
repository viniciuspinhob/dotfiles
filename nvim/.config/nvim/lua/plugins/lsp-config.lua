-- LSP and diagnostic configuration
-- CoC virtual text control
local function toggle_virtual_text(show)
  vim.fn['coc#config']('diagnostic.virtualText', show)
end

-- Hide virtual text by default
toggle_virtual_text(false)

-- Show only in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    toggle_virtual_text(true)
  end
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    toggle_virtual_text(false)
  end
})
