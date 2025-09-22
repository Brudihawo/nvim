local t = require('telescope')
local previewers = require('telescope.previewers')
local actions = require('telescope.actions')
return {
  setup = function()
    t.setup {
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--hidden',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--trim',
          '--vimgrep'
        },
        layout_strategy = "bottom_pane",
        layout_config = {
          bottom_pane = {
            height = 0.15,
            prompt_position = "bottom"
          }
        },
        prompt_prefix = "≫  ",
        selection_caret = "⟿  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        file_sorter = require 'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '', '', '', '', '', '', '' },
        color_devicons = true,
        use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        preview = false,
        mappings = {
          n = {
            ['<C-d>'] = actions.delete_buffer,
            ['<C-v>'] = actions.file_vsplit,
            ['<C-s>'] = actions.file_split,
          },
          i = {
            ['<C-d>'] = actions.delete_buffer,
            ['<C-v>'] = actions.file_vsplit,
            ['<C-s>'] = actions.file_split,
          }
        }
      },
    }
  end
}
