# ----------------------------------------
# Homebrew (must be before Oh My Zsh for plugins that need brew binaries)
# ----------------------------------------
export PATH="/opt/homebrew/bin:$PATH"

# ----------------------------------------
# Oh My Zsh
# ----------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="lambda"

plugins=(
  git
  poetry
  z
  direnv
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ----------------------------------------
# General
# ----------------------------------------
export LANG=en_US.UTF-8

# Editor
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
  alias vim='nvim'
elif [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
fi

alias vi='vim'
alias python='python3'

# eza (modern ls)
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias lt='eza -la --icons --git --tree --level=2'

# ----------------------------------------
# PATH
# ----------------------------------------
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/.config/phpmon/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/16/bin:$PATH"

if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# ----------------------------------------
# Homebrew
# ----------------------------------------
alias brewup='brew update && brew upgrade && brew cleanup'

# ----------------------------------------
# PHP
# ----------------------------------------
for v in 8.0 8.1 8.3 8.4; do
  alias "php@$v=/opt/homebrew/opt/php@$v/bin/php"
  alias "composer@$v=/opt/homebrew/opt/php@$v/bin/php /opt/homebrew/bin/composer"
done

# ----------------------------------------
# fzf
# ----------------------------------------
source <(fzf --zsh)

# Open files with fzf + bat preview
alias vf='nvim $(fzf -m --preview "bat --color=always --style=header,grid --line-range :500 {}")'

# ----------------------------------------
# tmux
# ----------------------------------------

# Attach to an existing session or create a new one
ta() {
  if [ -z "$1" ]; then
    tmux attach || tmux
  else
    tmux attach -t "$1" || tmux new -s "$1"
  fi
}

_ta_autocomplete() {
  local sessions
  sessions=("${(f)$(tmux list-sessions -F '#S' 2>/dev/null)}")
  _describe 'session' sessions
}
compdef _ta_autocomplete ta

# ----------------------------------------
# NVM (lazy-loaded for faster shell startup)
# ----------------------------------------
export NVM_DIR="$HOME/.nvm"

_lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

nvm() { _lazy_load_nvm && nvm "$@"; }
node() { _lazy_load_nvm && node "$@"; }
npm() { _lazy_load_nvm && npm "$@"; }
npx() { _lazy_load_nvm && npx "$@"; }

# ----------------------------------------
# Other
# ----------------------------------------
export ORACLE_HOME="$HOME/.oracle/"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Docker completions
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

. "$HOME/.local/bin/env"
