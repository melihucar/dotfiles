# navigation / files
alias ..='cd ..'
alias ...='cd ../..'
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --git --group-directories-first --icons=auto'
  alias la='eza -la --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto --git-ignore'
fi
alias y='yazi'

# editor
alias v='nvim'
alias vim='nvim'

# git
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias lg='lazygit'

# python (uv)
alias py='uv run python'
alias uvr='uv run'
alias venv='source .venv/bin/activate'

# node / next
alias p='pnpm'
alias pd='pnpm dev'
alias px='pnpm dlx'

# docker
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# misc
alias dots='cd ~/.dotfiles'
alias reload='exec zsh'
alias ports='ss -tulpn'
