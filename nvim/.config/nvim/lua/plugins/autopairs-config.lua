-- nvim-autopairs configuration
-- Auto-completes parentheses, brackets, quotes, etc.
-- Supports: Python, Markdown, JSON, YAML, JavaScript, TypeScript, Lua, and more

local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  check_ts = true, -- Enable treesitter for better context awareness
  ts_config = {
    lua = { 'string', 'source' },
    javascript = { 'string', 'template_string' },
    typescript = { 'string', 'template_string' },
    python = { 'string', 'fstring' },
    json = { 'string' },
    yaml = { 'string' },
    markdown = { 'code_fence', 'inline_code' },
    html = { 'string' },
    css = { 'string' },
  },
  disable_filetype = { 'TelescopePrompt', 'vim' },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment'
  },
})

-- Add rules for specific file types
-- Python: handle triple quotes for docstrings
npairs.add_rules({
  Rule('"""', '"""', 'python'):with_pair(function(opts)
    return vim.bo[opts.buf].filetype == 'python'
  end),
  Rule("'''", "'''", 'python'):with_pair(function(opts)
    return vim.bo[opts.buf].filetype == 'python'
  end),
})

-- Markdown: handle code blocks and inline code
-- Note: autopairs works in markdown, but we avoid it in code blocks
npairs.add_rules({
  Rule('```', '```', 'markdown'):with_pair(function(opts)
    return vim.bo[opts.buf].filetype == 'markdown'
  end),
})

-- JSON: ensure proper quote handling
-- YAML: works automatically, but we can add specific rules if needed

-- Setup nvim-ts-autotag (auto-close HTML/XML tags)
require('nvim-ts-autotag').setup({
  filetypes = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx' },
})

