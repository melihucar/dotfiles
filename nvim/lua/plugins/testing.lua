return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-neotest/neotest-jest",
        "marilari88/neotest-vitest",
        "olimorris/neotest-phpunit",
    },
    config = function()
    local dap = require("dap")
    local neotest = require("neotest")

    neotest.setup({
        adapters = {
            require("neotest-jest"),
            require("neotest-vitest"),
            require("neotest-phpunit")({
                dap = {
                    type = "php",
                    request = "launch",
                    name = "Listen for XDebug",
                    port = 9003,
                    ignore = {"**/vendor/**/*.php"},
                },
            }),
        }
    })
    end,
    keys = {
        { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach to the nearest test" },
        { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Toggle Test Summary" },
        { "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Test Output Panel" },
        { "<leader>tp", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop the nearest test" },
        { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Test Summary" },
        { "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run the nearest test" },
        {
            "<leader>tT",
            "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
            desc = "Run test the current file",
        },
        {
            "<leader>td",
            function()
                require("neotest").run.run({ suite = false, strategy = "dap" })
            end,
            desc = "Debug nearest test",
        },
    },
}
