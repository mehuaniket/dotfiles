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

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "eval $(/opt/homebrew/bin/brew shellenv)" >> ~/.zshrc
source ~/.zshrc

# Install iTerm2
install_brew_package iterm2

# Install fzf and fd
install_brew_package fzf
install_brew_package fd

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone Zsh plugins
echo "Cloning Zsh plugins..."
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/zsh-syntax-highlighting"

# Install Powerlevel10k
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

source ~/.zshrc

# Install tmux
install_brew_package tmux

# Setup tmux plugin manager and configuration
echo "Setting up tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install GitHub CLI
install_brew_package gh

# Install Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Go
install_brew_package go

# Install Neovim
install_brew_package neovim

# Install Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Install dotfiles using stow
install_brew_package stow
git clone --recurse-submodules https://github.com/mehuaniket/dotfiles ~/.dotfiles
cd ~/.dotfiles

stow --adopt nvim
stow --adopt zsh
stow --adopt tmux
stow --adopt fzf

source ~/.zshrc

tmux source ~/.tmux.conf
tmux run '~/.tmux/plugins/tpm/scripts/install_plugins.sh'

# install kubectl and terraform 
install_brew_package kubectl
install_brew_package terraform
echo "Setup complete! Please restart your terminal."

