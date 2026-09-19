vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.have_nerd_font = true

local o = vim.opt
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.colorcolumn = "88"        -- ruff/black line length
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.breakindent = true
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " " }
o.termguicolors = true
o.showmode = false
o.laststatus = 3             -- one global statusline
o.winborder = "rounded"      -- borders for hover/signature/floats (0.11+)
o.pumheight = 12

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

o.splitright = true
o.splitbelow = true
o.mouse = "a"
o.undofile = true
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 300
o.confirm = true
o.virtualedit = "block"
o.completeopt = { "menu", "menuone", "noselect" }

vim.schedule(function() o.clipboard = "unnamedplus" end)

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
  float = { source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})
