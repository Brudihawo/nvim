-- Setting weird filetypes
vim.api.nvim_exec('autocmd BufNewFile,BufRead .xprofile set filetype=xprofile', true)
vim.api.nvim_exec('autocmd BufNewFile,BufRead *.fish set filetype=fish', true)

-- Filetype specific run commands
vim.api.nvim_exec('autocmd FileType python nnoremap <leader>x :!python % <CR>', true)
vim.api.nvim_exec('autocmd FileType sh nnoremap <leader>x :w <CR>:! bash <<< cat %<CR>', true)
vim.api.nvim_exec('autocmd FileType rust nnoremap <leader>x :w <CR>:! cargo run<CR>', true)

-- Filetype Specific Commands
vim.api.nvim_exec('autocmd FileType tex nnoremap <buffer> <leader>B ciW\\textbf{<ESC>pa}<ESC>', true)
-- vim.api.nvim_exec('autocmd FileType tex call vimtex#init()', true)
-- Hold Cursor action
-- vim.api.nvim_exec('autocmd CursorHold * :lua vim.lsp.diagnostic.show_line_diagnostics()', true)

-- Autocomplete
vim.api.nvim_exec('autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc', true)

vim.api.nvim_exec("autocmd FileType * hi trailws guibg='#fb4934'", true)
vim.api.nvim_exec("autocmd FileType * match trailws /\\s\\+$/", true)

