-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymap
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<leader>sn", "<cmd>set relativenumber!<cr>")
vim.keymap.set("n", "<leader>sw", "<cmd>set list!<cr>")
vim.keymap.set("n", "gca", vim.lsp.buf.code_action)
