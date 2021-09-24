-- Formatting
vim.o.encoding = 'utf-8'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = true

vim.o.backspace = 'indent,eol,start'
vim.o.display = 'lastline'

-- vim.o.spelllang=de,en
vim.o.confirm = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200
vim.o.pastetoggle = '<F10>'

-- UltiSnips Config
vim.g.UltiSnipsExpandTrigger = "<c-X>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
vim.g.UltiSnipsEditSplit = "context"

-- Markdown Preview
vim.g.mkdp_browser = 'firefox'

-- Updatetime
vim.o.updatetime = 800

-- Vim-cmake
vim.g.cmake_generate_options ={ '-G', 'Ninja', '-B', 'build' }

-- Minimap
vim.g.minimap_git_colors = true
vim.g.minimap_highlight_search = true

-- Autocompletion
local coq = require('coq')
vim.g.coq_settings = {
  auto_start = "shut-up",
  weights = {
    proximity = 0.75,
    recency = 1.5,
  },
  display = {
    icons = {
      spacing = 2,
    }
  }
}

vim.cmd[[COQnow -s]]
vim.o.completeopt = "menuone,noselect"

require('my_autocommands')
require('my_keymapping')

-- Extend text objects
surround_pairs = {
  [':'] = ':',
  [';'] = ';',
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
  keys="asdfghjklöwertzuio",
  perm_method = require'hop.perm'.TrieBacktrackFilling,
}

require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_debugging')
require('my_ui_visuals')
