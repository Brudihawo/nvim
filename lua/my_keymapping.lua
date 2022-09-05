-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('line_manipulation')

local api = vim.api
local function confirm(message)
  print(message)
  return vim.fn.inputlist({ "1. yes", "2. no" }) == 1
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

local function preview_def_callback(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(ctx.request, 'Could not find definition')
    return nil
  end


  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
    print(vim.inspect(result[1]))
  else
    print("One found")
    print(vim.inspect(result))
    vim.lsp.util.preview_location(result.location)
  end
end

local function peek_def()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_def_callback)
end

local function search_to_loclist()
  local term = vim.fn.input("Search String: ", "")
  vim.cmd("lexpr []")
  vim.cmd(":g/" .. term ..
    '/laddexpr expand("%") . ":" . line(".") . ":" . getline(".")')
end

require('nest').applyKeymaps {
  { '<leader>', {
    { 'mm', function() require('my_funcs').man_split() end },
    { 'ct', '<cmd>ColorizerToggle' }, -- Toggle Coloring of Hex-Values etc
    { 'cw', function() highlight_trailws() end },
    { 'nb', function() require('my_funcs').new_buf_cmd() end },

    -- Quickfix / Locallist Open / Close
    { 'c', {
      { 'o', '<cmd>copen<CR>' },
      { 'c', '<cmd>cclose<CR>' },
    } },
    { 'l', {
      { 'o', '<cmd>lopen<CR>' },
      { 'c', '<cmd>lclose<CR>' },
      { 's', search_to_loclist },
    } },

    { 's', { -- Ouroboros
      { 'w', '<cmd>Ouroboros<CR>' },
      { 's', '<cmd>vsplit | Ouroboros<CR>' },
      { 'h', '<cmd>split | Ouroboros<CR>' },
    } },

    -- Vimtex
    { 'v', {
      { 'c', '<plug>(vimtex-compile>' },
      { 'v', '<plug>(vimtex-view>' },
    } },

    -- Code Minimap
    { 'mt', '<cmd>MinimapToggle<CR>' },

    -- Create dot / neato Graph
    { 'gd', function() graphviz_graph("dot") end },
    { 'gn', function() graphviz_graph("neato") end },
    { 'gt', function() graphviz_graph("twopi") end },

    -- LazyGit
    { 'gg', '<cmd>LazyGit<CR>' },

    -- Tagbar
    { 'bo', ':Tagbar<CR>' }, -- Bar open
    { 'st', ':TagbarShowTag<CR>' }, -- " Show tag

  } },

  { '<A-', {
    -- Resizing
    { 'J>', '<cmd>resize +3<CR>' },
    { 'K>', '<cmd>resize -3<CR>' },
    { 'H>', '<cmd>vertical resize -3<CR>' },
    { 'L>', '<cmd>vertical resize +3<CR>' },

    { 't>', '<cmd>VimtexTocToggle<CR>' }, -- Vimtex toggle Table of Contents


    { 'Enter>', '^g$a<Enter><Esc>' }, -- Add line break so that it fits on screen
  } },

  { 'L', {
    -- LSP commands (might move away in future - doesnt really seem to be necessary)
    { 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },

    { 'h', '<cmd>lua vim.lsp.buf.hover()<CR>' },

    { 'pd', peek_def },

    { 'ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>' },
    { 'co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>' },

    { 'sr', '<cmd>lua vim.lsp.buf.references()<CR>' },
    { 'dn', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
    { 'dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },

    { 'p', { -- Populate Quickfix / Locallist
      { 'l', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
      { 'q', '<cmd>lua vim.diagnostic.setqflist()<CR>' },
    } },

    { 'ld', '<cmd>lua vim.diagnostic.open_float(0, { scope="line" })<CR>' },
    { 'f', '<cmd>lua vim.lsp.buf.format{async=true}<CR>' },
  } },

  { '<C-', {
    { 'q>', '<C-x>' }, -- Decrement Number

    -- Buffer management
    { 'j>', '<cmd>bnext<CR>' },
    { 'k>', '<cmd>bprev<CR>' },
    { 'x>', '<cmd>bdelete<CR>' },

    -- Fuzzy Finding Shortcuts
    { 'p>', '<cmd>lua require("telescope.builtin").find_files()<CR>' },
    { 'g>', '<cmd>lua require("telescope.builtin").live_grep()<CR>' },
    { 'b>', '<cmd>Telescope buffers<CR>' },
  }},

  { '<C-h>', {
    { 'h', '<cmd> lua require("harpoon.mark").add_file()<CR>' },
    { 'm', '<cmd> lua require("harpoon.ui").toggle_quick_menu()<CR>' },
  } },
  -- Extended Fuzzy Finding
  { 't', {
    { 'hh', '<cmd>Telescope help_tags<CR>' },
    { 'km', '<cmd>Telescope keymaps<CR>' },
    { 'jj', '<cmd>Telescope lsp_document_symbols<CR>' },
    { 'dd', '<cmd>Telescope lsp_document_diagnostics<CR>' },
    { 'o', '<cmd>Telescope buffers<CR>' },

    { 'e', { -- Edit Config
      { 'e',
        '<cmd>lua require("telescope.builtin").find_files({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*", ".git/*" }})<CR>' },
      { 'g',
        '<cmd>lua require("telescope.builtin").live_grep({ cwd = "~/dotfiles/nvim", file_ignore_patterns = { "pack/*", ".git/*" }})<CR>' },
    } },

    { 'gs', '<cmd>lua require("telescope.builtin").grep_string()<CR>' },
    { 'kk', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({sort="ascending"})<CR>' },
  } },

  -- Debugging
  { '<F2>', '<cmd>lua require("dap").toggle_breakpoint()<CR>' },
  { '<F3>', '<cmd>lua require("dap.ui.widgets").hover()<CR>' },
  { '<F4>', '<cmd>lua require("dap").disconnect()<CR>:lua require("dap").close()<CR>' },
  { '<F5>', '<cmd>lua require("dap").continue()<CR>' },
  { '<F6>', '<cmd>lua require("dap").run()<CR>' },
  { '<F8>', '<cmd>lua require("dap").step_into()<CR>' },
  { '<F9>', '<cmd>lua require("dap").step_over()<CR>' },
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

    -- Gitgutter
    { 't', '<cmd>Gitsigns toggle_signs<CR>' },

    { 'h', { -- Gitsigns Hunk Actions
      { 'p', '<cmd>Gitsigns prev_hunk<CR>' }, -- Move to Previous
      { 'n', '<cmd>Gitsigns next_hunk<CR>' }, -- Move to Next
      { 's', '<cmd>Gitsigns stage_hunk<CR>' }, -- Stage
      { 'u', '<cmd>Gitsigns undo_stage_hunk<CR>' }, -- Undo Stage 
      { 'r', '<cmd>Gitsigns reset_hunk<CR>' }, -- Undo Stage 
    } },
    { 'b', '<cmd>Gitsigns blame_line<CR>' },

    { 'q', { -- Quickfix Actions
      { 'q', '<cmd>Gitsigns setqflist<CR>' },
    } },
    { 'f', '<cmd>e <cfile><CR>' },
  } },

  { "==", '<cmd>Gitsigns preview_hunk<CR>' },

  { mode = 'i', {
    { '<A-', {
      { 'h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
    } },
  } },


  { mode = 'n', {
    { 'gcc', '<Plug>kommentary_line_default' },
    { 'gc', '<Plug>kommentary_motion_default' },
  } },
  { mode = 'v', {
    { 'gc', '<Plug>kommentary_visual_default<CR>' },
  } },
  { mode = 'vn', {
    { 'ga', '<cmd>EasyAlign<CR>' },
  } },
  { mode = 'n', options = { noremap = false }, {
    { '<leader>lb', '<Plug>HInsertLineBreak' },
  } },
  -- { mode = 'i', options = { noremap = true, silent = true },
  --   { "<Tab>", "<cmd>lua require('my_funcs').tab_complete()<CR>" },
  --   { "<S-Tab>", "<cmd>lua require('my_funcs').s_tab_complete()<CR>" },
  -- }
}


-- Extend text objects
local surround_pairs = {
  [':']     = ':',
  [';']     = ';',
  ['.']     = '.',
  [',']     = ',',
  ['/']     = '/',
  ['<bar>'] = '<bar>',
  ['_']     = '_',
  ['-']     = '-',
  ['>']     = '<',
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
