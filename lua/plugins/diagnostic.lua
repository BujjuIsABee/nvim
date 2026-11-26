-- Trouble
vim.pack.add { "https://github.com/folke/trouble.nvim" }

require("trouble").setup()

vim.keymap.set("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>")

-- Tiny Inline Diagnostic
vim.pack.add { "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }

require("tiny-inline-diagnostic").setup {
    preset = "powerline",
}

-- Symbols
vim.diagnostic.config {
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "●",
        },
    },
}
