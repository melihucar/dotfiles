-- LSP on Neovim 0.12's native API: vim.lsp.config() + vim.lsp.enable().
-- nvim-lspconfig only supplies the default server configs (lsp/*.lua); mason installs binaries.

-- server name (lspconfig) -> overrides
local servers = {
  -- Python: basedpyright for types, ruff for lint/format/imports
  basedpyright = {
    settings = {
      basedpyright = {
        disableOrganizeImports = true, -- ruff does it
        analysis = {
          typeCheckingMode = "standard",
          autoImportCompletions = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  },
  ruff = {
    on_attach = function(client) client.server_capabilities.hoverProvider = false end,
  },

  -- TypeScript / Next.js
  vtsls = {
    settings = {
      vtsls = { autoUseWorkspaceTsdk = true, experimental = { completion = { enableServerSideFuzzyMatch = true } } },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        inlayHints = {
          parameterNames = { enabled = "literals" },
          variableTypes = { enabled = false },
          functionLikeReturnTypes = { enabled = true },
        },
      },
    },
  },
  eslint = {},
  tailwindcss = {},
  cssls = {},
  html = {},
  jsonls = {},
  yamlls = {},

  -- misc
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = "Replace" }, diagnostics = { globals = { "vim", "Snacks" } } } },
  },
  bashls = {},
  dockerls = {},
  docker_compose_language_service = {},
}

-- mason package names for servers + formatters + debuggers
local tools = {
  "basedpyright", "ruff", "vtsls", "eslint-lsp", "tailwindcss-language-server",
  "css-lsp", "html-lsp", "json-lsp", "yaml-language-server", "lua-language-server",
  "bash-language-server", "dockerfile-language-server", "docker-compose-language-service",
  "prettierd", "stylua", "shfmt", "shellcheck", "debugpy",
}

return {
  { "folke/lazydev.nvim", ft = "lua", opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },

  { "mason-org/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = { ui = { border = "rounded" } } },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    cmd = { "MasonToolsInstall", "MasonToolsInstallSync", "MasonToolsUpdate" },
    opts = { ensure_installed = tools, run_on_start = true },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      -- mason's bin dir must be on PATH before servers start
      require("mason").setup()

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end
      vim.lsp.enable(vim.tbl_keys(servers))

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp", { clear = true }),
        callback = function(ev)
          local map = function(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          -- 0.12 defaults also exist: K hover, grn rename, gra code action, grr refs, gri impl, gO symbols
          map("gd", function() Snacks.picker.lsp_definitions() end, "Definition")
          map("gD", vim.lsp.buf.declaration, "Declaration")
          map("gr", function() Snacks.picker.lsp_references() end, "References")
          map("gI", function() Snacks.picker.lsp_implementations() end, "Implementation")
          map("gy", function() Snacks.picker.lsp_type_definitions() end, "Type definition")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>co", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
          end, "Organize imports")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
            end, "Toggle inlay hints")
          end
        end,
      })
    end,
  },
}
