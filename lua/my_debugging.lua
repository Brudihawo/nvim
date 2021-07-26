local dap = require('dap')

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
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MiMode = 'gdb',
    miDebuggerServerAdress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function() 
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
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


