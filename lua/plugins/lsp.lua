-- Blink
vim.pack.add {
    "https://github.com/saghen/blink.cmp",
    "https://github.com/saghen/blink.lib",
}

local cmp = require "blink.cmp"
cmp.build():pwait()
cmp.setup()

-- Conform
vim.pack.add { "https://github.com/stevearc/conform.nvim" }

require("conform").setup {
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    formatters = {
        stylua = {
            prepend_args = { "--call-parentheses", "None" },
        },
    },
}

-- Lua language server
vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath "config"
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
            },
        })
    end,

    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        {
            ".luarc.json",
            ".luarc.jsonc",
        },
        {
            ".git",
        },
    },
    settings = {
        Lua = {
            codeLens = {
                enable = true,
            },
            hint = {
                enable = true,
                semicolon = "Disable",
            },
        },
    },
})

vim.lsp.enable "lua_ls"

-- Rust language server
vim.pack.add { "https://github.com/mrcjkb/rustaceanvim" }
