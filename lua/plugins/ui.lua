-- Snacks
vim.pack.add { "https://github.com/folke/snacks.nvim" }

local snacks = require "snacks"
snacks.setup {
    bufdelete = {},
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
                { icon = " ", key = "c", desc = "Config", action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})' },
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
    explorer = {},
    image = {},
    indent = {
        animate = {
            enabled = false,
        },
    },
    notifier = {},
    picker = {
        toggles = {
            hidden = false,
        },
        sources = {
            explorer = {
                hidden = true,
            },
        },
    },
    terminal = {},
}

vim.keymap.set("n", "<leader>e", function() snacks.explorer.open() end)
vim.keymap.set("n", "<leader>t", function() snacks.terminal.toggle() end)
vim.keymap.set("n", "<leader>bd", function() snacks.bufdelete() end)
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

vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
        local snacks_windows = {}
        local floating_windows = {}
        local windows = vim.api.nvim_list_wins()
        for _, w in ipairs(windows) do
            local filetype = vim.api.nvim_get_option_value('filetype', { buf = vim.api.nvim_win_get_buf(w) })
            if filetype:match('snacks_') ~= nil then
                table.insert(snacks_windows, w)
            elseif vim.api.nvim_win_get_config(w).relative ~= '' then
                table.insert(floating_windows, w)
            end
        end
        if 1 == #windows - #floating_windows - #snacks_windows then
            for _, w in ipairs(snacks_windows) do
                vim.api.nvim_win_close(w, true)
            end
        end
    end,
})

-- Catppuccin
vim.pack.add { "https://github.com/catppuccin/nvim" }

require("catppuccin").setup {
    transparent_background = true,
    float = { transparent = true },
    color_overrides = {
        mocha = {
            -- swap blue and mauve
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
            Pmenu = { bg = colors.surface0 },
            PmenuSel = { bg = colors.surface1 },
            DropBarMenuNormalFloat = { bg = colors.surface0 },
            DropBarMenuCurrentContext = { bg = colors.surface1 },
        }
    end,
    integrations = {
        dropbar = { enabled = true },
        noice = true,
        blink_cmp = { style = "bordered" },
        gitsigns = true,
    },
}

vim.cmd.colorscheme "catppuccin-mocha"

-- Lualine
vim.pack.add {
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
}

require("lualine").setup {
    options = {
        theme = "catppuccin-nvim",
        component_separators = "│",
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            {
                "mode",
                separator = { left = "", right = "" },
            },
        },
        lualine_c = {
            "filename",
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

vim.api.nvim_create_autocmd("RecordingEnter", { callback = function() require("lualine").refresh() end })
vim.api.nvim_create_autocmd("RecordingLeave", { callback = function() require("lualine").refresh() end })

-- Dropbar
vim.pack.add {
    "https://github.com/Bekaboo/dropbar.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
}

require("dropbar").setup()

-- Noice
vim.pack.add {
    "https://github.com/folke/noice.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
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

-- Gitsigns
vim.pack.add { "https://github.com/lewis6991/gitsigns.nvim" }

require("gitsigns").setup()
