return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        },
        opts = {},
    },

    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
        },
        opts = {},
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>qs", function() require("persistence").save() end, desc = "Save Session" },
            { "<leader>qr", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>as", function() require("persistence").toggle() end, desc = "Toggle Autosave" },
        },
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
            { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
        },
        opts = {},
    },
}
