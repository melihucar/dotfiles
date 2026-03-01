return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {},
    },

    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
        },
        opts = {
            view_options = {
                show_hidden = true,
            },
        },
    },
}
