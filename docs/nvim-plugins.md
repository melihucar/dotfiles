# Neovim Plugin Reference

Leader key: `,`

## Navigation

### Telescope (`nvim-telescope/telescope.nvim`)

| Key | Description |
|-----|-------------|
| `,ff` | Find files |
| `,fg` | Live grep |
| `,fb` | Find buffers |
| `,fr` | Recent files |
| `,fh` | Help tags |
| `,fk` | Keymaps |
| `,fw` | Grep word under cursor |
| `,fd` | Diagnostics |
| `,fl` | LSP document symbols |
| `,f.` | Resume last search |
| `,/` | Fuzzy search in current buffer |
| `,ss` | Grep in open files |
| `,sn` | Search Neovim config files |

### Neo-tree (`nvim-neo-tree/neo-tree.nvim`)

| Key | Description |
|-----|-------------|
| `\` | Toggle Neo-tree file explorer |

### Flash (`folke/flash.nvim`)

| Key | Description |
|-----|-------------|
| `s` | Jump to any location (flash labels) |
| `S` | Treesitter-based selection |

### Oil (`stevearc/oil.nvim`)

| Key | Description |
|-----|-------------|
| `-` | Open parent directory as buffer |

Edit filenames to rename, delete lines to delete files, `:w` to apply changes.

## Code Intelligence

### LSP (`neovim/nvim-lspconfig`)

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `,D` | Type definition |
| `,ds` | Document symbols |
| `,ws` | Workspace symbols |
| `,rn` | Rename symbol |
| `,ca` | Code action |
| `,th` | Toggle inlay hints |

### nvim-cmp (`hrsh7th/nvim-cmp`)

| Key | Description |
|-----|-------------|
| `<C-n>` | Next completion item |
| `<C-p>` | Previous completion item |
| `<C-y>` | Accept completion |
| `<C-Space>` | Trigger completion |
| `<C-b>` / `<C-f>` | Scroll docs back/forward |
| `<C-l>` / `<C-h>` | Jump forward/back in snippet |

Sources: LSP, LuaSnip, path, buffer, lazydev (Lua files).

### Treesitter (`nvim-treesitter/nvim-treesitter`)

Automatic syntax highlighting, indentation, and text objects.

### Copilot (`github/copilot.vim`)

Inline AI suggestions. Accept with `<Tab>`.

### LuaSnip (`L3MON4D3/LuaSnip`)

Snippet engine. Snippets provided by `friendly-snippets`. Navigate with `<C-l>` / `<C-h>`.

## Editing

### mini.surround (`echasnovski/mini.surround`)

| Key | Description |
|-----|-------------|
| `sa{motion}{char}` | Add surrounding (e.g. `saiw"` wraps word in quotes) |
| `sd{char}` | Delete surrounding (e.g. `sd"` removes quotes) |
| `sr{old}{new}` | Replace surrounding (e.g. `sr"'` changes `"` to `'`) |

### mini.move (`echasnovski/mini.move`)

Move lines/selections with `Alt+h/j/k/l`.

### ts-comments (`folke/ts-comments.nvim`)

Treesitter-aware commenting via `gc{motion}` / `gcc`.

### Autopairs (`windwp/nvim-autopairs`)

Auto-close brackets, quotes, etc. on insert.

## Diagnostics & Search

### Trouble (`folke/trouble.nvim`)

| Key | Description |
|-----|-------------|
| `,xx` | Toggle diagnostics list |
| `,xq` | Toggle quickfix list |

### todo-comments (`folke/todo-comments.nvim`)

Highlights `TODO`, `FIXME`, `HACK`, `NOTE`, `WARN` in comments.

| Key | Description |
|-----|-------------|
| `,ft` | Search TODOs via Telescope |

## Git

### LazyGit (`kdheepak/lazygit.nvim`)

| Key | Description |
|-----|-------------|
| `,lg` | Open LazyGit |

### Gitsigns (`lewis6991/gitsigns.nvim`)

Inline git change indicators in the sign column.

### Diffview (`sindrets/diffview.nvim`)

| Key | Description |
|-----|-------------|
| `,gd` | Open side-by-side diff view |
| `,gD` | Close diff view |

## Debugging

### DAP (`mfussenegger/nvim-dap`)

| Key | Description |
|-----|-------------|
| `<F5>` | Start/Continue |
| `<C-F5>` | Stop |
| `,ds` | Stop |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<F9>` | Toggle breakpoint |
| `,b` | Toggle breakpoint |
| `,B` | Set conditional breakpoint |
| `<F7>` | Toggle DAP UI |

Adapters: Python (debugpy), C/C++ (codelldb), PHP (Xdebug).

## Testing

### Neotest (`nvim-neotest/neotest`)

| Key | Description |
|-----|-------------|
| `,tn` | Run nearest test |
| `,tf` | Run current file |
| `,ts` | Toggle test summary |
| `,to` | Open test output |

Adapters: Python (pytest), Go.

## Formatting

### none-ls (`nvimtools/none-ls.nvim`)

Auto-format on save via LSP. Formatters: black + isort (Python), clang-format (C/C++), goimports + gofumpt (Go), prettier (JS/TS/JSON/YAML/HTML/CSS/Markdown/PHP).

## Terminal

### Toggleterm (`akinsho/toggleterm.nvim`)

| Key | Description |
|-----|-------------|
| `<C-\>` | Toggle floating terminal |

## Sessions

### Persistence (`folke/persistence.nvim`)

| Key | Description |
|-----|-------------|
| `,qs` | Save session |
| `,qr` | Restore session (current dir) |
| `,ql` | Restore last session |
| `,as` | Toggle autosave |

## Claude Code

### claudecode.nvim (`coder/claudecode.nvim`)

IDE integration for Claude Code CLI. Starts a WebSocket server on launch so `claude --ide` can connect and send inline diffs.

| Key | Description |
|-----|-------------|
| `,aa` | Accept Claude suggestion |
| `,ad` | Reject Claude suggestion |

Usage: Run `claude --ide` in a separate terminal. When Claude proposes file edits, a vertical split diff opens in Neovim.

## UI

### which-key (`folke/which-key.nvim`)

Auto popup showing available keybindings after pressing leader or any prefix key. Triggered by `timeoutlen` (300ms).

### indent-blankline (`lukas-reineke/indent-blankline.nvim`)

Visual indent guides. Automatic, no keybinding.

### Bufferline (`akinsho/bufferline.nvim`)

Tab-style buffer bar at the top. Mode: tabs.

### Lualine (`hoob3rt/lualine.nvim`)

Status line. Theme: rose-pine.

### virt-column (`lukas-reineke/virt-column.nvim`)

Thin virtual column at column 80.

## General Keymaps

| Key | Description |
|-----|-------------|
| `<Esc>` | Clear search highlights |
| `<C-h/j/k/l>` | Navigate between splits |
