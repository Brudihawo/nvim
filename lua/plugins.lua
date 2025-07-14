local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  "folke/lazy.nvim",

  -- UI
  'hoob3rt/lualine.nvim',
  'kyazdani42/nvim-web-devicons',

  -- File Explorer
  { 'stevearc/oil.nvim',    config = function() require('oil').setup() end, dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Colorscheme
  'rktjmp/lush.nvim',
  'savq/melange',

  'norcalli/nvim-colorizer.lua',

  'b3nj5m1n/kommentary',

  -- Movement
  { "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc="Flash" },
    }
  },
  { 'ThePrimeagen/harpoon',    dependencies = { 'nvim-lua/plenary.nvim' } },

  -- LSP-y / Language specific stuff
  'neovim/nvim-lspconfig',
  'vhdirk/vim-cmake',
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },

  { 'inkarkat/vim-SpellCheck', dependencies = { 'inkarkat/vim-ingo-library' } },

  require('my_autocomplete'),

  'SirVer/ultisnips',

  'lervag/vimtex',
  { 'iamcco/markdown-preview.nvim', build = ":call mkdp#util#install()" },
    'mrjones2014/legendary.nvim',

  -- Debugging
  { 'mfussenegger/nvim-dap',                       lazy = false,                                        config = require('config.dap').setup },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = require('config.dapui').setup,
    lazy = false
  },
  { 'theHamsta/nvim-dap-virtual-text',             dependencies = { "mfussenegger/nvim-dap" } },

  { 'nvim-treesitter/nvim-treesitter',             build = ":TSUpdate", config=require('config.treesitter').config},
  { 'nvim-treesitter/nvim-treesitter-refactor',    dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('neogen').setup {}
    end
  },

  -- libraries
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',

  -- Telescope
  'nvim-telescope/telescope.nvim',

  -- Quality of life
  'junegunn/vim-easy-align',
  'tpope/vim-repeat',
  'tpope/vim-surround',

  -- Git
  { 'TimUntersberger/Neogit', dependencies = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" }, config = function()
    require('neogit').setup {
      process_spinner = true,
    } end },
  'lewis6991/gitsigns.nvim',
  'tpope/vim-git',
  'FabijanZulj/blame.nvim',

  { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' }
}
