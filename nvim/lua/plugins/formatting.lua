return {
    {
        "nvimtools/none-ls.nvim",
        event = "BufReadPre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Python
                    null_ls.builtins.formatting.black.with({ extra_args = { "--line-length", "88" } }),
                    null_ls.builtins.formatting.isort,
                    -- C/C++/Objective-C
                    null_ls.builtins.formatting.clang_format,
                    -- Go
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.gofumpt,
                    -- JS/TS
                    null_ls.builtins.formatting.prettier.with({
                        filetypes = {
                            "javascript", "typescript", "javascriptreact", "typescriptreact",
                            "json", "yaml", "html", "css", "markdown", "php",
                        },
                    }),
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        local group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
                        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = group,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    async = false,
                                    filter = function(client)
                                        return client.name == "null-ls"
                                    end,
                                })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}

