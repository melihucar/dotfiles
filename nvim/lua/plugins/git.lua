return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    {
        'tpope/vim-fugitive',
    },
    {
        "f-person/git-blame.nvim",
        event = "VeryLazy",
        config = function()
            require("gitblame").setup({
                message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
                date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
                virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
            })

            vim.api.nvim_set_keymap("n", "<leader>gb", ":GitBlameToggle<CR>", { noremap = true, silent = true })
        end,
    }
}
