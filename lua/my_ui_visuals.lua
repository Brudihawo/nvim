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
vim.cmd [[
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
  vim.o.background = 'dark'
  vim.g.gruvbox_material_background = 'hard'
  vim.g.gruvbox_material_enable_italic = true
  vim.g.gruvbox_material_ui_contrast = 'high'
  vim.g.gruvbox_material_diagnostic_text_highlight = true
  vim.g.gruvbox_material_palette = 'material'

  vim.cmd([[
    colorscheme gruvbox-material
  ]])
  lualine_theme = "gruvbox_material"
elseif colorscheme == "melange" then
  vim.cmd("colorscheme melange")
  vim.api.nvim_set_hl(0, "Visual", { bg = "#CC5500", fg = "#FFFFFF" })
  vim.api.nvim_set_hl(0, "Search", { bg = "#CC5500", fg = "#FFFFFF" })
  lualine_theme = "auto"
  vim.api.nvim_set_hl(0, "DiffText", {bg = "#EBC06D", fg="#292522"})
  vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#85B695", fg="#292522"})
  vim.api.nvim_set_hl(0, "DiffDelete", {bg = "#D47766", fg="#292522"})
  vim.api.nvim_set_hl(0, "DiffChange", {bg = "#B380B0", fg="#292522"})
end

-------------------------------------------------------------------------------
-- GIT
-------------------------------------------------------------------------------

-- Gitgutter disable signs
vim.o.signcolumn = 'yes'
vim.g.gitgutter_signs = false

-------------------------------------------------------------------------------
-- OTHER UI STUFF
-------------------------------------------------------------------------------

-- colorizer
require('colorizer').setup {}

-- layout
vim.o.number = true
vim.o.cmdheight = 1
vim.o.laststatus = 2
vim.o.ambiwidth = 'single'

-- listchars
vim.o.listchars = 'eol:↲'

require('lualine').setup {
  options = {
    theme = lualine_theme,
    section_separators = "",
    component_separators = "│",
    path = 1,
    shorting_target = 50
  },
  sections = {
    lualine_a = { 'branch' },
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_y = { 'location' },
    lualine_z = { 'progress' },
  },
}
