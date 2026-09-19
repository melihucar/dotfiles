local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user", { clear = true })

au("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- reopen files at last cursor position
au("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines and vim.bo[ev.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 2-space indent for web stack
au("FileType", {
  group = group,
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc",
              "css", "scss", "html", "yaml", "lua", "markdown", "sh", "zsh" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- reload files changed outside nvim (git checkout, formatters, AI agents)
au({ "FocusGained", "BufEnter", "TermClose" }, { group = group, command = "checktime" })

-- equalize splits when the terminal/tmux pane is resized
au("VimResized", { group = group, command = "tabdo wincmd =" })
