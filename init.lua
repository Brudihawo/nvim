vim.g.python3_host_prog = require('local').python3_host_prog
vim.opt.runtimepath:append(",~/.config/nvim/after/")
require('plugins')
local io = require('io')

vim.o.encoding = 'utf-8'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.linebreak = true
vim.o.wrap = true
vim.o.hidden = true
vim.o.compatible = false
vim.o.ignorecase = true
vim.o.conceallevel = 0
vim.o.title = true
vim.o.titlestring = "%F"
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.backspace = 'indent,eol,start'
vim.o.display = 'lastline'

-- vim.o.spelllang=de,en
vim.o.confirm = true
vim.o.ttimeout = true
vim.o.ttimeoutlen = 200

vim.o.shell = "/bin/bash"
vim.o.grepprg = "rg -i --vimgrep"

-- Markdown Preview
vim.g.mkdp_browser = 'firefox'

-- Updatetime
vim.o.updatetime = 800

-- Vim-cmake
vim.g.cmake_generate_options = { '-G', 'Ninja', '-B', 'build' }

-- Autocompletion
vim.o.completeopt = "menuone,noselect"

require('my_autocommands')
require('my_keymapping')

vim.api.nvim_create_user_command("Term", function(args)
  vim.cmd("split | term " .. args["args"])
end, { nargs = '?', complete = "shellcmd" })

vim.api.nvim_create_user_command("Py", function(args)
  vim.cmd("split | term python " .. args["args"])
end, { nargs = '?', complete = "shellcmd" })



require('harpoon').setup()

-- Kommentary Config
require('kommentary.config').configure_language('default', {
  prefer_single_line_comments = true,
})

require('blame').setup {
  date_format = "%H:%M %d.%m.%Y",
  virtual_style = "right_align"
}

require('gitsigns').setup({
  signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil,   -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
})

local oil = require 'oil'
local function oil_exec_cmd()
  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  local cwd = oil.get_current_dir()
  local filename = cwd .. entry.name
  local program = vim.fn.input("> ", "", "shellcmd")
  local cmd = program .. " '" .. filename .. "'"
  print("Executing " .. cmd)

  local handle = io.popen("cd '" .. cwd .. "' && " .. cmd)
  local output = handle:read('*a')
  handle:close()
  print(output)
end

require('oil').setup({
  columns = { "icon", "mtime", "size" },
  cleanup_delay_ms = 0,
  lsp_file_methods = { enabled = false, timeout_ms = 0 },
  keymaps = {
    ["gX"] = oil_exec_cmd
  }

})

require('my_telescope_config')
require('my_treesitter_config')
require('my_lsp_config')
require('my_vimtex')
require('my_debugging')
require('my_ui_visuals')
require('my_funcs')

-- Neogit Highlighting
vim.cmd("hi NeogitDiffAdd guibg='#78997a' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffDelete guibg='#7d2a2f' guifg='#f4f0ed'")
vim.cmd("hi NeogitDiffContextHighlight guibg='#4d453e'")

vim.cmd("hi NeogitHunkHeaderHighlight guibg='#697893'")
vim.api.nvim_set_hl(0, "@env_cmd.latex", { link = "keyword" })
vim.api.nvim_set_hl(0, "@section.latex", { link = "keyword" })
vim.api.nvim_set_hl(0, "@label_name.latex", { link = "@string.special.url" })
vim.api.nvim_set_hl(0, "@ref.latex", { link = "@string.special.url" })
vim.api.nvim_set_hl(0, "@citekeys.latex", { link = "@string.special.url" })
vim.api.nvim_set_hl(0, "@keylabel.latex", { link = "@type" })
vim.api.nvim_set_hl(0, "@todo_text.latex", { link = "@comment.todo" })

vim.api.nvim_set_hl(0, "@author_cmd.latex", { link = "@function.builtin" })
vim.api.nvim_set_hl(0, "@title_cmd.latex", { link = "@function.builtin" })
vim.api.nvim_set_hl(0, "@date_cmd.latex", { link = "@function.builtin" })
vim.api.nvim_set_hl(0, "@math_text.latex", { link = "@variable" })
vim.api.nvim_set_hl(0, "@vec.latex", { bold = true })
