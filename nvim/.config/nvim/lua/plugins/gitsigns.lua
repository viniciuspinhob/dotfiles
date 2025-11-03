require('gitsigns').setup({
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
    
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author> • <author_time:%Y-%m-%d> • <summary>',
    
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        -- Atalhos úteis
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle Git Blame' })
        vim.keymap.set('n', '<leader>gB', function() gs.blame_line{full=true} end, { buffer = bufnr, desc = 'Git Blame Full' })
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { buffer = bufnr, desc = 'Git Diff' })
    end,
})
