-- ==================================================
-- General Options
-- ==================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Appearance
vim.opt.fillchars = { eob = " " }
vim.opt.laststatus = 3

-- ==================================================
-- Keybinds
-- ==================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>")

-- ==================================================
-- Plugins
-- ==================================================

--- Gets the link to a GitHub repository.
--- @param repo string
--- @return string
local function gh(repo) return "https://github.com/" .. repo end

-- Snacks (lots of stuff)

vim.pack.add { gh "folke/snacks.nvim" }

local snacks = require "snacks"
snacks.setup {
    bufdelete = { enabled = true },
    dashboard = {
        width = 60,
        row = nil,
        col = nil,
        pane_gap = 4,
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        preset = {
            pick = nil,
            keys = {
                { icon = " ", key = "f", desc = "Find File", action = ':lua Snacks.dashboard.pick("files")' },
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = " ", key = "g", desc = "Find Text", action = ':lua Snacks.dashboard.pick("live_grep")' },
                { icon = " ", key = "r", desc = "Recent Files", action = ':lua Snacks.dashboard.pick("oldfiles")' },
                {
                    icon = " ",
                    key = "c",
                    desc = "Config",
                    action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})',
                },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        formats = {
            icon = function(item)
                if item.file and item.icon == "file" or item.icon == "directory" then
                    return snacks.dashboard.icon(item.file, item.icon)
                end
                return { item.icon, width = 2, hl = "icon" }
            end,
            footer = { "%s", align = "center" },
            header = { "%s", align = "center" },
            file = function(item, ctx)
                local fname = vim.fn.fnamemodify(item.file, ":~")
                fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                if #fname > ctx.width then
                    local dir = vim.fn.fnamemodify(fname, ":h")
                    local file = vim.fn.fnamemodify(fname, ":t")
                    if dir and file then
                        file = file:sub(-(ctx.width - #dir - 2))
                        fname = dir .. "/…" .. file
                    end
                end
                local dir, file = fname:match "^(.*)/(.+)$"
                return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
            end,
        },
        sections = {
            { section = "header" },
            { section = "keys",  gap = 1, padding = 1 },
        },
    },
    indent = {
        animate = {
            enabled = false,
        },
    },
    terminal = {},
    notifier = {},
    picker = {},
}

vim.keymap.set("n", "<leader>q", function() snacks.bufdelete() end)
vim.keymap.set("n", "<leader>t", function() snacks.terminal.toggle() end)
vim.keymap.set("n", "<leader>ff", function() snacks.picker.files() end)
vim.keymap.set("n", "<leader>fg", function() snacks.picker.grep() end)
vim.keymap.set("n", "<leader>fb", function() snacks.picker.buffers() end)
vim.keymap.set("n", "<leader>fd", function() snacks.picker.diagnostics() end)
vim.keymap.set("n", "<leader>gs", function() snacks.picker.git_status() end)
vim.keymap.set("n", "<leader>gd", function() snacks.picker.git_diff() end)
vim.keymap.set("n", "<leader>gl", function() snacks.picker.git_log() end)
vim.keymap.set("n", "gd", function() snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gD", function() snacks.picker.lsp_declarations() end)
vim.keymap.set("n", "gr", function() snacks.picker.lsp_references() end)
vim.keymap.set("n", "gi", function() snacks.picker.lsp_implementations() end)
vim.keymap.set("n", "gca", vim.lsp.buf.code_action)

-- Catppuccin (theme)

vim.pack.add { gh "catppuccin/nvim" }

require("catppuccin").setup {
    transparent_background = true,
    float = {
        transparent = true,
    },
    color_overrides = {
        mocha = {
            -- Swap blue and mauve
            blue = "#cba6f7",
            mauve = "#89b4fa",
        },
    },
    custom_highlights = function(colors)
        return {
            -- Line numbers
            LineNr = { fg = colors.blue },
            LineNrAbove = { fg = colors.overlay1 },
            LineNrBelow = { fg = colors.overlay1 },

            -- Indent guides
            SnacksIndent = { fg = colors.overlay0 },
            SnacksIndentScope = { fg = colors.blue },

            -- Context menus
            Pmenu = { bg = colors.mantle },
            PmenuSel = { bg = colors.surface1 },
            DropBarMenuNormalFloat = { bg = colors.mantle },
            DropBarMenuCurrentContext = { bg = colors.surface1 },

            -- File explorer
            NeoTreeTabInactive = { fg = colors.blue },
            NeoTreeTabActive = { fg = colors.blue },
        }
    end,
    integrations = {
        neotree = true,
        dropbar = {
            enabled = true,
        },
        noice = true,
        blink_cmp = {
            style = "bordered",
        },
        telescope = {
            enabled = true,
        },
        gitsigns = true,
    },
}

vim.cmd.colorscheme "catppuccin-mocha"

-- Neo-tree (file explorer)

vim.pack.add {
    gh "nvim-neo-tree/neo-tree.nvim",
    gh "nvim-lua/plenary.nvim",
    gh "MunifTanjim/nui.nvim",
    gh "nvim-tree/nvim-web-devicons",
}

require("neo-tree").setup {
    close_if_last_window = true,
    filesystem = {
        -- Make dotfiles visible by default
        filtered_items = {
            visible = true,
        },
    },
}

vim.opt.autochdir = true

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- Lualine (statusline)

vim.pack.add {
    gh "nvim-lualine/lualine.nvim",
    gh "nvim-tree/nvim-web-devicons",
}

require("lualine").setup {
    options = {
        theme = "catppuccin-nvim",
        component_separators = "│",
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            "neo-tree",
        },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                separator = { left = "", right = "" },
            },
        },
        lualine_x = {
            {
                "macro",
                fmt = function()
                    local reg = vim.fn.reg_recording()
                    if reg ~= "" then
                        return "Recording @" .. reg
                    end
                    return nil
                end,

                draw_empty = false,
            },
        },
        lualine_z = {
            {
                "location",
                separator = { left = "", right = "" },
            },
        },
    },
}

-- Dropbar (breadcrumbs)

vim.pack.add {
    gh "nvim-telescope/telescope-fzf-native.nvim",
    gh "Bekaboo/dropbar.nvim",
}

require("dropbar").setup()

-- Noice (cmdline)

vim.pack.add {
    gh "folke/noice.nvim",
    gh "MunifTanjim/nui.nvim",
}

require("noice").setup {
    lsp = {
        hover = {
            enabled = true,
        },
    },
    views = {
        hover = {
            border = {
                style = "rounded",
            },
            position = {
                row = 0,
            },
        },
    },
}

-- Blink (completion)

vim.pack.add {
    gh "saghen/blink.cmp",
    gh "saghen/blink.lib",
}

local cmp = require "blink.cmp"
cmp.build():pwait()
cmp.setup()

-- Tiny Inline Diagnostic (diagnostic)

vim.pack.add { gh "rachartier/tiny-inline-diagnostic.nvim" }

require("tiny-inline-diagnostic").setup {
    preset = "powerline",
}

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

-- Conform (formatter)

vim.pack.add { gh "stevearc/conform.nvim" }

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

-- Gitsigns (git integration)

vim.pack.add { gh "lewis6991/gitsigns.nvim" }

require("gitsigns").setup()

-- ==================================================
-- Language Servers
-- ==================================================

-- Lua

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

-- Rust

vim.pack.add { gh "mrcjkb/rustaceanvim" }
