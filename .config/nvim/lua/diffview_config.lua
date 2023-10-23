local map = vim.api.nvim_set_keymap

-- DiffView keybindings
map('n', '<leader>gd', ":DiffviewOpen<CR>", { noremap = true, silent = true})

