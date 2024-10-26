return {
    {
        "smjonas/inc-rename.nvim",
        keys = {{
            "<leader>rr",
            "",
            desc = "+rename",
            mode = {"n", "v"}
        }},
        config = function()
            require("inc_rename").setup({})
        end
    },
}
