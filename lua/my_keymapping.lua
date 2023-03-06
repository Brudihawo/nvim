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

local function get_visual_selection()
  local start = vim.fn.getpos("'<")
  local end_val = vim.fn.getpos("'>")
  print(vim.inspect(start) .. "\n" .. vim.inspect(end_val))
end

local function reload_config()
  for pkg, _ in pairs(package.loaded) do
    if string.match(pkg, '^my') then
      package.loaded[pkg] = nil
      require(pkg)
    end
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

vim.api.nvim_create_user_command("ReloadConfig", reload_config, {})
vim.api.nvim_create_user_command("GetVisual", get_visual_selection, {})
vim.api.nvim_create_user_command("RegClear", require('my_funcs').clear_registers, {})
vim.api.nvim_create_user_command("GraphDot", function() graphviz_graph("dot") end, {})
vim.api.nvim_create_user_command("GraphNeato", function() graphviz_graph("neato") end, {})
vim.api.nvim_create_user_command("GraphTwopi", function() graphviz_graph("twopi") end, {})


local hydra = require('hydra')
hydra({
  name = "Window Edit Mode",
  node = "n",
  body = "<C-w>",
  heads = {
    { "<Esc>", nil,                          { exit = true } },
    { 'J',     '<cmd>resize +3<CR>' },
    { 'K',     '<cmd>resize -3<CR>' },
    { 'H',     '<cmd>vertical resize -3<CR>' },
    { 'L',     '<cmd>vertical resize +3<CR>' },

    { 'j',     '<C-w>j' },
    { 'k',     '<C-w>k' },
    { 'h',     '<C-w>h' },
    { 'l',     '<C-w>l' },

    { '<C-j>',     '<C-w>J' },
    { '<C-k>',     '<C-w>K' },
    { '<C-h>',     '<C-w>H' },
    { '<C-l>',     '<C-w>L' },
  }
})

-- local dapui = require('dapui')

require('legendary').setup {
  keymaps = {
    { '<leader>N', require('nabla').toggle_virt },
    { '<leader>p', require('nabla').popup },
    { '<leader>f', function()
      print(vim.fn.bufname())
    end },
    { '<leader>m',  require('my_funcs').man_split },
    { '<leader>ct', '<cmd>ColorizerToggle<CR>' }, -- Toggle Coloring of Hex-Values etc
    { '<leader>cw', highlight_trailws },
    { '<leader>hn', require('my_funcs').new_buf_cmd },
    { '<leader>hh', require("harpoon.mark").add_file },
    { '<leader>hm', require("harpoon.ui").toggle_quick_menu },

    { '<leader>lo', '<cmd>lopen<CR>' },
    { '<leader>lc', '<cmd>lclose<CR>' },
    { '<leader>ls', search_to_loclist },

    -- todos to quickfix
    { '<leader>t', function()
      require('my_funcs').todos_qflist()
    end },

    { 'r<leader>',  require('refactoring').select_refactor, mode = 'v' },

    -- Create dot / neato Graph
    { '<leader>gd', function() graphviz_graph("dot") end },
    { '<leader>gn', function() graphviz_graph("neato") end },
    { '<leader>gt', function() graphviz_graph("twopi") end },

    -- Quickfix / Locallist Open / Close
    { 'co',         '<cmd>copen<CR>' },
    { 'cd',         '<cmd>cclose<CR>' },

    { '<A-t>',      '<cmd>VimtexTocToggle<CR>' }, -- Vimtex toggle Table of Contents

    -- LSP commands (might move away in future - doesnt really seem to be necessary)
    { 'Lrn',        vim.lsp.buf.rename },
    { 'Lrr',        vim.lsp.buf.references },
    { 'Lh',         vim.lsp.buf.hover },
    { 'Lv',         peek_def }, -- View
    { 'Lci',        vim.lsp.buf.incoming_calls },
    { 'Lco',        vim.lsp.buf.outgoing_calls },
    { 'Lca',        vim.lsp.buf.code_action },

    -- Populate Quickfixlist
    { 'Lpw', function()
      vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
    end },
    { 'Lpe', function()
      vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
    end },

    -- Populate Locallist
    { 'Llw', function()
      vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.WARN })
    end },
    { 'Lle', function()
      vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
    end },

    { 'Ld', function()
      vim.diagnostic.open_float(0, { scope = "line" })
    end },
    { 'Lf', function()
      vim.lsp.buf.format { async = true }
    end },

    { '<C-q>', '<C-x>',                                  desc = 'decrement number', opts = { noremap = true } }, -- Decrement Number
    -- Buffer management
    { '<C-j>', '<cmd>bnext<CR>' },
    { '<C-k>', '<cmd>bprev<CR>' },
    { '<C-x>', '<cmd>bdelete<CR>' },



    -- Fuzzy Finding Shortcuts
    { '<C-p>', require("telescope.builtin").find_files },
    { '<C-g>', require("telescope.builtin").live_grep },


    -- Extended Fuzzy Finding
    { 'th',    '<cmd>Telescope help_tags<CR>' },
    { 'to',    '<cmd>Telescope buffers<CR>' },
    { 'tkm',   '<cmd>Telescope keymaps<CR>' },
    { 'ts',    '<cmd>Telescope lsp_document_symbols<CR>' },

    -- Edit Config
    { 'tee',
      function()
        require("telescope.builtin").find_files({
          cwd = "~/dotfiles/nvim",
          file_ignore_patterns = { "pack/*", ".git/*" }
        })
      end },
    { 'teg',
      function()
        require("telescope.builtin").live_grep({
          cwd = "~/dotfiles/nvim",
          file_ignore_patterns = { "pack/*", ".git/*" }
        })
      end },

    { 'tkk', function()
      require("telescope.builtin").current_buffer_fuzzy_find({ sort = "ascending" })
    end },

    -- Debugging
    { '<F1>', function()
      load_debug_configs()
      dap.continue()
    end },
    { '<F2>',  dap.toggle_breakpoint },
    -- { '<F3>',  dapui.eval },
    { '<F4>',  dap.disconnect },
    { '<F5>',  dap.continue },
    -- { '<F6>',  dapui.eval },
    { '<F7>',  dap.step_into },
    { '<F8>',  dap.step_over },
    { '<F9>',  dap.step_out },
    { '<F10>', dap.run_to_cursor },

    { 'dAW',   ':%s/\\s\\+$//g<CR>' }, -- Delete all whitespace

    -- Quickfix and Locallist movement
    { ',',     '<cmd>cnext<CR>' },
    { ';',     '<cmd>cprev<CR>' },

    { 'ü',    '<cmd>lnext<CR>' },
    { 'Ü',    '<cmd>lprev<CR>' },


    -- ga ... for vim-easy-align
    -- Go to Declaration / Definition
    { 'gD',    vim.lsp.buf.declaration },
    { 'gd',    vim.lsp.buf.definition },
    { 'gi',    vim.lsp.buf.implementation },

    -- Gitsigns
    { 'gs',    '<cmd>Gitsigns toggle_signs<CR>' },
    { 'gl',    get_visual_selection },

    -- TODO: Change these to something more ergonomic
    -- Gitsigns Hunk Actions
    { 'ghp',   '<cmd>Gitsigns prev_hunk<CR>' },
    { 'ghn',   '<cmd>Gitsigns next_hunk<CR>' },
    { 'ghs',   '<cmd>Gitsigns stage_hunk<CR>' },
    { 'ghu',   '<cmd>Gitsigns undo_stage_hunk<CR>' },
    { 'ghr',   '<cmd>Gitsigns reset_hunk<CR>' },
    { 'gb',    '<cmd>Gitsigns blame_line<CR>' },
    { "==",    '<cmd>Gitsigns preview_hunk<CR>' },

    -- Quickfix Actions
    { 'gq',    '<cmd>Gitsigns setqflist<CR>' },
    { 'gf',    '<cmd>e <cfile><CR>' },


    { '<C-t>', function()
      require('luasnip').jump(1)
    end, mode = 'i' },
    { '<C-s>', function()
      require('luasnip').jump( -1)
    end, mode = 'i' },
    { '<C-x>', function()
      require('luasnip').expand()
    end, mode = 'i' },
    { '<C-h>',      vim.lsp.buf.signature_help,            mode = 'i' },


    { 'gcc',        '<Plug>kommentary_line_default' },
    { 'gc',         '<Plug>kommentary_motion_default' },
    { 'gc',         '<Plug>kommentary_visual_default<CR>', mode = "v" },
    { 'ga',         '<cmd>EasyAlign<CR>',                  mode = { 'v', 'n' } },
    { '<leader>lb', '<Plug>HInsertLineBreak' },
  }
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
