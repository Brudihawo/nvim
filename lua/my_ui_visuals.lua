-- Colorscheme
vim.o.termguicolors = true
vim.g.gruvbox_bold = true
vim.g.gruvbox_italic = true
vim.g.gruvbox_underline = true
-- vim.g.gruvbox_improved_warnings = true

vim.g.gruvbox_italicize_strings = true
vim.g.gruvbox_italicise_comments = true

-- vim.g.gruvbox_guisp_fallback = 'fg'
vim.g.gruvbox_hls_cursor = true
vim.g.gruvbox_termcolors = 256
vim.g.gruvbox_invert_selection = true
vim.cmd([[colorscheme gruvbox]])

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
    cursor_scrolls_alone = true  -- The cursor will keep on scrolling even if the window cannot scroll further
}

require('lualine').setup {
  options= {
    theme = 'gruvbox',
    section_separators = "",
    component_separators = "│",
  },
   sections = {
     lualine_a = {{'mode', lower=false}}, 
     lualine_b = {'branch'},
     lualine_c = {'filename', 'progress', 'diff'},
     lualine_x = {'filetype'}, 
     lualine_y = {'encoding'}, 
     lualine_z = {{'diagnostics', sources={'nvim_lsp'}}}, 
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


vim.g.indent_blankline_enabled = true
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_char = '│'
