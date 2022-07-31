local api = vim.api
local kommentary = require('kommentary.kommentary')
local kconfig = require('kommentary.config')

local M = {}

local function find_from_end(s, pattern, start)
  return s:len() - s:reverse():find(pattern, s:len() - start)
end

M.add_linebreak = function(chars)
  local orig_pos = api.nvim_win_get_cursor(0)
  local line_nr = orig_pos[1]
  local line = api.nvim_get_current_line()
  if line:len() < tonumber(chars, 10) then
    api.nvim_out_write("Line is shorter than " .. chars .. " ("
      .. line:len() .. ") characters. Skipping...\n")
    if line_nr < api.nvim_buf_line_count(0) then
      api.nvim_win_set_cursor(0, { line_nr + 1, 0 })
    end
    return
  else
    api.nvim_out_write("Truncating line of length " .. line:len() .. ".\n")
  end

  local beginning_of_word = nil
  if line:sub(chars + 1, chars + 1):match("[^%s]") ~= nil then
    beginning_of_word = find_from_end(line, "%s", chars)
  else
    beginning_of_word = line:find("[^%s]", chars)
  end

  local indentation = line:sub(1, line:find("[^%s]") - 1)
  local line_end = find_from_end(line, "[^%s]", beginning_of_word)

  api.nvim_buf_set_lines(0, line_nr - 1, line_nr, true, { line:sub(0, line_end + 1) })
  api.nvim_buf_set_lines(0, line_nr, line_nr, true, { indentation .. line:sub(beginning_of_word + 2) })


  -- Handling Comments Using Kommentary
  if kommentary.is_comment(line_nr, line_nr, kconfig.get_config(0)) then
    api.nvim_win_set_cursor(0, { line_nr, 0 })
    require('kommentary').toggle_comment(line_nr + 1, line_nr + 1)
  end

  -- Set new cursor position on next line
  if line_nr < api.nvim_buf_line_count(0) then
    api.nvim_win_set_cursor(0, { line_nr + 1, 0 })
  end
end

api.nvim_set_keymap("n", "<plug>HInsertLineBreak",
  "<cmd>lua require('line_manipulation').add_linebreak(87)<CR>",
  { silent = true, noremap = false, expr = false })

vim.fn['repeat#set'](api.nvim_replace_termcodes('<plug>HInsertLineBreak', true, false, false), vim.v.count)



return M
