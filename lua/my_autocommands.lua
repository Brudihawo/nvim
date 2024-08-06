vim.api.nvim_create_autocmd({ "BufEnter" },
  {
    pattern = "CMakeBuild Output",
    callback = function()
      vim.cmd("set ft=CMakeOutput")
    end
  }
)
