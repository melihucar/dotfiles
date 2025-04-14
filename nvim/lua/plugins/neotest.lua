return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-go",
    },
    keys = {
        { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
        { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run file" },
        { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle summary" },
        { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<cr>", desc = "Open output" },
    },
    config = function()
        require("neotest").setup {
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    runner = "pytest",
                    args = { "--maxfail=1", "--disable-warnings", "-q" },
                }),
                require("neotest-go")({
                    args = { "-v" },
                }),
            },
        }
    end,
}
