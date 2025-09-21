local oil = require 'oil'
local function oil_exec_cmd()
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  local cwd = oil.get_current_dir()
  local filename = cwd .. entry.name
  local program = vim.fn.input("> ", "", "shellcmd")
  local cmd = program .. " '" .. filename .. "'"
  print("Executing " .. cmd)

  local handle = io.popen("cd '" .. cwd .. "' && " .. cmd)
  if handle == nil then
    print("could not start process")
    return
  end

  local output = handle:read('*a')
  handle:close()
  print(output)
end

return {
  setup = function()
    require('oil').setup({
      columns = { "icon", "mtime", "size" },
      cleanup_delay_ms = 0,
      lsp_file_methods = { enabled = false, timeout_ms = 0 },
      keymaps = {
        ["gX"] = oil_exec_cmd
      }
    })
  end
}
