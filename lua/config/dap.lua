local dap_ok, dap = pcall(require, "dap")
local dap_ui_ok, ui = pcall(require, "dapui")
local dap_go_ok, dapgo = pcall(require, 'dap-go')

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb',
  name = 'lldb'
}

if not dap_ok then
  require("notify")("dap not installed!", "warning")
  return
end

if not dap_ui_ok then
  require("notify")("dapui not installed!", "warning")
  return
end

if not dap_go_ok then
  require("notify")("dapgo not installed!", "warning")
  return
end

dapgo.setup({
  delve = {
    initialize_timeout_sec = 20,
    port = "${port}",
  },
})

dap.configurations.go = {
  {
    type = "go",
    name = "Debug (cmd/api/main.go --env local)",
    request = "launch",
    program = "${workspaceFolder}/cmd/api/main.go",
    args = { "--env", "local" },
  },
}

ui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      elements = {
        "scopes",
      },
      size = 0.3,
      position = "right"
    },
    {
      elements = {
        "repl",
        "breakpoints"
      },
      size = 0.3,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
})

dap.configurations.zig = {
  {
    name = "Run Program",
    type = "codelldb",
    request = "launch",
    program = function()
      co = coroutine.running()
      if co then
        cb = function(item)
          coroutine.resume(co, item)
        end
      end
      cb = vim.schedule_wrap(cb)
      vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. '**/zig-out/**/*', false, true), {
          prompt = "Select executable",
          kind = "file",
        },
        cb)
      return coroutine.yield()
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      return splitStr(vim.fn.input('Args: '))
    end,
  }
}

dap.configurations.typescript = {
  {
    name = 'Attach to Docker service',
    type = 'node',
    request = 'attach',
    port = 9229,
    cwd = vim.fn.getcwd(),
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**' },
    remoteRoot = '/app',
    localRoot = '${workspaceFolder}',
  },
  {
    name = 'Attach to Local service',
    type = 'node',
    request = 'attach',
    port = 9229,
    cwd = vim.fn.getcwd(),
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**' },
    localRoot = '${workspaceFolder}',
  },
}

dap.configurations.javascript = dap.configurations.typescript

vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

vim.keymap.set("n", "<localleader>ds", function()
  dap.continue()
  ui.toggle({})
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
end)

vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
vim.keymap.set("n", "<localleader>dc", dap.continue)
vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<localleader>dn", dap.step_over)
vim.keymap.set("n", "<localleader>di", dap.step_into)
vim.keymap.set("n", "<localleader>do", dap.step_out)
vim.keymap.set("n", "<localleader>dC", function()
  dap.clear_breakpoints()
  require("notify")("Breakpoints cleared", "warn")
end)

vim.keymap.set("n", "<localleader>de", function()
  dap.clear_breakpoints()
  ui.toggle({})
  dap.terminate()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
  require("notify")("Debugger session ended", "warn")
end)
