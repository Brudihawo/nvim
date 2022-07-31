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
  use { 'inkarkat/vim-SpellCheck', requires = { { 'inkarkat/vim-ingo-library' } } }

  -- autocompletion
  use 'ms-jpq/coq_nvim'

  use 'SirVer/UltiSnips'

  -- C / CPP switch between header and source
  use { 'jakemason/ouroboros', requires = { { 'nvim-lua/plenary.nvim' } } }

  use 'lervag/vimtex'
  use 'jalvesaq/zotcite'

  use { 'iamcco/markdown-preview.nvim', run = "<cmd>call mkdp#util#install()<CR>" }

  use 'karb94/neoscroll.nvim'
  use 'LionC/nest.nvim'

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  use { 'nvim-treesitter/nvim-treesitter', run = ":TSUpdate" }
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'
  use { 'Badhi/nvim-treesitter-cpp-tools', requires = { "nvim-treesitter/nvim-treesitter" } }


  -- More used libraries
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  -- Telescope
  use 'nvim-telescope/telescope.nvim'

  use 'L3MON4D3/LuaSnip'

  -- Quality of life
  use 'junegunn/vim-easy-align'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- Git
  use 'TimUntersberger/Neogit'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-git'
  -- use 'gisphm/vim-gitignore'
end)
