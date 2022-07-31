local popup = require("popup")

function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

M = {}

M.goto_c_h = function()
  local uri = vim.uri_from_bufnr(0)
  if string:ends(uri, ".c") then
    print(uri:sub(1, -1) .. "h")
  elseif string.ends(uri, ".h") then
    print(uri:sub(1, -1) .. "c")
  end
end

M.new_buf_cmd = function(bufname)
  local command = vim.fn.input("Execute Command: ", "", 'shellcmd')
  bufname = bufname or "command"
  vim.cmd("new " .. bufname)
  vim.cmd("r!" .. command)
  vim.cmd('setlocal readonly')
end

vim.cmd([[
function! CompleteMan(ArgLead, CmdLine, CursorPos)
  return system("apropos . | awk '{print $1}'")
endfunction
]])

M.man_split = function()
  local program = vim.fn.input("man: ", "", 'custom,CompleteMan')
  vim.cmd("vnew ")
  vim.cmd('r! MANWIDTH=' .. vim.fn.winwidth(0) .. ' man ' .. program)
  vim.cmd('set ft=man')
  vim.cmd('setlocal readonly')
end


my_rename_handler = function(err, method, result, client_id, bufnr, config)
  local items = vim.lsp.util.locations_to_items(result)
  qf_entries = {}

  if result.changes then
    for loc_uri, edits in pairs(result.changes) do
      local bufnr = vim.uri_to_bufnr(loc_uri)
      for _, edit in ipairs(edits) do
        local line_nr = edit.range.start.line + 1
        local char_start = edit.range.start.character + 1
        local line = vim.api.nvim_buf_get_lines(bufnr, line_nr - 1, line_nr, false)[1]
        table.insert(qf_entries, {
          bufnr = bufnr,
          lnum = line_nr,
          col = char_start,
          text = line,
        })
      end
    end

    vim.fn.setqflist(qf_entries, "r")
    vim.cmd("copen")

    -- TODO: send to telescope with multiple selection and handle actual renaming
    -- vim.lsp.handlers["textDocument/rename"](err, method, result, client_id, bufnr, config)
  end
end

lsp_rename_preview = function()
  local rename_params = vim.lsp.util.make_position_params()
  local response = vim.lsp.buf_request(0, "textDocument/rename", rename_params, my_rename_handler)
end

local check_back_space = function()
  local col = vim.fn.col() - 1
  return col == 0 or vim.fn.getline():sub(col, col):match('%s') ~= nil
end

M.tab_complete = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-n>", "n")]])
    return
  end

  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    vim.api.nvim_eval([[feedkeys("\<tab>", "n")]])
    return
  end

  require('cmp').mapping.complete()
end

M.s_tab_complete = function()
  if vim.fn.pumvisible() ~= 0 then
    vim.api.nvim_eval([[feedkeys("\<c-p>", "n")]])
    return
  end

  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    vim.api.nvim_eval([[feedkeys("\<s-tab>", "n")]])
    return
  end
  return
end

M.find_cmake_dir = function()
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    if vim.fn.isdirectory(dir .. "/build") == 1 then
      return dir .. "/build"
    end
  end
  return nil
end

M.find_buf_pattern = function(pat)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      if string.match(vim.api.nvim_buf_get_name(buf), pat) then
        return buf
      end
    end
  end
  return nil
end

M.bufnr_open = function(bufnr)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      if vim.api.nvim_win_get_buf(win) == bufnr then
        return true
      end
    end
  end
  return false
end

M.cmake_build_proj = function()
  local base_dir = M.find_cmake_dir()
  local bufname = "CMakeBuild Output"

  local existing_buf = M.find_buf_pattern(".*" .. bufname)

  local bufnr = existing_buf
  if existing_buf then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  else
    bufnr = vim.api.nvim_create_buf(false, true)
    if bufnr == 0 then
      print("Error, could not create buffer")
      return
    end
    vim.api.nvim_buf_set_name(bufnr, bufname)
  end
  if not M.bufnr_open(bufnr) then
    vim.cmd("split")
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  end

  if base_dir == nil or base_dir == '' then
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "Error, could not find cmake base build directory. Aborting..." })
  else
    local cmd = "cmake --build " .. base_dir
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "Executing " .. cmd })
    vim.fn.jobstart(vim.fn.split(cmd, " "), {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end,
      on_stderr = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end,
      on_exit = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false,
          { "=====================================================", "Finished!" })
      end
    })
  end
end

vim.api.nvim_create_user_command("CMakeBuild", M.cmake_build_proj, {})

return M
