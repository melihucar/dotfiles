return {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    {
        "echasnovski/mini.move",
        event = "VeryLazy",
        opts = {},
    },
}
