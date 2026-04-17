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
# Install Ghostty terminal
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" -- --ghostty

# Or manually after cloning
cd ~/.dotfiles
stow ghostty      # Ghostty terminal config
stow zsh          # Zsh configuration (includes Powerlevel10k)
stow tmux         # Tmux configuration
stow nvim         # Neovim configuration
stow fzf          # FZF configuration
```

## Available Configurations

| Config | Description | Terminal |
|--------|-------------|----------|
| `zsh` | Shell config with Powerlevel10k | iTerm2, Ghostty |
| `tmux` | Terminal multiplexer | All |
| `nvim` | Neovim IDE setup | All |
| `fzf` | Fuzzy finder | All |
| `ghostty` | Ghostty terminal (Catppuccin Mocha) | Ghostty |
| `git` | Git configuration | All |
| `k9s` | Kubernetes TUI | All |

## Features

- **Dual Terminal Support**: 
  - iTerm2 & Ghostty → Powerlevel10k prompt
  - Consistent theme and experience across terminals
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
- Uses Powerlevel10k prompt (same as iTerm2)

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
└── ghostty/              # → ~/.config/ghostty/

~/.config/                # Symlinked configs (auto-managed)
├── ghostty/config        # Ghostty terminal
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
git pull && stow -R zsh tmux nvim fzf ghostty
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

### Ghostty Prompt Issues
Check if Powerlevel10k is loaded:
```bash
echo $ZSH_THEME
# Should show: powerlevel10k/powerlevel10k
```

### Font Issues
```bash
# Reinstall Nerd Fonts
brew reinstall --cask font-jetbrains-mono-nerd-font
```
