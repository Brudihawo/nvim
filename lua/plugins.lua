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

  -- Colorscheme
  'rktjmp/lush.nvim',
  'savq/melange',

  'norcalli/nvim-colorizer.lua',

  'b3nj5m1n/kommentary',

  -- Movement
  'ggandor/leap.nvim',
  { 'ThePrimeagen/harpoon',    dependencies = { 'nvim-lua/plenary.nvim' } },

  -- LSP-y / Language specific stuff
  'neovim/nvim-lspconfig',
  'folke/lsp-colors.nvim',
  'ray-x/lsp_signature.nvim',
  'vhdirk/vim-cmake',
  { 'ThePrimeagen/refactoring.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    }
  },

  'simrat39/symbols-outline.nvim',

  { 'inkarkat/vim-SpellCheck', dependencies = { 'inkarkat/vim-ingo-library' } },

  -- autocompletion
  {
    'ms-jpq/coq_nvim',
    dependencies = { { "ms-jpq/coq.thirdparty", branch = "3p" } },
    build = ":COQdeps"
  },
  'L3MON4D3/LuaSnip',

  'lervag/vimtex',
  'jbyuki/nabla.nvim',
  -- 'jalvesaq/zotcite',

  'rareitems/anki.nvim',

  { 'iamcco/markdown-preview.nvim',                build = ":call mkdp#util#install()" },

  'mrjones2014/legendary.nvim',

  -- Debugging
  { 'mfussenegger/nvim-dap',                       lazy = false },
  -- { 'rcarriga/nvim-dap-ui',                        dependencies = { "mfussenegger/nvim-dap" },          config = true, lazy = false },
  { 'theHamsta/nvim-dap-virtual-text',             dependencies = { "mfussenegger/nvim-dap" } },

  { 'nvim-treesitter/nvim-treesitter',             build = ":TSUpdate" },
  { 'nvim-treesitter/nvim-treesitter-refactor',    dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  { 'nvim-treesitter/playground',                  dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  { 'Badhi/nvim-treesitter-cpp-tools',             dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('neogen').setup {}
    end
  },

  -- More used libraries
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',

  -- Telescope
  'nvim-telescope/telescope.nvim',

  -- Quality of life
  'junegunn/vim-easy-align',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'anuvyklack/hydra.nvim',
  'folke/which-key.nvim',

  -- Git
  'TimUntersberger/Neogit',
  'lewis6991/gitsigns.nvim',
  'tpope/vim-git',

  { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' }
}
