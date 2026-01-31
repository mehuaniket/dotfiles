# dotfiles

Opinionated macOS setup using Homebrew Bundle, GNU stow, and Oh My Zsh.

## Quick Start

### Full Installation

Install everything (brew + all dotfiles) in one go:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" -- --all
```

### Core Installation (without optional tools)

Install core dotfiles only (zsh, tmux, fzf, nvim):

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" -- --brew
```

If Homebrew packages are already installed:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)"
```

### Modular Installation

Install specific configurations:

```bash
# Install Ghostty terminal with oh-my-posh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" -- --ghostty

# Or manually after cloning
cd ~/.dotfiles
stow ghostty      # Ghostty terminal config
stow oh-my-posh   # oh-my-posh prompt theme
stow zsh          # Zsh configuration
stow tmux         # Tmux configuration
stow nvim         # Neovim configuration
stow fzf          # FZF configuration
```

## Available Configurations

| Config | Description | Terminal |
|--------|-------------|----------|
| `zsh` | Shell config with P10k/oh-my-posh | iTerm2, Ghostty |
| `tmux` | Terminal multiplexer | All |
| `nvim` | Neovim IDE setup | All |
| `fzf` | Fuzzy finder | All |
| `ghostty` | Ghostty terminal (Catppuccin Mocha) | Ghostty |
| `oh-my-posh` | Prompt theme (P10k lean style) | Ghostty |
| `git` | Git configuration | All |
| `k9s` | Kubernetes TUI | All |

## Features

- **Dual Terminal Support**: 
  - iTerm2 → Powerlevel10k prompt
  - Ghostty → oh-my-posh prompt (auto-detects)
- **Theme**: Catppuccin Mocha everywhere
- **Font**: JetBrains Mono Nerd Font
- **Shell**: zsh with Oh My Zsh
- **Multiplexer**: tmux with TPM

## Homebrew bundle

Leaving a machine (export current state):

```bash
brew bundle dump --file=homebrew/Brewfile --force
```

Fresh installation on a new machine:

```bash
brew bundle --file=homebrew/Brewfile && brew cleanup
```

## Manual Steps

### iTerm2 Setup (Optional)
- Import `misc/iterm_default_profile.json` (iTerm2 → Profiles → Other Actions → Import JSON Profiles)
- Optionally import `misc/catppuccin_mocha.itermcolors`

### Ghostty Setup (Optional)
- Launch Ghostty: `open -a Ghostty`
- Config auto-linked via stow to `~/.config/ghostty/config`
- Prompt switches automatically to oh-my-posh

### Post-Install
- Restart Terminal/Ghostty
- Open Neovim once to let plugins sync: `nvim`
- Press `Ctrl+Space` then `I` in tmux to install plugins

## Configuration Locations

```
~/.dotfiles/              # Source files (edit here)
├── zsh/                  # → ~/.zshrc, ~/.p10k.zsh
├── tmux/                 # → ~/.config/tmux/
├── nvim/                 # → ~/.config/nvim/
├── ghostty/              # → ~/.config/ghostty/
└── oh-my-posh/           # → ~/.config/oh-my-posh/

~/.config/                # Symlinked configs (auto-managed)
├── ghostty/config        # Ghostty terminal
├── oh-my-posh/*.json     # Prompt themes
├── tmux/tmux.conf        # Tmux config
└── nvim/                 # Neovim config
```

## Updating Configurations

```bash
cd ~/.dotfiles

# Update specific config
cd zsh && git pull && cd .. && stow -R zsh

# Update Brewfile (export current state)
brew bundle dump --file=homebrew/Brewfile --force

# Update all configs
git pull && stow -R zsh tmux nvim fzf ghostty oh-my-posh
```

## Tips

- **Tmux**: Press `Ctrl+Space` then `r` to reload config
- **Neovim**: Run `:Lazy update` to update plugins
- **Ghostty vs iTerm2**: Prompt auto-switches based on terminal
- Blog: [How I set up my Mac](https://mehuaniket.com/blog/how-do-i-setup-my-mac/)

## Troubleshooting

### Stow Conflicts
```bash
# Remove old symlinks
stow -D <package>

# Re-link
stow <package>
```

### Ghostty Not Detecting
Check if oh-my-posh is in PATH:
```bash
which oh-my-posh
# Should show: /opt/homebrew/bin/oh-my-posh
```

### Font Issues
```bash
# Reinstall Nerd Fonts
brew reinstall --cask font-jetbrains-mono-nerd-font
```
