vim.g.vimtex_mappings_disable = {
  n = { '<leader>ls', '<leader>ll', '<leader>lv' },
}

vim.g.vimtex_quickfix_open_on_warning = false
vim.g.vimtex_fold_enabled = true
vim.o.foldlevel = 10
vim.g.vimtex_syntax_conceal = {
  accents = true,
  ligatures = true,
  cites = true,
  fancy = true,
  greek = true,
  math_bounds = true,
  math_delimiters = true,
  math_fracs = true,
  math_super_sub = true,
  math_symbols = true,
  sections = true,
  styles = true,
}

vim.g.vimtex_quickfix_ignore_filters = {
  "Overfull",
  "Underfull",
  "float specifier",
}

vim.g.vimtex_compiler_method = 'latexmk'
vim.g.tex_flavour = require('local').vimtex_tex_flavor
vim.g.vimtex_view_method = require('local').vimtex_view_method
vim.g.vimtex_view_general_viewer = require('local').vimtex_view_general_viewer
vim.g.vimtex_view_general_options = require('local').vimtex_view_general_options

vim.g.vimtex_compiler_latexmk = {
  ['executable'] = 'latexmk',
  ['callback']   = 1,
  ['hooks']      = {},
  ['build_dir']  = "./build",
  ['options']    = {
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
    '--shell-escape',
  },
}

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "*.tex",
  callback = function() vim.cmd("setlocal indentexpr=GetTexIndent()") end,
})
