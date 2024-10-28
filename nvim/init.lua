vim.cmd("language en_US")

-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrwong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set tab and indent settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable syntax highlighting
vim.opt.syntax = 'on'

-- scroll offset
--  See `:help 'scrolloff'`
vim.opt.scrolloff = 8

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

require 'keymaps'
require 'plugins'
