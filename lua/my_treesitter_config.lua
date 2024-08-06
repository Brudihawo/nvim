require('nvim-treesitter.configs').setup {
  ensure_installed = { "python", "c", "cpp", "bibtex", "json", "lua", "rust", "comment" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "latex" },
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25,
    persis_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    }
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",
        ["aK"] = "@comment.outer",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["iP"] = "@parameter.inter",
        ["aP"] = "@parameter.outer",
        ["aS"] = "@statement.outer",
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>s"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>S"] = "@parameter.inner",
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {

      }
    }
  },
  nt_cpp_tools = {
    enable = true,
  }
}
