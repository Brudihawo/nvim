vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.py",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>f", "<cmd>w<CR><cmd>!black %<CR><cmd>!isort %<CR><CR>", {})
  end
})

vim.api.nvim_create_autocmd({ "BufEnter" },
  {
    pattern = "CMakeBuild Output",
    callback = function()
      vim.cmd("set ft=CMakeOutput")
    end
  }
)
