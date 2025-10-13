-- ~/.config/nvim/lua/plugins/init.lua
vim.g.vimwiki_list = {
    {
        path = '~/vimwiki/',
        syntax = 'markdown',
        ext = '.md'
    }
}
vim.g.vimwiki_filetypes = {'markdown'}
vim.g.vimwiki_global_ext = 0
-- Load LSP first, then completion
require("plugins.lsp-config")
require("plugins.completion-setup")
require("plugins.render-markdown")
