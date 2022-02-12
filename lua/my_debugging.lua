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
  -- print(vim.inspect(t))
  return t
end

-- Rust, C, C++
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode'
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
    elements = {
      -- You can change the order of elements in the sidebar
      "scopes",
      "breakpoints",
      "stacks",
      "watches"
    },
    size = 40,
    position = "left" -- Can be "left" or "right"
  },
  tray = {
    elements = {
      "repl"
    },
    size = 10,
    position = "bottom" -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil   -- Floats will be treated as percentage of your screen.
  }
})

require('nvim-dap-virtual-text').setup()
vim.fn.sign_define('DapBreakpoint', { text ='🛑' })
