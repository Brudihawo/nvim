-- Formatting
require('plugins')
vim.o.encoding = 'utf-8'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = true
vim.o.hidden = true
vim.o.compatible = false
vim.o.ignorecase = true
vim.o.noswapfile = true
vim.o.title = true
vim.o.titlestring = "%F"
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.backspace = 'indent,eol,start'
vim.o.display = 'lastline'

-- vim.o.spelllang=de,en
vim.o.confirm = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200
vim.o.pastetoggle = '<F10>'

vim.o.shell = "/bin/bash"
vim.o.grepprg = "rg -i --vimgrep"

-- Markdown Preview
vim.g.mkdp_browser = 'firefox'

-- Updatetime
vim.o.updatetime = 800

-- Vim-cmake
vim.g.cmake_generate_options = { '-G', 'Ninja', '-B', 'build' }

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
    pum = {
      kind_context = { "  ", " " },
      source_context = { " [", "]" },
    },
    icons = {
      mode = "short",
    }
  },
  clients = {
    ["tags.enabled"] = false,
    ["tree_sitter.enabled"] = false,
    ["snippets.enabled"] = false,
    lsp = {
      enabled = true,
      weight_adjust = 1.5,
    }
  }
}

require('coq')
vim.cmd([[COQnow -s]])
vim.o.completeopt = "menuone,noselect"

--- UltiSnips Config
vim.g.UltiSnipsExpandTrigger = "<M-X>"
vim.g.UltiSnipsJumpForwardTrigger = "<M-n>"
vim.g.UltiSnipsJumpBackwardTrigger = "<M-m>"
vim.g.UltiSnipsEditSplit = "context"

require('my_autocommands')
require('my_keymapping')


require('harpoon').setup()

local leap = require('leap')
leap.setup {
  case_insensitive = true,
}
leap.set_default_keymaps()
-- leap.init_highlight(true)

local function leap_all_windows()
  require'leap'.leap {
    ['target-windows'] = vim.tbl_filter(
      function (win) return vim.api.nvim_win_get_config(win).focusable end,
      vim.api.nvim_tabpage_list_wins(0)
    )
  }
end
vim.keymap.set('n', 's', leap_all_windows, { silent = true })

-- Kommentary Config
require('kommentary.config').configure_language('default', {
  prefer_single_line_comments = true,
})

require('neogit').setup {
  disable_signs = true,
  disable_hint = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = false,
  -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
  -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
  auto_refresh = true,
  disable_builtin_notifications = false,
  use_magit_keybindings = false,
  commit_popup = {
    kind = "split",
  },
  -- Change the default way of opening neogit
  kind = "tab",
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = false
  },
  -- Setting any section to `false` will make the section not render at all
  sections = {
    untracked = { folded = false },
    unstaged = { folded = false },
    staged = { folded = false },
    stashes = { folded = true },
    unpulled = { folded = true },
    unmerged = { folded = false },
    recent = { folded = true },
  },
  -- override/add mappings
  mappings = { status = {
    ["B"] = "BranchPopup",
    ["o"] = "GoToFile",
    ["="] = "Toggle",
    ["L"] = "LogPopup",
    ["r"] = "RefreshBuffer",
  }
  }
}

require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_debugging')
require('my_ui_visuals')
require('my_funcs')

-- Neogit Highlighting
vim.cmd("hi NeogitDiffAdd guibg='#78997a' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffDelete guibg='#7d2a2f' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffContextHighlight guibg='#4d453e'")

vim.cmd("hi NeogitHunkHeaderHighlight guibg='#697893'")

-- Zotcite
vim.cmd [[let $ZoteroSQLPath = '~/Zotero/zotero.sqlite']]
