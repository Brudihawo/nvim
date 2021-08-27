-- Setting weird filetypes
vim.api.nvim_exec('autocmd BufNewFile,BufRead .xprofile set filetype=xprofile', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.fish set filetype=fish', true)

vim.api.nvim_exec('autocmd BufNewFile,BufRead *.c setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.cpp setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.h setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.hpp setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.csv setlocal filetype=csv', true)

-- Setting comment strings
vim.api.nvim_exec('autocmd FileType python setlocal commentstring=#\\ %s', true)
vim.api.nvim_exec('autocmd FileType c setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd FileType cpp setlocal commentstring=//\\ %s', true)
vim.api.nvim_exec('autocmd FileType vim setlocal commentstring=\"\\ %s', true)
vim.api.nvim_exec('autocmd FileType lua setlocal commentstring=--\\ %s', true)
vim.api.nvim_exec('autocmd FileType xprofile setlocal commentstring=#\\ %s', true)
vim.api.nvim_exec('autocmd FileType fish setlocal commentstring=#\\ %s', true)

-- Filetype specific run commands
vim.api.nvim_exec('autocmd FileType python nnoremap <leader>x :!python % <CR>', true)
vim.api.nvim_exec('autocmd FileType sh nnoremap <leader>x :w <CR>:! bash <<< cat %<CR>', true)
vim.api.nvim_exec('autocmd FileType rust nnoremap <leader>x :w <CR>:! cargo run<CR>', true)

-- Filetype Specific Commands
vim.api.nvim_exec('autocmd FileType tex nnoremap <leader>B ciW\\textbf{<ESC>pa}<ESC>', true)
-- Hold Cursor action
vim.api.nvim_exec('autocmd CursorHold * :Lspsaga show_cursor_diagnostics', true)

-- Autocomplete
vim.api.nvim_exec('autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc', true)

vim.api.nvim_exec("autocmd FileType * hi trailws guibg='#fb4934'", true)
vim.api.nvim_exec("autocmd FileType * match trailws /\\s\\+$/", true)

