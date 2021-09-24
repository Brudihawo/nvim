-- Leader Key
vim.g.mapleader=" "
vim.g.maplocalleader=" "

require('nest').applyKeymaps{
  { '<leader>', {
    { 'ct', '<cmd>ColorizerToggle' }, -- Toggle Coloring of Hex-Values etc

    -- Quickfix / Locallist Open / Close
    { 'c', {
      { 'o', '<cmd>copen<CR>' },
      { 'c', '<cmd>cclose<CR>' },
    }},
    { 'l', {
      { 'o', '<cmd>lopen<CR>' },
      { 'c', '<cmd>lclose<CR>' },
    }},

    -- Code Minimap
    { 'mt', '<cmd>MinimapToggle<CR>' },

-- Tagbar
  ['<leader>bo'] = ':Tagbar<CR> ', -- Bar open
  ['<leader>st'] = ':TagbarShowTag<CR>', -- " Show tag
  }},
  { '<A-', {
    -- Resizing
    { 'J>', '<cmd>resize +3<CR>' },
    { 'K>', '<cmd>resize -3<CR>' },
    { 'H>', '<cmd>vertical resize -3<CR>' },
    { 'L>', '<cmd>vertical resize +3<CR>' },

    { 't>', '<cmd>VimtexTocToggle<CR>' }, -- Vimtex toggle Table of Contents

    { 'd>', '<cmd>lua require("lspsaga.provider").preview_definition()<CR>' }, -- Preview Definition with Lspsaga

    { 'Enter>', '^g$a<Enter><Esc>' }, -- Add line break so that it fits on screen
  }},

  { 'L', {
    -- Lspsaga commands (might move away in future - doesnt really seem to be necessary)
    { 'rn', '<cmd>Lspsaga rename<CR>' },
    { 'lf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>' },
    { 'sh', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>' },
    { 'sd', '<cmd>Lspsaga hover_doc<CR>' },

    { 'sr', '<cmd> lua vim.lsp.buf.references()<CR>' },
    { 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },

    { 'p', { -- Populate Quickfix / Locallist
      { 'q', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
      { 'l', '<cmd>lua vim.diagnostic.setqflist()<CR>' },
    }},

    { 'ld', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>' },
    { 'f', '<cmd>lua vim.lsp.buf.formatting()<CR>' },
  }},

  { '<C-', {
    { 'q>', '<C-x>' }, -- Decrement Number

    -- Buffer management
    { 'j>', '<cmd>BufferNext<CR>' },
    { 'k>', '<cmd>BufferPrevious<CR>' },
    { 'x>', '<cmd>bdelete<CR>' },

    -- Fuzzy Finding Shortcuts
    { 'p>', '<cmd>lua require("telescope.builtin").find_files()<cr>' },
    { 'g>', '<cmd>lua require("telescope.builtin").live_grep()<cr>' },
    { 'b>', '<cmd>Telescope buffers<cr> ' },
  }},

  -- Extended Fuzzy Finding
  { 't', {
    { 'hh', '<cmd>Telescope help_tags<cr>' },
    { 'km', '<cmd>Telescope keymaps<cr>' },
    { 'jj', '<cmd>Telescope lsp_document_symbols<cr>' },
    { 'dd', '<cmd>Telescope lsp_document_diagnostics<cr>' },

    { 'e', { -- Edit Config
      { 'e', '<cmd>lua require("telescope.builtin").find_files({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*" }})<CR>' },
      { 'g', '<cmd>lua require("telescope.builtin").live_grep({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*" }})<CR>' },
    }},

    { 'gs', '<cmd>lua require("telescope.builtin").grep_string()<CR>' },
    { 'kk', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({sort="ascending"})<cr>' },
  }},

  -- Debugging
  { '<F2>',  '<cmd>lua require("dap").toggle_breakpoint()<cr>' },
  { '<F4>',  '<cmd>lua require("dap").disconnect()<CR>:lua require("dap").close()<cr>:lua require("dapui").close()<cr>' },
  { '<F5>',  '<cmd>lua require("dap").continue()<cr>' },
  { '<F6>',  '<cmd>lua require("dap").run()<cr>' },
  { '<F8>',  '<cmd>lua require("dap").step_into()<cr>' },
  { '<F9>',  '<cmd>lua require("dap").step_over()<cr>' },
  { '<F10>', '<cmd>lua require("dap").step_out()<cr>' },
	{ '<F11>', '<cmd>lua require("dap").run_to_cursor()<cr>' },

  { 'dAW', ':%s/\\s\\+$//g<CR>' }, -- Delete all whitespace

  -- Quickfix and Locallist movement
  { ',', '<cmd>cnext<CR>' },
  { ';', '<cmd>cprev<CR>' },

  { 'ü', '<cmd>lnext<CR>' },
  { 'Ü', '<cmd>lprev<CR>' },


  { 'g', {
    { 'D', '<cmd>lua vim.lsp.buf.declaration()<cr>' },
    { 'd', '<cmd>lua vim.lsp.buf.definition()<cr>' },
  -- Git (-gutter)
    { 's', {
      { 't', ':GitGutterSignsToggle<cr>' },
      { 'h', ':GitGutterStageHunk<cr>' },
    }},

    { 't', ':GitGutterToggle<cr>' },
    { 'ph', ':GitGutterPreviewHunk<cr>' },
  }},

  { mode='i', {
    { '<A-', {
      { 'd>', '<cmd>Lspsaga preview_definition<CR>' }, -- Lspsaga Definition (might change)
      { 'h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    }},
  }},
}

-- Extend text objects
surround_pairs = {
  [':'] = ':',
  [';'] = ';',
  ['.'] = '.',
  [','] = ',',
  ['/'] = '/',
  ['<bar>'] = '<bar>',
  ['_'] = '_',
  ['-'] = '-',
  ['>'] = '<',
}

for key, value in pairs(surround_pairs) do
  for _, action in ipairs({ "c", "d", "v", "y" }) do
    vim.api.nvim_set_keymap("n", action .. 'i' .. key,
                                 'T' .. key .. action .. 't' .. value,
                                 { noremap = true, silent = false })
    vim.api.nvim_set_keymap("n", action .. 'a' .. key,
                                 'F' .. key .. action .. 'f' .. value,
                                 { noremap = true, silent = false })
  end
end
