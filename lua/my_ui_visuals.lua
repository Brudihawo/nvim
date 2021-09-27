-- highlighting and Readability
vim.o.syntax = 'on'
vim.o.ruler = true
vim.o.showcmd = true
vim.o.autoindent = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

-- Color Column
vim.o.colorcolumn = "80"

-- search
vim.o.hlsearch = true
vim.o.inccommand = 'split'
vim.o.smartcase = true

-- Colorscheme
vim.cmd[[
if has('termguicolors')
  set termguicolors
endif
]]

vim.o.background='dark'
vim.g.gruvbox_material_background='hard'
vim.g.gruvbox_material_enable_italic=true
vim.g.gruvbox_material_ui_contrast='high'
vim.g.gruvbox_material_diagnostic_text_highlight=true
vim.g.gruvbox_material_palette='material'


vim.cmd([[
colorscheme gruvbox-material
]])


-- Gitgutter disable
vim.o.signcolumn = 'yes'
vim.g.gitgutter_signs = false

-- Barbar.nvim
vim.g.bufferline = {
  tabpages = true,
  closable = false,
  clickable = false,
}

-- layout
vim.o.number = true
vim.o.cmdheight = 5
vim.o.laststatus = 2
vim.o.ambiwidth = 'single'

require('neoscroll').setup {
    -- All these keys will be mapped. Pass an empty table ({}) for no mappings
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true,  -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = 'sine'
}

require('lualine').setup {
  options= {
    theme = 'gruvbox_material',
    section_separators = "",
    component_separators = "│",
  },
   sections = {
     lualine_a = {{'mode', lower=false}},
     lualine_b = {'branch'},
     lualine_c = {'filename', 'diff'},
     lualine_x = {'encoding'},
     lualine_y = {'filetype', {'diagnostics', sources={'nvim_lsp'}}},
     lualine_z = {'location', 'progress'},
   },
  extensions = {
    'quickfix',
    'fugitive'
  }
}

require('colorizer').setup {
  ['*'] = {
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    names = false,
  }
}

require('indent_blankline').setup{
  buftype_exclude = { "terminal" },
  filetype_exclude = { "dashboard" },
  use_treesitter = true,
  char = '│',
  show_current_context = true,
  context_patterns = {
    "compound_statement", -- C scope
    ".*class.*",
    ".*function.*",
    ".*method.*",
    ".*body.*",
    "table", -- Lua Tables
    "field",
    "if.*",
    "for.*",
    "list_comprehension", -- Python stuff
    ".*argument.*"
  }
}

-- LSPSaga Highlighting
vim.cmd("highlight LspSagaDefPreviewBorder guifg='#ebdbb2'")
vim.cmd("highlight clear LspFloatWinBorder")
vim.cmd("highlight link LspFloatWinBorder LspSagaDefPreviewBorder")
vim.cmd("highlight LspSagaRenameBorder guifg='#d79921'")
vim.cmd("highlight CompeDocumentationBorder guifg='#689d6a'")

-- vim.cmd("highlight trailws guibg='#fb4934'")
-- vim.cmd("match trailws /\\s\\+$/")

-- vim.cmd("highlight longline guibg='#fabd2f' guifg='#282828'")
-- vim.cmd("match longline /.\\%>80v/")

-- dashboard-nvim
vim.g.dashboard_default_executive = 'telescope'

-- listchars
vim.o.listchars='eol:↲'
