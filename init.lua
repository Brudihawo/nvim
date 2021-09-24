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

require('lightspeed').setup {
  jump_to_first_match = true,
  jump_on_partial_input_safety_timeout = 400,
  x_mode_prefix_key = '<m-x>',
  highlight_unique_chars = true,
  limit_ft_matches = 7,
}

vim.cmd('nunmap F')
vim.cmd('nunmap f')

require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_debugging')
require('my_ui_visuals')
