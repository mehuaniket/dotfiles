
#!/bin/bash
set -euo pipefail

log() { printf "[setup] %s\n" "$*"; }
warn() { printf "[setup][warn] %s\n" "$*"; }
err() { printf "[setup][error] %s\n" "$*" 1>&2; }

# Function to install a brew package if not already installed
install_brew_package() {
  local formula="$1"
  if ! brew list --formula "$formula" >/dev/null 2>&1; then
    log "Installing formula: $formula"
    brew install "$formula"
  else
    log "$formula is already installed."
  fi
}

install_brew_cask() {
  local cask_name="$1"
  if ! brew list --cask "$cask_name" >/dev/null 2>&1; then
    log "Installing cask: $cask_name"
    brew install --cask "$cask_name"
  else
    log "$cask_name cask is already installed."
  fi
}

# Parse command-line arguments
brew_install=false
install_ghostty=false
stow_targets=("zsh" "tmux" "fzf" "nvim")

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --brew) brew_install=true; shift ;;
    --ghostty) install_ghostty=true; shift ;;
    --all) brew_install=true; install_ghostty=true; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
done

# Install Homebrew packages if --brew true is passed
if [ "$brew_install" = true ]; then
  log "Installing brew packages..."

  # Install Homebrew if not already installed
  if ! command -v brew &>/dev/null; then
    log "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to zshrc if it's not already there
    if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zshrc" 2>/dev/null; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    fi
    eval "$($(command -v brew) shellenv)"
  else
    log "Homebrew is already installed."
    eval "$($(command -v brew) shellenv)"
  fi

  # Use Brewfile for reproducible installs
  if [ -f "$HOME/.dotfiles/homebrew/Brewfile" ]; then
    log "Running brew bundle..."
    brew bundle --file="$HOME/.dotfiles/homebrew/Brewfile" || warn "brew bundle encountered issues"
  else
    warn "Brewfile not found; falling back to ad-hoc installs"
  fi

  # Install necessary brew packages
  install_brew_package node
  install_brew_package fzf
  install_brew_package fd
  install_brew_package ripgrep
  install_brew_package kubectl
  install_brew_package terraform
  install_brew_package jq
  install_brew_package tmux
  install_brew_package gh
  install_brew_package go
  install_brew_package neovim
  install_brew_package fontconfig

  # Install Nerd Font using alternative method
  if ! fc-list | grep -qi "Hack Nerd Font"; then
    log "Installing Hack Nerd Font..."
    install_brew_cask font-hack-nerd-font
  else
    log "Hack Nerd Font is already installed."
  fi

  install_brew_package stow
else
  warn "--brew flag not passed. Skipping Homebrew package installations."
fi

# # Install dotfiles using stow with --delete option
if [ ! -d "$HOME/.dotfiles" ]; then
  log "Cloning dotfiles..."
  git clone --recurse-submodules https://github.com/mehuaniket/dotfiles "$HOME/.dotfiles"
fi

cd ~/.dotfiles

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed."
fi

# Switch default shell to zsh if needed
if [ "$SHELL" != "$(command -v zsh)" ]; then
  log "Setting default shell to zsh..."
  chsh -s "$(command -v zsh)" || warn "chsh failed; you may need to run it manually."
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  log "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  log "zsh-autosuggestions already present."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  log "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  log "zsh-syntax-highlighting already present."
fi

ZSH_THEME_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ ! -d "$ZSH_THEME_DIR" ]; then
  log "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_THEME_DIR"
else
  log "Powerlevel10k already present."
fi

if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  log "Installing tmux plugin manager (tpm)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
else
  log "Tmux Plugin Manager (TPM) already present."
fi

cd ~/.dotfiles

# Function to setup Ghostty
setup_ghostty() {
  log "Setting up Ghostty terminal..."
  
  # Ensure Ghostty is installed
  if [ "$brew_install" = true ]; then
    log "Installing Ghostty..."
    install_brew_cask ghostty
  elif ! command -v ghostty >/dev/null 2>&1 && [ ! -d "/Applications/Ghostty.app" ]; then
    warn "Ghostty not found. Install with: brew install --cask ghostty"
  fi
  
  # Stow Ghostty configuration
  if command -v stow >/dev/null 2>&1; then
    log "Stowing Ghostty config..."
    [ -d "ghostty" ] && stow ghostty || warn "ghostty directory not found"
    
    log "✓ Ghostty setup complete!"
    log "  Launch with: open -a Ghostty"
  else
    warn "stow not installed; cannot link configs"
    return 1
  fi
}

if command -v stow >/dev/null 2>&1; then
  log "Stowing dotfiles..."
  for target in "${stow_targets[@]}"; do
    if [ -d "$target" ]; then
      stow "$target" || warn "stow failed for $target"
    fi
  done
  
  # Setup Ghostty if requested
  if [ "$install_ghostty" = true ]; then
    setup_ghostty
  fi
else
  warn "stow is not installed; skip stowing. Re-run with --brew to install dependencies."
fi

if [ -f "$HOME/.zshrc" ]; then
  log "Sourcing ~/.zshrc"
  # shellcheck disable=SC1090
  source "$HOME/.zshrc"
else
  warn "~/.zshrc does not exist."
fi

if command -v tmux >/dev/null 2>&1; then
  tmux source "$HOME/.config/tmux/tmux.conf" || true
  "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || true
fi

log "============================================"
log "Setup complete! Please restart your terminal."
log ""
if [ "$install_ghostty" = true ]; then
  log "Ghostty installed with Powerlevel10k prompt."
  log "  • Launch: open -a Ghostty"
  log "  • Config: ~/.config/ghostty/config"
  log "  • Prompt: Powerlevel10k (~/.p10k.zsh)"
  log ""
fi
log "Available configs: zsh, tmux, fzf, nvim, ghostty"
log "Install specific configs: cd ~/.dotfiles && stow <name>"
log "============================================"
