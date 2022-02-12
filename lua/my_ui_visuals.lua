-------------------------------------------------------------------------------
-- highlighting and Readability
-------------------------------------------------------------------------------
vim.o.syntax = 'on'
vim.o.ruler = true
vim.o.showcmd = true
vim.o.autoindent = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

-- search
vim.o.hlsearch = true
vim.o.inccommand = 'split'
vim.o.smartcase = true

-- Color Column
vim.o.colorcolumn = "80"


-------------------------------------------------------------------------------
-- COLORS
-------------------------------------------------------------------------------

-- Colorscheme
vim.cmd[[
if has('termguicolors')
  set termguicolors
endif
]]

local colorscheme = "melange"
local lualine_theme = ""

if colorscheme == "seoul256" then
  vim.g.seoul256_italic_comments = true
  vim.g.seoul256_italic_keywords = true
  vim.g.seoul256_italic_functions = false
  vim.g.seoul256_italic_variables = false
  vim.g.seoul256_contrast = false
  vim.g.seoul256_disable_borders = true
  vim.g.seoul256_disable_background = false

  require('seoul256').set()
  lualine_theme = "seoul256"

elseif colorscheme == "gruvbox" then
  vim.o.background='dark'
  vim.g.gruvbox_material_background='hard'
  vim.g.gruvbox_material_enable_italic=true
  vim.g.gruvbox_material_ui_contrast='high'
  vim.g.gruvbox_material_diagnostic_text_highlight=true
  vim.g.gruvbox_material_palette='material'

  vim.cmd([[
    colorscheme gruvbox-material
  ]])
  lualine_theme = "gruvbox_material"
elseif colorscheme == "melange" then

  vim.cmd("colorscheme melange")
  lualine_theme = "auto"
end

-- Do i need this?
-- LSPSaga Highlighting
vim.cmd("highlight LspSagaDefPreviewBorder guifg='#ebdbb2'")
vim.cmd("highlight clear LspFloatWinBorder")
vim.cmd("highlight link LspFloatWinBorder LspSagaDefPreviewBorder")
vim.cmd("highlight LspSagaRenameBorder guifg='#d79921'")

-------------------------------------------------------------------------------
-- GIT
-------------------------------------------------------------------------------

-- Gitgutter disable signs
vim.o.signcolumn = 'yes'
vim.g.gitgutter_signs = false

-- LazyGit
vim.g.lazygit_floating_window_winblend = 0
vim.g.lazygit_floating_window_use_plenary = 0


-------------------------------------------------------------------------------
-- OTHER UI STUFF
-------------------------------------------------------------------------------

-- colorizer
require('colorizer').setup {
  ['*'] = {
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    names = false,
  }
}

-- Barbar.nvim
BARBAR_LOADED = false or BARBAR_LOADED
if not BARBAR_LOADED then
  vim.g.bufferline = {
    tabpages = true,
    closable = false,
    clickable = false,
  }
  BARBAR_LOADED = true
end

-- layout
vim.o.number = true
vim.o.cmdheight = 1
vim.o.laststatus = 2
vim.o.ambiwidth = 'single'

-- Minimap
vim.g.minimap_git_colors = true
vim.g.minimap_highlight_search = true


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


-- dashboard-nvim
vim.g.dashboard_default_executive = 'telescope'

-- listchars
vim.o.listchars='eol:↲'

-- Toggleterm
require('toggleterm').setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    width = 4000,
    height = 100,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

require('neoscroll').setup {
    -- All these keys will be mapped. Pass an empty table ({}) for no mappings
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true,  -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = 'sine'
}

require('lualine').setup {
  options= {
    theme = lualine_theme,
    section_separators = "",
    component_separators = "│",
  },
   sections = {
     lualine_a = {{'mode', lower=false}},
     lualine_b = {'branch'},
     lualine_c = {'filename'},
     lualine_x = {'encoding'},
     lualine_y = {'filetype', {'diagnostics', sources={'nvim_diagnostic'}}},
     lualine_z = {'location', 'progress'},
   },
  extensions = {
    'quickfix',
    'fugitive'
  }
}

