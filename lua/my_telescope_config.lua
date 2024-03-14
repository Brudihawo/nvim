require('telescope').setup {
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
        height = 0.3,
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
    borderchars = { '─', '', '', '│', '┌', '', '', '│' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,
    mappings = {
      n = {
        ['<C-d>'] = require('telescope.actions').delete_buffer,
        ['<C-v>'] = require('telescope.actions').file_vsplit,
        ['<C-s>'] = require('telescope.actions').file_split,
      },
      i = {
        ['<C-d>'] = require('telescope.actions').delete_buffer,
        ['<C-v>'] = require('telescope.actions').file_vsplit,
        ['<C-s>'] = require('telescope.actions').file_split,
      }
    }
  },
}
