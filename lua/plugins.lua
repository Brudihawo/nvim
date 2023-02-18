return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- UI
  use 'hoob3rt/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Colorscheme
  use 'rktjmp/lush.nvim'
  use 'savq/melange'

  use 'norcalli/nvim-colorizer.lua'

  use 'b3nj5m1n/kommentary'

  -- Movement
  use 'ggandor/leap.nvim'
  use { 'ThePrimeagen/harpoon', requires = { { 'nvim-lua/plenary.nvim' } } }

  -- LSP-y / Language specific stuff
  use 'neovim/nvim-lspconfig'
  use 'folke/lsp-colors.nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'vhdirk/vim-cmake'
  use { 'ThePrimeagen/refactoring.nvim',
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  }
  use 'simrat39/symbols-outline.nvim'

  use { 'inkarkat/vim-SpellCheck', requires = { { 'inkarkat/vim-ingo-library' } } }

  -- autocompletion
  use {
    'ms-jpq/coq_nvim',
    requires = { { "ms-jpq/coq.thirdparty", branch = "3p" } },
    run = ":COQdeps"
  }
  use 'L3MON4D3/LuaSnip'

  use 'lervag/vimtex'
  use 'jbyuki/nabla.nvim'
  -- use 'jalvesaq/zotcite'

  use 'rareitems/anki.nvim'

  use { 'iamcco/markdown-preview.nvim', run = ":call mkdp#util#install()" }

  -- use 'karb94/neoscroll.nvim'
  use 'mrjones2014/legendary.nvim'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'
  use { 'Badhi/nvim-treesitter-cpp-tools', requires = { "nvim-treesitter/nvim-treesitter" } }
  use {
    'danymat/neogen',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('neogen').setup {}
    end
  }

  -- More used libraries
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  -- Telescope
  use 'nvim-telescope/telescope.nvim'

  -- Quality of life
  use 'junegunn/vim-easy-align'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- Git
  use 'TimUntersberger/Neogit'
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-git'

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
end)
