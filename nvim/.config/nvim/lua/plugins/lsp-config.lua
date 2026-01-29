-- Mason setup (LSP installer)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pyright", "ts_ls" },
  automatic_installation = true,
})

-- Get capabilities from cmp_nvim_lsp (for autocompletion)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Global LSP config: capabilities for all servers (Neovim 0.11 vim.lsp.config)
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Keymaps and buffer-local LSP setup on attach (replaces on_attach)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gv', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
    vim.keymap.set('n', 'gs', '<cmd>split | lua vim.lsp.buf.definition()<CR>', bufopts)
    vim.keymap.set('n', 'gt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
  end,
})

-- Enable LSP servers (uses configs from nvim-lspconfig's lsp/*.lua when available)
local servers = { 'pyright', 'ts_ls', 'lua_ls' }
for _, name in ipairs(servers) do
  vim.lsp.enable(name)
end
