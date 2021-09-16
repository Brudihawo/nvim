-- Remappings 
local function set_km(mode, keytbl, nrm, slnt)
  for key, map in pairs(keytbl) do
    vim.api.nvim_set_keymap(mode, key, map, { noremap = nrm, silent = slnt })
  end
end

-- Leader Key
vim.g.mapleader=" "
-- Normal mode Mappings
n_key_tbl = {
-- line highlighting and numbers
  ['<leader>ct'] = ':ColorizerToggle<CR>',

-- Decrementing Number
  ['<C-Q>'] = '<C-x>',

-- Buffer management
  ['<C-j>'] = ':BufferNext<CR>',
  ['<C-k>'] = ':BufferPrevious<CR>',
  ['<C-x>'] = ':bdelete<CR>',

-- Diff functionality
  ['<leader>dgj'] = ':diffget //2<CR>',
  ['<leader>dgk'] = ':diffget //3<CR>',

-- Format line breaks for text sections
  ['<A-Enter>'] = '^g$a<Enter><Esc>',
  ['dAW'] = ':%s/\\s\\+$//g<CR>',

-- Resizing
  ['<A-J>'] = ':resize +3<CR>',
  ['<A-K>'] = ':resize -3<CR>',
  ['<A-H>'] = ':vertical resize -3<CR>',
  ['<A-L>'] = ':vertical resize +3<CR>',

-- Quickfix lists
  ['<leader>co'] = ':copen<CR>',
  ['<leader>cc'] = ':cclose<CR>',
  ['<leader>lo'] = ':lopen<CR>',
  ['<leader>cc'] = ':lclose<CR>',
  ['<leader>cn'] = ':cnext<CR>',
  ['<leader>cp'] = ':cprev<CR>',
  ['<leader>ln'] = ':lnext<CR>',
  ['<leader>lp'] = ':lprev<CR>',

-- Debugger
  ['<F2>'] = '<cmd>lua require("dap").toggle_breakpoint()<cr>',
  ['<F4>'] = '<cmd>lua require("dap").disconnect()<CR>:lua require("dap").close()<cr>:lua require("dapui").close()<cr>',
  ['<F5>'] = '<cmd>lua require("dap").continue()<cr>',
  ['<F6>'] = '<cmd>lua require("dap").run()<cr>',
  ['<F8>'] = '<cmd>lua require("dap").step_into()<cr>',
  ['<F9>'] = '<cmd>lua require("dap").step_over()<cr>',
  ['<F10>'] = '<cmd>lua require("dap").step_out()<cr>',
	['<F11>'] = '<cmd>lua require("dap").run_to_cursor()<cr>',

-- Tagbar
  ['<leader>bo'] = ':Tagbar<CR> ', -- Bar open
  ['<leader>st'] = ':TagbarShowTag<CR>', -- " Show tag

-- LSP
  ['gD'] = ':lua vim.lsp.buf.declaration()<cr>',
  ['gd'] = ':lua vim.lsp.buf.definition()<cr>',
  ['Lrn'] = ':Lspsaga rename<CR>',
  ['<A-d>'] = '<cmd>lua require("lspsaga.provider").preview_definition()<CR>',
  ['Lsr'] = '<cmd> lua vim.lsp.buf.references()<CR>',

  ['Lf'] = ':lua vim.lsp.buf.formatting()<CR>',
  ['Llf'] = '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>',
  ['Ldn'] = ':lua vim.lsp.buf.diagnostic.goto_next()<CR>',
  ['Ldp'] = ':lua vim.lsp.buf.diagnostic.goto_prev()<CR>',
  ['Ldl'] = ':lua vim.lsp.diagnostic.set_loclist()<CR>',
  ['Lld'] = ':Lspsaga show_line_diagnostics<CR>',
  ['Lcd'] = ':Lspsaga show_cursor_diagnostics<CR>',
  ['Lsd'] = ':Lspsaga hover_doc<CR>',
  ['Lsh'] = ':lua require("lspsaga.signaturehelp").signature_help()<CR>',

-- Fuzzy Finding
  ['<C-p>'] = ':lua require("telescope.builtin").find_files()<cr>',
  ['<C-g>'] = ':lua require("telescope.builtin").live_grep()<cr>',
  ['<C-b>'] = '<cmd>Telescope buffers<cr> ',
  ['thh'] = '<cmd>Telescope help_tags<cr>',
  ['tjj'] = '<cmd>Telescope lsp_document_symbols<cr>',
  ['tdd'] = '<cmd>Telescope lsp_document_diagnostics<cr>',
  ['tkm'] = '<cmd>Telescope keymaps<cr>',
  ['tee'] = '<cmd>lua require("telescope.builtin").find_files({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*" }})<CR>',
  ['teg'] = '<cmd>lua require("telescope.builtin").live_grep({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*" }})<CR>',
  ['tgs'] = '<cmd>lua require("telescope.builtin").grep_string()<CR>',
  ['tkk'] = '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({sort="ascending"})<cr>',

-- Git
  ['gst'] = ':GitGutterSignsToggle<cr>',
  ['gtt'] = ':GitGutterToggle<cr>',
  ['gsh'] = ':GitGutterStageHunk<cr>',
  ['gph'] = ':GitGutterPreviewHunk<cr>',

-- Hop.nvim
  ['HH'] = ':HopWord<cr>',
  ['Hc'] = ':HopChar1<cr>',
  ['Hl'] = ':HopLine<cr>',
  ['Hp'] = ':HopPattern<cr>',
  ['He'] = '<cmd>lua require("hop").hint_patterns({},"\\\\([^ ][ ()\\\\[\\\\]={}/]\\\\|[^ ]$\\\\)")<cr>', -- Hop to End of words
  ['Hw'] = '<cmd>lua require("hop").hint_patterns({},"\\\\s\\\\+")<cr>', -- Hop to Whitespace

-- Buffer Picking (via Barbar)
  ['Hb'] = ':BufferPick<cr>',

-- Toggle Minimap
  ['<leader>mt'] = ':MinimapToggle<CR>',

-- Vimtex
  ['<A-t>'] = '<cmd>VimtexTocToggle<CR>',

}

-- Insert mode Mappings
i_key_tbl = {
-- Select first completion suggestion
  ['<A-Enter>'] = '<Down><Enter>',

-- Open Signature Help
  ['<A-h>'] = '<cmd>lua require(\'lspsaga.signaturehelp\').signature_help()<CR>',
  ['<A-d>'] = '<cmd>Lspsaga preview_definition<CR>',

-- Go to end of line
  ['<C-l>'] = '<esc>A',
  ['<C-h>'] = '<esc>I',
}

-- Actually settings the keymaps
set_km("n", n_key_tbl, true, false)
set_km("i", i_key_tbl, true, false)
-- set_km("x", x_key_tbl, true, false)

return {
  normal = n_key_tbl,
  insert = i_key_tbl,
  ex = x_key_tbl
}
