return {
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss All Notifications",
            },
        },
        opts = {
            stages = "static",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
        init = function()
            vim.notify = require("notify")
        end,
    },
    {
        'rose-pine/neovim',
        config = function()
            require('rose-pine').setup({
                variant = "main", -- auto, main, moon, or dawn
            })

            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        "lukas-reineke/virt-column.nvim",
        opts = {
            virtcolumn = "80",
            highlight = { "NonText" },
        },
    },
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                mode = "tabs",
            },
        },
    },
    {
        "hoob3rt/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "rose-pine",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename", "location" },
                    lualine_x = { "encoding", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
}
