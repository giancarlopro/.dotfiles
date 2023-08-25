local map = vim.api.nvim_set_keymap

-- Delete word behind cursor
map('i', '<C-BS>', '<C-w>', { noremap = true, silent = true })

-- Save the file with Ctrl + S in insert mode
-- First, ensure Ctrl + S doesn't freeze the terminal
vim.cmd([[
  if !has('gui_running')
    let &t_ti .= "\<Esc>[?1049h"
    let &t_te .= "\<Esc>[?1049l"
    silent !echo -ne "\033[?1049h"
  endif
]])

-- Map Ctrl + S to save in various modes
map('n', '<C-S>', ':w<CR>', { noremap = true, silent = true })
map('v', '<C-S>', '<C-C>:w<CR>', { noremap = true, silent = true })
map('i', '<C-S>', '<C-O>:w<CR>', { noremap = true, silent = true })

-- Run config for python files
vim.cmd [[
  autocmd FileType python nnoremap <buffer> <F5> :!python %<CR>
]]
