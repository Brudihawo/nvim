local popup = require("popup")

function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

M = {}

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

M.find_in_parents = function(name, isdir)
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    local path = dir .. "/" .. name
    if isdir then
      if vim.fn.isdirectory(path) == 1 then
        return path
      end
    else
      if vim.fn.filereadable(path) == 1 then
        return path
      end
    end
  end
  return nil
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
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
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
    vim.fn.jobstart("/usr/bin/time --format='Took %Es' -- " .. cmd, {
      stdout_buffered = false,
      stderr_buffered = false,
      on_stdout = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end,
      on_stderr = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end,
      on_exit = function(_, data)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false,
          { "=====================================================",
            "Finished!" })
      end
    })
  end
end

vim.api.nvim_create_user_command("CMakeBuild", M.cmake_build_proj, {})

M.insert_docstring_comment = function()
  local query_str = {
    cpp = [[
(function_declarator
  (parameter_list
    (parameter_declaration
      (identifier)* @param
      (reference_declarator (identifier) @param)*
      (pointer_declarator (identifier) @param)*
    )
  )
)
]]   ,
  }
  local function_decl_str = {
    cpp = "function_declarator"
  }

  local ftype = vim.bo.filetype
  if query_str[ftype] == nil or function_decl_str[ftype] == nil then
    print("Not implemented for " .. ftype)
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)

  local tsparser = vim.treesitter.get_parser(0)
  local root = tsparser:parse()[1]:root()
  local current = root:descendant_for_range(pos[1], pos[0], pos[1], pos[0])
  while current:type() ~= function_decl_str[ftype] do
    if current:type() == "function_definition" then
      break
    end

    current = current:parent()
    if current == nil then
      print("Not in function definition or declaration")
      return
    end
  end

  local indent_node = current:parent()
  if current:type() == "function_definition" then
    indent_node = current
  end
  local _, indentation, _ = indent_node:range()
  local indentstr = (" "):rep(indentation)

  local query = vim.treesitter.parse_query(ftype, query_str[ftype])
  local docstring_comment = {
    indentstr .. "/*",
    indentstr .. "* @brief ",
    indentstr .. "*"
  }

  for _, match, _ in query:iter_matches(current, 0, 0, 0) do
    for id, node in pairs(match) do
      local startr, startc, endr, endc = node:range()
      table.insert(docstring_comment, indentstr .. "* @param " ..
        vim.api.nvim_buf_get_text(0, startr, startc, endr, endc, {})[1] .. " ")
    end
  end
  table.insert(docstring_comment, indentstr .. "*/")
  local sr, sc, _ = indent_node:range()
  vim.api.nvim_buf_set_lines(0, sr, sr, true, docstring_comment)
  vim.api.nvim_win_set_cursor(0, { sr, sc })
end

vim.api.nvim_create_user_command("TSDocComment", M.insert_docstring_comment, {})

M.todos_qflist = function()
  local f = assert(io.popen("tdf --quickfix .", "r"))
  local s = assert(f:read('*a'))
  f:close()
  local i = 0;
  local qflist = {}
  for line in s:gmatch("([^\n]*)\n") do
    i = i + 1;
    local file, lineno, text = line:match("(.-); (%d+); (.*)")
    table.insert(qflist, {filename=file, lnum=lineno, text=text})
    -- print("file: " .. file .. "; line: ")
  end
  vim.fn.setqflist(qflist)
  vim.cmd("copen")
end

return M
