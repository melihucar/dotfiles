-- nvim-treesitter `main` branch (the rewrite): needs nvim 0.12 + tree-sitter CLI (installed by mise).
local parsers = {
  "bash", "css", "diff", "dockerfile", "git_config", "gitcommit", "gitignore",
  "html", "javascript", "json", "lua", "luadoc", "markdown", "markdown_inline",
  "python", "query", "regex", "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()
      vim.g.user_ts_parsers = parsers -- install.sh uses this for a blocking install
      ts.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
        callback = function(ev)
          -- start highlighting when a parser exists for this filetype
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { max_lines = 3 },
  },
  {
    "windwp/nvim-ts-autotag", -- auto close/rename JSX & HTML tags
    event = "InsertEnter",
    opts = {},
  },
}
