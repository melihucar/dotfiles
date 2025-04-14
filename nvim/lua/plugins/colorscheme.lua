return {
    'rose-pine/neovim',
    config = function()
        require('rose-pine').setup({
            variant = "main", -- auto, main, moon, or dawn
        })

        vim.cmd("colorscheme rose-pine")
    end
}
