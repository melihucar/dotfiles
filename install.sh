#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"

info() { printf "\033[0;34m[info]\033[0m %s\n" "$1"; }
success() { printf "\033[0;32m[ok]\033[0m %s\n" "$1"; }

# ----------------------------------------
# Homebrew
# ----------------------------------------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Homebrew installed"
else
  success "Homebrew already installed"
fi

info "Installing Homebrew packages..."
brew bundle --file="$DOTFILES/brew/.Brewfile"
success "Homebrew packages installed"

# ----------------------------------------
# Symlinks
# ----------------------------------------
info "Creating symlinks..."

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES/bat" "$HOME/.config/bat"
ln -sfn "$DOTFILES/alacritty" "$HOME/.config/alacritty"

success "Symlinks created"

# ----------------------------------------
# Oh My Zsh
# ----------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed"
else
  success "Oh My Zsh already installed"
fi

# ----------------------------------------
# Zsh plugins
# ----------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_zsh_plugin() {
  local name="$1" url="$2"
  if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
    info "Installing zsh plugin: $name..."
    git clone "$url" "$ZSH_CUSTOM/plugins/$name"
    success "$name installed"
  else
    success "$name already installed"
  fi
}

clone_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
clone_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

# ----------------------------------------
# TPM (Tmux Plugin Manager)
# ----------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  success "TPM installed"
else
  success "TPM already installed"
fi

info "Installing tmux plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
success "Tmux plugins installed"

# ----------------------------------------
# Bat theme cache
# ----------------------------------------
if command -v bat &>/dev/null; then
  info "Rebuilding bat theme cache..."
  bat cache --build
  success "Bat theme cache built"
fi

echo ""
success "Done! Restart your terminal or run: source ~/.zshrc"
