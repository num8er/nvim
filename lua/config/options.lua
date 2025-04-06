-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_blink_main = false

-- vim.diagnostic.config({
--     virtual_lines = false,
--     virtual_text = false,
--     signs = true,
--     float = {
--         source = 'always',
--         show_header = true,
--     },
--     update_in_insert = false,
--     severity_sort = false,
-- })

local group = vim.api.nvim_create_augroup("OoO", {})

local function au(typ, pattern, cmdOrFn)
  if type(cmdOrFn) == "function" then
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, callback = cmdOrFn, group = group })
  else
    vim.api.nvim_create_autocmd(typ, { pattern = pattern, command = cmdOrFn, group = group })
  end
end

-- Disable inline diagnostics but keep signs in the sign column
vim.diagnostic.config({
  virtual_text = false, -- No inline errors
  signs = true, -- Keep signs in the sign column
  underline = true, -- Keep underlining for errors/warnings
  update_in_insert = false, -- Don't update diagnostics in insert mode
})

au({ "CursorHold", "InsertLeave" }, nil, function()
  local opts = {
    focusable = false,
    scope = "cursor",
    close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
    border = "single", -- Add border to floating window
  }
  vim.diagnostic.open_float(nil, opts)
end)

au("InsertEnter", nil, function()
  vim.diagnostic.enable(false)
end)

au("InsertLeave", nil, function()
  vim.diagnostic.enable(true)
end)
