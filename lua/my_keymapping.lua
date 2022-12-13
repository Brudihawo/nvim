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

local dap = require('dap')

local function load_debug_configs()
  local config_path = require('my_funcs').find_in_parents("launch.json")
  if config_path ~= nil then
    require("dap.ext.vscode").load_launchjs(config_path, { lldb = { "cpp", "c" } })
    print("Loaded " .. config_path)
  else
    print("Could not find launch.json")
  end
end

require('nest').applyKeymaps {
  { '<leader>', {
    { 'p', function() require('nabla').popup() end },
    { 'f', function() print(vim.fn.bufname()) end },
    { 'mm', function() require('my_funcs').man_split() end },
    { 'ct', '<cmd>ColorizerToggle' }, -- Toggle Coloring of Hex-Values etc
    { 'cw', function() highlight_trailws() end },
    { 'nb', function() require('my_funcs').new_buf_cmd() end },
    { 'h', {
      { 'h', require("harpoon.mark").add_file },
      { 'm', require("harpoon.ui").toggle_quick_menu },
    } },

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

    -- Vimtex
    { 'v', {
      { 'c', '<plug>(vimtex-compile>' },
      { 'v', '<plug>(vimtex-view>' },
    } },

    { 'r', { -- Refactoring.nvim
      { 'r', require('refactoring').select_refactor, mode = 'v' },
    } },

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
  } },

  { 'L', {
    -- LSP commands (might move away in future - doesnt really seem to be necessary)
    { 'rn', vim.lsp.buf.rename },
    { 'rr', vim.lsp.buf.references },

    { 'h', vim.lsp.buf.hover },

    { 'v', peek_def }, -- View

    { 'ci', vim.lsp.buf.incoming_calls },
    { 'co', vim.lsp.buf.outgoing_calls },
    { 'ca', vim.lsp.buf.code_action },

    { 'p', { -- Populate Quickfixlist
      { 'w', function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN }) end },
      { 'e', function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end },
    } },

    { 'l', { -- Populate Locallist
      { 'w', function() vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.WARN }) end },
      { 'e', function() vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR }) end },
    } },

    { 'd', function() vim.diagnostic.open_float(0, { scope = "line" }) end },
    { 'f', function() vim.lsp.buf.format { async = true } end },
  } },

  { '<C-', {
    { 'q>', '<C-x>' }, -- Decrement Number

    -- Buffer management
    { 'j>', '<cmd>bnext<CR>' },
    { 'k>', '<cmd>bprev<CR>' },
    { 'x>', '<cmd>bdelete<CR>' },

    -- Fuzzy Finding Shortcuts
    { 'p>', require("telescope.builtin").find_files },
    { 'g>', require("telescope.builtin").live_grep },
    { 'b>', '<cmd>Telescope buffers<CR>' },
  } },


  -- Extended Fuzzy Finding
  { 't', {
    { 'hh', '<cmd>Telescope help_tags<CR>' },
    { 'km', '<cmd>Telescope keymaps<CR>' },
    { 's', '<cmd>Telescope lsp_document_symbols<CR>' },
    { 'dd', '<cmd>Telescope lsp_document_diagnostics<CR>' },
    { 'o', '<cmd>Telescope buffers<CR>' },

    { 'e', { -- Edit Config
      { 'e',
        function() require("telescope.builtin").find_files({ cwd = "~/dotfiles/nvim",
            file_ignore_patterns = { "pack/*", ".git/*" } })
        end },
      { 'g',
        function() require("telescope.builtin").live_grep({ cwd = "~/dotfiles/nvim",
            file_ignore_patterns = { "pack/*", ".git/*" } })
        end },
    } },

    { 'gs', require("telescope.builtin").grep_string },
    { 'kk', function() require("telescope.builtin").current_buffer_fuzzy_find({ sort = "ascending" }) end },
  } },

  -- Debugging
  { '<F2>', dap.toggle_breakpoint },
  { '<F3>', require('dapui').eval },
  { '<F4>', dap.disconnect },
  { '<F5>', dap.continue },
  { '<F6>', load_debug_configs },
  { '<F8>', dap.step_into },
  { '<F9>', dap.step_over },
  { '<F10>', dap.step_out },
  { '<F11>', dap.run_to_cursor },

  { 'dAW', ':%s/\\s\\+$//g<CR>' }, -- Delete all whitespace

  -- Quickfix and Locallist movement
  { ',', '<cmd>cnext<CR>' },
  { ';', '<cmd>cprev<CR>' },

  { 'ü', '<cmd>lnext<CR>' },
  { 'Ü', '<cmd>lprev<CR>' },


  { 'g', { -- ga ... for vim-easy-align
    -- Go to Declaration / Definition
    { 'D', vim.lsp.buf.declaration },
    { 'd', vim.lsp.buf.definition },
    { 'i', vim.lsp.buf.implementation },

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
      { 'n>', function() require('luasnip').jump(1) end },
      { 'p>', function() require('luasnip').jump(-1) end },
      { 'x>', function() require('luasnip').expand() end },
    } },
    { '<A-', {
      { 'h>', vim.lsp.buf.signature_help },
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
  --   { "<Tab>", require('my_funcs').tab_complete },
  --   { "<S-Tab>", require('my_funcs').s_tab_complete },
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
