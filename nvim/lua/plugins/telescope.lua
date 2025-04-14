return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- use latest commit
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
      config = function()
        pcall(require("telescope").load_extension, "fzf")
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      config = function()
        pcall(require("telescope").load_extension, "ui-select")
      end,
    },
    {
      "nvim-tree/nvim-web-devicons",
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ❯ ",
        winblend = 10,
        layout_strategy = "horizontal",
        layout_config = {
          preview_width = 0.6,
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
          "node_modules", ".git/", "dist", "%.lock", "%.jpg", "%.jpeg", "%.png", "%.svg", "%.webp"
        },
        mappings = {
          i = {
            ["<Esc>"] = actions.close,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          only_sort_text = true,
        },
      },
      extensions = {
        ["ui-select"] = require("telescope.themes").get_dropdown(),
      },
    })

    -- Keybindings
    local map = vim.keymap.set
    map("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind [G]rep" })
    map("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    map("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent Files" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    map("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under cursor" })
    map("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
    map("n", "<leader>fl", builtin.lsp_document_symbols, { desc = "[F]ind [L]SP Symbols" })
    map("n", "<leader>f.", builtin.resume, { desc = "[F]ind Resume" })

    -- In-buffer search (dropdown style)
    map("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Search in Current Buffer" })

    -- Grep across open files
    map("n", "<leader>ss", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Grep in Open Files",
      })
    end, { desc = "[S]earch in Open [S]plits/Buffers" })

    -- Search Neovim config
    map("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim Config" })
  end,
}

