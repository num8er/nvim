local dap = require('dap')

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb',
  name = 'lldb'
}

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
