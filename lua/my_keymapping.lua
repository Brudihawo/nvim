-- Leader Key
vim.g.mapleader=" "
vim.g.maplocalleader=" "

local api = vim.api
local function confirm(message)
  print(message)
  return vim.fn.inputlist({"1. yes", "2. no"}) == 1
end

local function file_exists(fname)
  local f = io.open(fname, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function graphviz_graph(engine)
  local fname = vim.fn.bufname()
  local outfile_name = vim.fn.input("Output Filename: ", "", "file")

  if outfile_name == "" then
    if confirm("No output file specified. Use current file name?") then
      outfile_name = fname:gsub("%..+$", ".png")
      print(' -> \nOutputting to ' .. outfile_name .. ".")
    else
      print(" -> \nExecution cancelled.\n")
      return
    end
  end

  if file_exists(outfile_name) then
    if not confirm("File Exists. Overwrite?") then
      print(" -> \nExecution cancelled.\n")
      return
    else
      print(" -> \nOverwriting " .. outfile_name .. ".\n")
    end
  end

  local cmd = engine .. " -Tpng '" .. fname .. "' -o '" .. outfile_name .. "'"

  os.execute(cmd .. "> /dev/null")
end

local trailws_active = false
local function highlight_trailws()
  if trailws_active then
    vim.cmd("hi clear trailws")
    trailws_active = false
  else
    vim.cmd("hi trailws guibg='#fb4934'")
    vim.cmd("match trailws /\\s\\+$/")
    trailws_active = true
  end
end

local function add_linebreak(chars)
  -- TODO: Janky AF, do this only with lua
  local orig_pos = api.nvim_win_get_cursor(0)
  vim.cmd('/.\\{'..chars..',\\}')
  -- Something line for line in api.nvim_get_buf... if string.len(line) > chars ...

  local cur_pos = api.nvim_win_get_cursor(0)
  local line = api.nvim_buf_get_lines(0, cur_pos[1] - 1, cur_pos[1], true)[1]
  if string.len(line) > chars then
    api.nvim_feedkeys(api.nvim_replace_termcodes("0".. chars .. "lBBEa\n<Esc>", true, false, true), "n", true)
  end
  vim.cmd("noh")
  --api.nvim_win_set_cursor(0, orig_pos)
end

require('nest').applyKeymaps{
  { '<leader>', {
    { 'ct', '<cmd>ColorizerToggle' }, -- Toggle Coloring of Hex-Values etc
    { 'cw', function() highlight_trailws() end },
    { 'lb', function() add_linebreak(89) end },

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

    -- Create dot / neato Graph
    { 'gd', function() graphviz_graph("dot") end },
    { 'gn', function() graphviz_graph("neato") end },
    { 'gt', function() graphviz_graph("twopi") end },

    -- Tagbar
    { 'bo', ':Tagbar<CR>' }, -- Bar open
    { 'st', ':TagbarShowTag<CR>' }, -- " Show tag
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
    -- LSP commands (might move away in future - doesnt really seem to be necessary)
    { 'rn', '<cmd>Lspsaga rename<CR>' },
    { 'lf', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>' },
    { 'sh', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>' },
    { 'sd', '<cmd>Lspsaga hover_doc<CR>' },

    { 'sr', '<cmd> lua vim.lsp.buf.references()<CR>' },
    { 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },

    { 'p', { -- Populate Quickfix / Locallist
      { 'l', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
      { 'q', '<cmd>lua vim.diagnostic.setqflist()<CR>' },
    }},

    { 'ld', '<cmd>lua vim.diagnostic.open_float()<CR>' },
    { 'f', '<cmd>lua vim.lsp.buf.formatting()<CR>' },
  }},

  { '<C-', {
    { 'q>', '<C-x>' }, -- Decrement Number

    -- Buffer management
    { 'j>', '<cmd>BufferNext<CR>' },
    { 'k>', '<cmd>BufferPrevious<CR>' },
    { 'x>', '<cmd>bdelete<CR>' },

    -- Fuzzy Finding Shortcuts
    { 'p>', '<cmd>lua require("telescope.builtin").find_files()<CR>' },
    { 'g>', '<cmd>lua require("telescope.builtin").live_grep()<CR>' },
    { 'b>', '<cmd>Telescope buffers<CR> ' },
  }},

  -- Extended Fuzzy Finding
  { 't', {
    { 'hh', '<cmd>Telescope help_tags<CR>' },
    { 'km', '<cmd>Telescope keymaps<CR>' },
    { 'jj', '<cmd>Telescope lsp_document_symbols<CR>' },
    { 'dd', '<cmd>Telescope lsp_document_diagnostics<CR>' },

    { 'e', { -- Edit Config
      { 'e', '<cmd>lua require("telescope.builtin").find_files({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*", ".git/*" }})<CR>' },
      { 'g', '<cmd>lua require("telescope.builtin").live_grep({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*", ".git/*" }})<CR>' },
    }},

    { 'gs', '<cmd>lua require("telescope.builtin").grep_string()<CR>' },
    { 'kk', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({sort="ascending"})<CR>' },
  }},

  -- Debugging
  { '<F2>',  '<cmd>lua require("dap").toggle_breakpoint()<CR>' },
  { '<F4>',  '<cmd>lua require("dap").disconnect()<CR>:lua require("dap").close()<CR>:lua require("dapui").close()<CR>' },
  { '<F5>',  '<cmd>lua require("dap").continue()<CR>' },
  { '<F6>',  '<cmd>lua require("dap").run()<CR>' },
  { '<F8>',  '<cmd>lua require("dap").step_into()<CR>' },
  { '<F9>',  '<cmd>lua require("dap").step_over()<CR>' },
  { '<F10>', '<cmd>lua require("dap").step_out()<CR>' },
	{ '<F11>', '<cmd>lua require("dap").run_to_cursor()<CR>' },

  { 'dAW', ':%s/\\s\\+$//g<CR>' }, -- Delete all whitespace

  -- Quickfix and Locallist movement
  { ',', '<cmd>cnext<CR>' },
  { ';', '<cmd>cprev<CR>' },

  { 'ü', '<cmd>lnext<CR>' },
  { 'Ü', '<cmd>lprev<CR>' },


  { 'g', { -- ga ... for vim-easy-align
    -- Go to Declaration / Definition
    { 'D', '<cmd>lua vim.lsp.buf.declaration()<CR>' },
    { 'd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
    { 'i', '<cmd>lua vim.lsp.buf.implementation()<CR>' },

    -- Git (-gutter)
    { 't', {
      { 't', '<cmd>GitGutterSignsToggle<CR>' },
      { 'f', '<cmd>GitGutterFold<CR>' },
    }},

    { 'h', { -- GitGutter Hunk Actions
      { 'p', '<cmd>GitGutterPrevHunk<CR>' }, -- Move to Previous
      { 'n', '<cmd>GitGutterNextHunk<CR>' }, -- Move to Next
      { 's', '<cmd>GitGutterStageHunk<CR>' }, -- Stage
      { 'u', '<cmd>GitGutterUndoHunk<CR>' }, -- Undo
    }},

    { 'q', { -- Quickfix Actions
      { 'f', '<cmd>GitGutterQuickFixCurrentFile<CR>' },
      { 'q', '<cmd>GitGutterQuickFix<CR>' },
    }},

  }},

  { "==", '<cmd>GitGutterPreviewHunk<CR>' },

  { mode='i', {
    { '<A-', {
      { 'd>', '<cmd>Lspsaga preview_definition<CR>' }, -- Lspsaga Definition (might change)
      { 'h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    }},
  }},


  { mode='n', {
    { 'gcc', '<Plug>kommentary_line_default' },
    { 'gc', '<Plug>kommentary_motion_default' },
  }},
  { mode='v', {
    { 'gc', '<Plug>kommentary_visual_default<CR>' },
  }},
}

-- Extend text objects
local surround_pairs = {
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
    api.nvim_set_keymap("n", action .. 'i' .. key,
                                 'T' .. key .. action .. 't' .. value,
                                 { noremap = true, silent = false })
    api.nvim_set_keymap("n", action .. 'a' .. key,
                                 'F' .. key .. action .. 'f' .. value,
                                 { noremap = true, silent = false })
  end
end
