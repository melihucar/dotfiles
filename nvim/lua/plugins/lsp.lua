return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            local servers = {
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = 'off',
                                autoImportCompletions = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                },

                gopls = {
                    cmd = { 'gopls', 'serve' },
                    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                    root_dir = require('lspconfig.util').root_pattern('go.work', 'go.mod', '.git'),
                },

                ts_ls = {
                    cmd = { 'typescript-language-server', '--stdio' },
                    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'tsx' },
                    root_dir = require('lspconfig.util').root_pattern('package.json', 'tsconfig.json', '.git'),
                },

                clangd = {
                    cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
                    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
                    root_dir = require('lspconfig.util').root_pattern(
                        'compile_commands.json', 'compile_flags.txt', '.clangd', '.git'
                    ),
                    capabilities = {
                        offsetEncoding = { 'utf-16' },
                    },
                },

                intelephense = {
                    cmd = { 'intelephense', '--stdio' },
                    filetypes = { 'php' },
                    root_dir = require('lspconfig.util').root_pattern('composer.json', '.git'),
                    settings = {
                        intelephense = {
                            stubs = {
                                "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core",
                                "ctype", "curl", "date", "dba", "dom", "enchant", "exif",
                                "FFI", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext",
                                "gmp", "hash", "iconv", "imap", "intl", "json", "ldap",
                                "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc",
                                "openssl", "pcntl", "pcre", "PDO", "pdo_ibm", "pdo_mysql",
                                "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix",
                                "pspell", "readline", "Reflection", "session", "shmop",
                                "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL",
                                "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem",
                                "sysvshm", "tidy", "tokenizer", "xml", "xmlreader",
                                "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib",
                            },
                            completion = {
                                fullyQualifyGlobalConstantsAndFunctions = false,
                                triggerParameterHints = true,
                                insertUseDeclaration = true,
                                maxItems = 100,
                            },
                            environment = {
                                phpVersion = "8.2.0",
                            },
                        },
                    },
                },

                lua_ls = {
                    settings = {
                        Lua = {
                            completion = { callSnippet = 'Replace' },
                        },
                    },
                },
            }

            require('mason').setup()

            local lsp_servers = vim.tbl_keys(servers or {})

            require('mason-tool-installer').setup {
                ensure_installed = {
                    'goimports',
                    'gofumpt',
                    'prettier',
                },
            }

            require('mason-lspconfig').setup {
                ensure_installed = lsp_servers,
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },
}

