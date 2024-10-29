# Dotfiles

This repository contains my dotfiles. Use at your own risk. Comes with no warranty. 

It works on my machine, but I can't guarantee it will work on yours.

## Installation

### Install TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# open tmux and press `C-a + I` to install plugins
```


```bash
git clone git@github.com:melihucar/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

ln -s ~/.dotfiles/nvim ~/.config/nvim
```
