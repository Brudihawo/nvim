local popup = require("popup")

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

M = {}

M.goto_c_h = function()
  local uri = vim.uri_from_bufnr(0)
  if string:ends(uri, ".c") then
    print(uri:sub(1,-1) .. "h")
    elseif string.ends(uri, ".h") then
      print(uri:sub(1,-1) .. "c")
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


my_rename_handler = function (err, method, result, client_id, bufnr, config)
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

return M
