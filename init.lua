-- Formatting
vim.o.encoding = 'utf-8'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = true

vim.o.backspace = 'indent,eol,start'
vim.o.display = 'lastline'

-- search
vim.o.hlsearch = true
vim.o.smartcase = true
-- vim.o.spelllang=de,en
vim.g.gruvbox_guisp_fallback = 'red'

-- highlighting and Readability
vim.o.syntax = 'on'
vim.o.ruler = true
vim.o.showcmd = true
vim.o.autoindent = true
vim.o.cursorline = true

vim.o.confirm = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200
vim.o.pastetoggle = '<F10>'

-- UltiSnips Config
vim.g.UltiSnipsExpandTrigger = "<c-X>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"

-- Markdown Preview
vim.g.mkdp_browser = 'firefox'

-- Color Column
vim.o.colorcolumn = "80"

-- Updatetime
vim.o.updatetime = 800

-- VimTeX
vim.g.vimtex_quickfix_open_on_warning = false
vim.g.vimtex_quickfix_ignore_filters = {
  ".*Overfull \\hbox.*",
  ".*Underfull \\hbox.*",
}

vim.g.vimtex_compiler_name = 'nvr'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk_engines = {
  ['_']                = '-lualatex',
  ['pdflatex']         = '-pdf',
  ['dvipdfex']         = '-pdfdvi',
  ['lualatex']         = '-lualatex',
  ['xelatex']          = '-xelatex',
  ['context (pdftex)'] = '-pdf -pdflatex=texexec',
  ['context (luatex)'] = '-pdf -pdflatex=context',
  ['context (xetex)']  = '-pdf -pdflatex=\'\'texexec --xtx\'\'',
}

vim.g.vimtex_compiler_latexmk = {
  ['executable']   = 'latexmk',
  ['callback']     = 1,
  ['hooks']        = {},
  ['options']      = {
     '-file-line-error',
     '-synctex=1',
     '-interaction=nonstopmode',
  },
}

-- Vim-cmake
vim.g.cmake_generate_options ={ '-G', 'Ninja', '-B', 'build' }

-- Minimap 
vim.g.minimap_git_colors = true
vim.g.minimap_highlight_search = true

require('my_autocommands')
require('my_keymapping')

-- Extend text objects
surround_pairs = {
  [':'] = ':',
  ['.'] = '.',
  [','] = ',',
  ['/'] = '/',
  ['<bar>'] = '<bar>',
  ['_'] = '_',
  ['-'] = '-',
  ['>'] = '<',
}

for key, value in pairs(surround_pairs) do
  for _, action in ipairs({ "c", "d", "v", "y" }) do
    vim.api.nvim_set_keymap("n", action .. 'i' .. key,
                                 'T' .. key .. action .. 't' .. value,
                                 { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", action .. 'a' .. key,
                                 'F' .. key .. action .. 'f' .. value,
                                 { noremap = true, silent = false })
  end
end

require('hop').setup {
  keys="asdfghjklö",
  perm_method = require'hop.perm'.TrieBacktrackFilling,
}
require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_debugging')
require('my_ui_visuals')
