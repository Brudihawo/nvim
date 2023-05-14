vim.g.python3_host_prog = require('local').python3_host_prog
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
vim.o.conceallevel = 0
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
    edit_distance = 0.75,
    proximity = 0.75,
    recency = 0.75,
  },
  display = {
    ghost_text = {
      context = { "<", ">" },
      enabled = true,
    },
    pum = {
      kind_context = { "  ", " " },
      source_context = { " [", "]" },
    },
    icons = {
      mode = "long",
    },
    preview = {
      border = {
        { "", "NormalFloat" }, -- top left
        { "", "NormalFloat" }, -- top
        { "", "NormalFloat" }, -- top right
        { "", "NormalFloat" }, -- right
        { "", "NormalFloat" }, -- bottom right
        { "", "NormalFloat" }, -- bottom
        { "", "NormalFloat" }, -- bottom left
        { "", "NormalFloat" }, -- left
      },
    }
  },
  clients = {
    ["tags.enabled"] = false,
    ["tree_sitter"] = { enabled = false },
    ["snippets.enabled"] = false,
    lsp = {
      enabled = true,
      weight_adjust = 1.5,
      always_on_top = {},
    },
    buffers = {
      enabled = true,
      weight_adjust = 0.5,
    },
    paths = {
      enabled = true,
      always_on_top = false,
      weight_adjust = 0.3,
    }
  }
}

require('coq')

-- COQsources = COQsources or {}
-- COQsources["<random uid>"] = {
--   name = "spell",
--   fn = function (args, callback)
--     local row, col = unpack(args.pos)

--   end
-- }

vim.cmd([[COQnow -s]])

require('coq_3p') {
  { src = "nvimlua", short_name = "nLUA", conf_only = false },
}


vim.o.completeopt = "menuone,noselect"

require('my_autocommands')
require('my_keymapping')


require('harpoon').setup()

local leap = require('leap')
leap.setup {
  case_insensitive = true,
  safe_labels = {},
}
leap.opts.safe_labels = {}
leap.set_default_keymaps()
-- LeapLabelPrimary xxx cterm=nocombine ctermfg=0 ctermbg=9 gui=nocombine guifg=Black guibg=#ccff88

local function leap_all_windows()
  require 'leap'.leap {
    ['target-windows'] = vim.tbl_filter(
      function(win) return vim.api.nvim_win_get_config(win).focusable end,
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

require('gitsigns').setup({
  signs                        = {
    add          = { hl = 'GitSignsAdd', text = '┃', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '━', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '━', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
})

require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_vimtex')
require('my_debugging')
require('my_ui_visuals')
require('my_funcs')

require("luasnip").setup {
  enable_autosnippets = true
}
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/lua" })

-- Neogit Highlighting
vim.cmd("hi NeogitDiffAdd guibg='#78997a' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffDelete guibg='#7d2a2f' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffContextHighlight guibg='#4d453e'")

vim.cmd("hi NeogitHunkHeaderHighlight guibg='#697893'")

-- Zotcite
vim.cmd [[let $ZoteroSQLPath = '~/Zotero/zotero.sqlite']]
