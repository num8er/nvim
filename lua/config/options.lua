-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_blink_main = false

vim.diagnostic.config({
    virtual_lines = false,
    virtual_text = false,
    signs = true,
    float = {
        source = 'always',
        show_header = true,
    },
    update_in_insert = false,
    severity_sort = false, 
})