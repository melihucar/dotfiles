return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- prebuilt fuzzy matcher binary
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- same muscle memory as before: C-n/C-p select, C-y accept, C-space open
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { draw = { treesitter = { "lsp" } } },
      },
      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  -- GitHub Copilot ghost text (<Tab> to accept). Remove this block if you don't use it.
  {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
  },
}
