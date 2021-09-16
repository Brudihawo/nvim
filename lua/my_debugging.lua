local dap = require('dap')

-- Utility function
local function splitstr(input, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for elem in string.gmatch(input, "([^"..sep.."]+)") do
    table.insert(t, elem)
  end
  print(vim.inspect(t))
  return t
end

-- Rust, C, C++
dap.adapters.cppdbg = {
  type = 'executable',
  command = os.getenv('HOME') .. '/debug_adapters/vscode-cpptools/extension/debugAdapters/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = 'Launch file',
    type = 'cpptools',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    MiMode = 'gdb',
    miDebuggerPath = 'gdb',
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MiMode = 'gdb',
    miDebuggerServerAdress = 'localhost:1234',
    miDebuggerPath = 'gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to Executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local args = vim.fn.input('Arguments: ', '','file')
      args = splitstr(args)
      print(vim.inspect(args))
      return args
    end,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Python
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  type = 'python',
  request = 'launch',
  name = 'Launch File',

  program = '${file}',
  pythonPath = function()
    local cwd = vim.fn.getcwd()
    if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
      return cwd .. '/venv/bin/python'
    elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
      return cwd .. '/.venv/bin/python'
    else
      return '/home/hawo/miniconda3/bin/python'
    end
  end,
}

-- DAP-UI

require("dapui").setup({
  icons = {
    expanded = "▾",
    collapsed = "▸"
  },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = {"<CR>", "<2-LeftMouse>"},
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    open_on_start = true,
    elements = {
      -- You can change the order of elements in the sidebar
      "scopes",
      "breakpoints",
      "stacks",
      "watches"
    },
    width = 40,
    position = "left" -- Can be "left" or "right"
  },
  tray = {
    open_on_start = true,
    elements = {
      "repl"
    },
    height = 10,
    position = "bottom" -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil   -- Floats will be treated as percentage of your screen.
  }
})

vim.g.dap_virtual_text = true
vim.fn.sign_define('DapBreakpoint', { text ='🛑' })
