# Zsh & Terminal Cheatsheet

A quick reference for the tools and shortcuts in this dotfiles setup.

---

## Zsh Basics

| Shortcut | What it does |
|---|---|
| `Tab` | Autocomplete commands, paths, arguments |
| `Ctrl+R` | Search command history (powered by fzf) |
| `Ctrl+A` | Move cursor to beginning of line |
| `Ctrl+E` | Move cursor to end of line |
| `Ctrl+W` | Delete word before cursor |
| `Ctrl+U` | Delete entire line before cursor |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+L` | Clear screen |
| `!!` | Repeat last command |
| `!$` | Last argument of previous command |
| `Alt+.` | Insert last argument of previous command (cycle through history) |

## Zsh Autosuggestions

As you type, you'll see a grey suggestion based on your history.

| Shortcut | What it does |
|---|---|
| `→` (Right arrow) | Accept the full suggestion |
| `Ctrl+E` | Accept the full suggestion |
| `Alt+→` | Accept the next word of the suggestion |

## Directory Navigation

The `z` plugin learns the directories you visit most.

```bash
z dotfiles      # jump to ~/.dotfiles (or whichever path matches)
z nvim          # jump to a frequently visited dir matching "nvim"
z doc           # jump to the best match for "doc"
```

No need to type full paths. The more you use `cd`, the smarter `z` gets.

Other useful shortcuts:

```bash
..              # go up one directory (oh-my-zsh alias for cd ..)
...             # go up two directories
....            # go up three directories
-               # go back to the previous directory (cd -)
```

## fzf (Fuzzy Finder)

fzf is integrated into your shell for fast searching.

| Shortcut | What it does |
|---|---|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find a file and insert its path |
| `Alt+C` | Fuzzy find a directory and cd into it |
| `**<Tab>` | Trigger fzf completion on any command |

### fzf completion examples

```bash
vim **<Tab>          # fuzzy find a file to open
cd **<Tab>           # fuzzy find a directory to enter
kill **<Tab>         # fuzzy find a process to kill
ssh **<Tab>          # fuzzy find a host from ~/.ssh/config
export **<Tab>       # fuzzy find an environment variable
```

## Custom Aliases

Defined in `.zshrc`:

| Alias | Command |
|---|---|
| `vim` | Opens nvim |
| `vf` | Opens nvim with fzf file picker + bat preview |
| `ls` | `eza --icons` (colored file list with icons) |
| `ll` | `eza -la --icons --git` (detailed list with git status) |
| `lt` | `eza -la --icons --git --tree --level=2` (tree view) |
| `brewup` | `brew update && brew upgrade && brew cleanup` |
| `ta` | Attach to tmux session or create one |
| `ta <name>` | Attach to named session or create it |
| `php@8.4` | Run PHP 8.4 |
| `composer@8.4` | Run Composer with PHP 8.4 |

## Git Plugin Aliases (oh-my-zsh)

The `git` plugin gives you hundreds of aliases. The most useful ones:

| Alias | Command |
|---|---|
| `gst` | `git status` |
| `ga` | `git add` |
| `gaa` | `git add --all` |
| `gc` | `git commit` |
| `gcmsg "msg"` | `git commit -m "msg"` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gb` | `git branch` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `glog` | Pretty git log with graph |
| `gsta` | `git stash` |
| `gstp` | `git stash pop` |

Run `alias | grep git` to see all of them.

## bat (Better cat)

Use `bat` instead of `cat` to view files with syntax highlighting.

```bash
bat file.py              # view with syntax highlighting + line numbers
bat -l json data.txt     # force a specific language
bat --diff file.py       # show git changes inline
bat -A file.txt          # show invisible characters (tabs, spaces, newlines)
```

## tmux

### Session management

```bash
ta                  # attach to last session or create one
ta work             # attach to "work" session or create it
tmux ls             # list all sessions
```

### Inside tmux (prefix is Ctrl+A)

| Shortcut | What it does |
|---|---|
| `C-a \|` | Split pane horizontally |
| `C-a -` | Split pane vertically |
| `C-a h/j/k/l` | Navigate between panes |
| `C-a C-h/j/k/l` | Resize panes |
| `C-a c` | Create new window |
| `C-a n` | Next window |
| `C-a p` | Previous window |
| `C-a 1-9` | Switch to window by number |
| `C-a d` | Detach from session |
| `C-a ,` | Rename current window |
| `C-a $` | Rename current session |
| `C-a q` | Show pane numbers |
| `C-a r` | Reload tmux config |
| `C-a [` | Enter copy mode (vi keys, `v` to select, `y` to copy) |
| `C-a x` | Kill current pane |

### tmux-resurrect

| Shortcut | What it does |
|---|---|
| `C-a Ctrl+s` | Save session layout |
| `C-a Ctrl+r` | Restore session layout |

Sessions are also auto-saved every 15 minutes by tmux-continuum.

## direnv (Auto-load Environment per Project)

Create a `.envrc` file in any project directory to auto-load env vars when you `cd` into it:

```bash
cd ~/projects/my-app
echo 'export DATABASE_URL="postgres://localhost/mydb"' > .envrc
direnv allow    # approve the .envrc (required once per change)
```

Now every time you enter that directory, `DATABASE_URL` is set. Leave the directory and it's unset.

Common `.envrc` patterns:

```bash
# Load a .env file
dotenv

# Activate a Python venv
layout python3

# Add a local bin to PATH
PATH_add bin

# Set project-specific vars
export API_KEY="dev-key-123"
```

## tldr (Simplified Man Pages)

```bash
tldr tar         # show common tar examples
tldr git stash   # show common git stash examples
tldr ffmpeg      # no more googling ffmpeg flags
```

## lazydocker

```bash
lazydocker       # TUI for managing Docker containers, images, volumes, logs
```

Same idea as `lazygit` but for Docker. Navigate with `h/j/k/l`, view logs, restart containers, all from the terminal.

## Productivity Tips

1. **Don't type full paths.** Use `z` to jump, `Ctrl+T` to find files, `Alt+C` to find directories.
2. **Don't retype commands.** Use `Ctrl+R` to search history, or just start typing and accept the autosuggestion with `→`.
3. **Use `vf` instead of `vim`.** It opens a fuzzy file picker with preview so you don't need to remember exact file paths.
4. **Use `**<Tab>` everywhere.** It works with almost any command.
5. **Use tmux sessions per project.** `ta project-name` keeps each project's terminal layout separate and persistent across reboots.
