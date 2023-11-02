local dap = require('dap')

-- Utility function
local function splitstr(input, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for elem in string.gmatch(input, "([^" .. sep .. "]+)") do
    table.insert(t, elem)
  end
  -- print(vim.inspect(t))
  return t
end

-- Rust, C, C++
dap.adapters.lldb = {
  type = 'executable',
  command = require('local').lldb_vscode_path
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    runInTerminal = false,
    args = function() return splitstr(vim.fn.input('Args: ', '', 'file')) end,
  },
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    runInTerminal = false,
    args = function() return splitstr(vim.fn.input('Args: ', '', 'file')) end,
  },
}

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
      return require('local').python3_host_prog
    end
  end,
}

-- DAP-UI
require("dapui").setup()
vim.fn.sign_define('DapBreakpoint', { text = 'B' })
