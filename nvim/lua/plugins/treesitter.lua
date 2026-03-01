return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    version = false, -- use latest commit
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
        "p00f/nvim-ts-rainbow",
    },
    config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            modules = {
                highlight = { enable = true },
                indent = { enable = true },
                rainbow = { enable = true, extended_mode = true },
                context_commentstring = { enable = true, enable_autocmd = false },
            },
            ensure_installed = {
                "c", "cpp", "objc",
                "lua", "vim", "vimdoc", "query",
                "python", "ninja", "rst",
                "go", "gomod", "gosum",
                "javascript", "typescript", "tsx",
                "html", "css", "json", "yaml", "markdown", "markdown_inline",
                "php",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
