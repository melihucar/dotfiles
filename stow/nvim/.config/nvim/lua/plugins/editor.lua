return {
  -- one plugin for picker, explorer, lazygit, terminal, notifications, indent guides…
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      words = { enabled = true },
      statuscolumn = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
        sources = { files = { hidden = true }, grep = { hidden = true } },
      },
      explorer = { enabled = true, replace_netrw = true },
      lazygit = { enabled = true },
      terminal = { win = { style = "float" } },
    },
    keys = {
      -- find (kept from the old telescope maps)
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
      { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "TODOs" },
      { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Neovim config" },
      { "<leader>/", function() Snacks.picker.lines() end, desc = "Search buffer" },
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find" },
      -- explorer (same key as old neo-tree)
      { "\\", function() Snacks.explorer() end, desc = "Explorer" },
      -- git
      { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit file log" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "x" } },
      -- terminal (same key as old toggleterm)
      { "<C-\\>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notifications" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>t", group = "test" },
        { "<leader>u", group = "toggle" },
        { "<leader>b", group = "buffer" },
      },
    },
  },

  -- seamless C-hjkl between nvim splits and tmux panes
  {
    "christoomey/vim-tmux-navigator",
    init = function() vim.g.tmux_navigator_no_mappings = 1 end,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- text objects, surround, pairs, move lines
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()   -- sa / sd / sr
      require("mini.pairs").setup()
      require("mini.move").setup()       -- M-hjkl moves lines/selections
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = { signs = false },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>sr", function() require("persistence").load() end, desc = "Restore session" },
    },
  },
}
