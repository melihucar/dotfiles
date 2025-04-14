return {
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
};
