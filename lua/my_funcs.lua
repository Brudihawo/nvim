function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

M = {}

M.goto_other = function()
  local uri = vim.uri_from_bufnr(0)
  if string.ends(uri, "\.c") then
  end
end

re
