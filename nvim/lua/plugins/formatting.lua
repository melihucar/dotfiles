return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufReadPre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black.with({ extra_args = { "--line-length", "88" } }),
                    null_ls.builtins.formatting.isort,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = group,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}

