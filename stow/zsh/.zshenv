# Loaded by every zsh (interactive or not). Keep it tiny.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R --mouse"
export MANPAGER="nvim +Man!"

typeset -U path PATH
path=("$HOME/.local/bin" $path)
