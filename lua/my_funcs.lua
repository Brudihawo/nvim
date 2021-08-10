function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

M = {}

M.goto_c_h = function()
  local uri = vim.uri_from_bufnr(0)
  if string.ends(uri, ".c") then
    print(uri:sub(1,-1) .. "h")
    elseif string.ends(uri, ".h") then
      print(uri:sub(1,-1) .. "c")
    end
end

return M
