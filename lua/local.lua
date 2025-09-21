local function loadfile_path(name)
  local p = vim.o.rtp
  for i in string.gmatch(p, "([^,]+)") do
    local path = i .. "/lua/" .. name .. ".lua";
    local ret, _ = loadfile(path)
    if ret ~= nil then
      return ret
    end
  end
  return nil
end

local defaults = {
  python3_host_prog = '/usr/bin/python3',
  lldb_vscode_path = '/usr/bin/lldb-dap',
  vimtex_tex_flavor = 'lualatex',
  vimtex_view_method = 'zathura',
  vimtex_view_zathura_options = '',
  vimtex_view_general_viewer = 'okular',
  vimtex_view_general_options = '',
}

local local_defs = loadfile_path('local_vals')

if local_defs == nil then
  return defaults
end

local retval = {}
local file_contents = local_defs()
for k, v in pairs(defaults) do
  retval[k] = file_contents[k] or v
end
return retval
