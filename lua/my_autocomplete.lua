return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require('cmp')

    cmp.setup {
      window = {},
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
      mapping = {
        ['<tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<s-tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<CR>'] = cmp.mapping.confirm(),
      },
      matching = {
        disallow_fullfuzzy_matching = false,
        disallow_fuzzy_matching = false
      },
      sorting = {
        priority_weight = 4.0
      }

    }
    cmp.setup.cmdline({ ':', '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
        { name = 'path' },
        { name = "cmdline" },
      }
    })
  end
}
