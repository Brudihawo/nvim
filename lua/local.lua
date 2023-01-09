local defaults = {
  python3_host_prog = '/usr/bin/python3.10',
  lldb_vscode_path = '/usr/bin/lldb-vscode',
  vimtex_tex_flavor = 'lualatex',
  vimtex_view_method = 'zathura',
  vimtex_viewer = '',
  vimtex_view_options = ''
}

local local_defs, _ = loadfile('local_vals')

if local_defs == nil then
  return defaults
else
  local retval = {}
  local file_contents = local_defs()
  for k, v in pairs(defaults) do
    retval[k] = file_contents[k] or v
  end
  return retval
end
