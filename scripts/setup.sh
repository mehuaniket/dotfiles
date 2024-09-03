#!/bin/bash

# Function to install a brew package if not already installed
install_brew_package() {
  if ! brew list "$1" >/dev/null 2>&1; then
    echo "Installing $1..."
    brew install "$1"
  else
    echo "$1 is already installed."
  fi
}

# # Install dotfiles using stow with --delete option
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Cloning dotfiles..."
  git clone --recurse-submodules https://github.com/mehuaniket/dotfiles ~/.dotfiles
fi

cd ~/.dotfiles

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to zshrc if it's not already there
  if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' ~/.zshrc; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  fi
  source ~/.zshrc
else
  echo "Homebrew is already installed."
fi

# Install iTerm2
install_brew_package iterm2
install_brew_package node

# Install fzf and fd
install_brew_package fzf
install_brew_package fd

# Install kubectl and terraform
install_brew_package kubectl
install_brew_package terraform
install_brew_package jq


# Check if Oh My Zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Switch to Zsh immediately after installation
  exec zsh
else
  echo "Oh My Zsh is already installed at $HOME/.oh-my-zsh. Skipping installation."
fi

# Switch to Zsh if not already using it
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Switching to Zsh..."
  chsh -s "$(which zsh)"
  exec zsh  # Switch to Zsh immediately
fi

# Clone Zsh plugins after removing existing directories
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Remove and re-clone zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Removing existing zsh-autosuggestions..."
  rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
echo "Cloning zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Remove and re-clone zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Removing existing zsh-syntax-highlighting..."
  rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
echo "Cloning zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Remove and re-clone Powerlevel10k theme
ZSH_THEME_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ -d "$ZSH_THEME_DIR" ]; then
  echo "Removing existing Powerlevel10k theme..."
  rm -rf "$ZSH_THEME_DIR"
fi
echo "Installing Powerlevel10k..."

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k


# Install tmux
install_brew_package tmux

# Setup tmux plugin manager and configuration if not already setup
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Setting up tmux..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "Tmux Plugin Manager (TPM) is already set up."
fi

# Install GitHub CLI
install_brew_package gh

# Install Rust if not already installed
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "Rust is already installed."
fi

# Install Go
install_brew_package go

# Install Neovim
install_brew_package neovim

# Check for fc-list command (usually part of the fontconfig package)
if ! command -v fc-list &>/dev/null; then
  echo "Installing fontconfig..."
  brew install fontconfig
fi

# Install Nerd Font using alternative method as cask-fonts is deprecated
if ! fc-list | grep -qi "Hack Nerd Font"; then
  echo "Downloading and installing Hack Nerd Font..."
  brew install --cask font-hack-nerd-font
else
  echo "Hack Nerd Font is already installed."
fi

# touch ~/.tmux.conf
install_brew_package stow

cd ~/.dotfiles

echo "Stowing dotfiles with deletion of existing conflicts..."
stow nvim

rm ~/.zshrc || true
rm ~/.p10k.zsh || true

stow zsh

stow tmux

stow fzf

# Source Zsh configuration to apply changes
if [ -f ~/.zshrc ]; then
  source ~/.zshrc
else
  echo "Error: ~/.zshrc does not exist."
  exit 1
fi

tmux source ~/.tmux.conf
tmux run '~/.tmux/plugins/tpm/scripts/install_plugins.sh'


echo "Setup complete! Please restart your terminal."

