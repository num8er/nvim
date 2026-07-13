local lspconfig = require('lspconfig')
lspconfig.zls.setup {}

local function flatten_root_markers(markers, flattened)
  for _, marker in ipairs(markers or {}) do
    if type(marker) == "table" then
      flatten_root_markers(marker, flattened)
    else
      flattened[#flattened + 1] = marker
    end
  end
end

local lua_ls = vim.lsp.config.lua_ls
if type(lua_ls) == "table" and type(lua_ls.root_markers) == "table" then
  local root_markers = {}
  flatten_root_markers(lua_ls.root_markers, root_markers)
  vim.lsp.config("lua_ls", { root_markers = root_markers })
end
