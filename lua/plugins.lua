return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- UI
  use 'hoob3rt/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Colorscheme
  use 'rktjmp/lush.nvim'
  use 'savq/melange'

  use { 'ms-jpq/coq_nvim', run=":COQdeps" }

  use 'norcalli/nvim-colorizer.lua'
  use 'lukas-reineke/indent-blankline.nvim'

  use 'b3nj5m1n/kommentary'

  -- use 'ggandor/lightspeed.nvim'
  use 'ggandor/leap.nvim'

  -- LSP-y / Language specific stuff
  use 'neovim/nvim-lspconfig'
  use 'folke/lsp-colors.nvim'
  use 'ray-x/lsp_signature.nvim'
  use 'vhdirk/vim-cmake'

  use 'lervag/vimtex'
  use 'jalvesaq/zotcite'

  use { 'iamcco/markdown-preview.nvim', run=":call mkdp#util#install()" }

  use 'karb94/neoscroll.nvim'
  use 'LionC/nest.nvim'
  
  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  use { 'nvim-treesitter/nvim-treesitter', run=":TSUpdate" }
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'

  -- More used libraries
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  -- Telescope
  use 'fhill2/telescope-ultisnips.nvim'
  use 'nvim-telescope/telescope.nvim'

  use 'sirver/ultisnips'

  -- Quality of life
  use 'junegunn/vim-easy-align'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- Git
  use 'TimUntersberger/Neogit'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-git'
end)
