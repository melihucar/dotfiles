# Dotfiles

This repository contains my dotfiles. Use at your own risk. Comes with no warranty.

It works on my machine, but I can't guarantee it will work on yours.

## Installation

```bash
git clone git@github.com:melihucar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script handles everything:

- Installs Homebrew and packages from Brewfile
- Symlinks all config files to the right locations
- Installs Oh My Zsh with plugins (zsh-autosuggestions, zsh-syntax-highlighting)
- Installs TPM and tmux plugins
- Builds bat theme cache
