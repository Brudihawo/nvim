-- Formatting
vim.o.encoding = 'utf-8'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = true
vim.o.hidden = true
vim.o.compatible = false

vim.o.backspace = 'indent,eol,start'
vim.o.display = 'lastline'

-- vim.o.spelllang=de,en
vim.o.confirm = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200
vim.o.pastetoggle = '<F10>'

vim.o.shell = "/usr/bin/bash"

-- UltiSnips Config
vim.g.UltiSnipsExpandTrigger = "<M-X>"
vim.g.UltiSnipsJumpForwardTrigger = "<M-n>"
vim.g.UltiSnipsJumpBackwardTrigger = "<M-m>"
vim.g.UltiSnipsEditSplit = "context"

-- Markdown Preview
vim.g.mkdp_browser = 'firefox'

-- Updatetime
vim.o.updatetime = 800

-- Vim-cmake
vim.g.cmake_generate_options ={ '-G', 'Ninja', '-B', 'build' }

-- Autocompletion
vim.g.coq_settings = {
  auto_start = "shut-up",
  weights = {
    edit_distance = 3,
    proximity = 0.75,
    recency = 0.75,
  },
  display = {
    ghost_text = {
      enabled = true,
    },
    icons = {
      spacing = 2,
      mode = "short"
    }
  },
  clients = {
    ["tags.enabled"] = false,
    ["tree_sitter.enabled"] = false,
    ["snippets.enabled"] = false,
  }
}
local coq = require('coq')

vim.cmd[[COQnow -s]]
vim.o.completeopt = "menuone,noselect"

require('my_autocommands')
require('my_keymapping')

LIGHTSPEED_LOADED = false or LIGHTSPEED_LOADED
if not LIGHTSPEED_LOADED then
  require('lightspeed').setup {
    jump_to_unique_chars = true,
    limit_ft_matches = 7,
  }
  vim.cmd('nunmap F')
  vim.cmd('nunmap f')

  LIGHTSPEED_LOADED = true
end

-- Kommentary Config
require('kommentary.config').configure_language('default', {
  prefer_single_line_comments = true,
})


require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_debugging')
require('my_ui_visuals')
