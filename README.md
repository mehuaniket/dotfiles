# dotfiles

Opinionated macOS setup using Homebrew Bundle, GNU stow, and Oh My Zsh.

## Quick start

Install everything (brew + dotfiles) in one go:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" -- --brew
```

If Homebrew packages are already installed, you can omit `--brew`:

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)"
```

## Homebrew bundle

Leaving a machine (export current state):

```bash
brew bundle dump --file=homebrew/Brewfile --force
```

Fresh installation on a new machine:

```bash
brew bundle --file=homebrew/Brewfile && brew cleanup
```

## Manual steps

- Import `misc/iterm_default_profile.json` (iTerm2 → Profiles → Other Actions → Import JSON Profiles)
- Optionally import `misc/catppuccin_mocha.itermcolors`
- Restart Terminal
- Open Neovim once to let plugins sync

## Tips

- Press Ctrl + Space, then `f` to reload tmux config
- Refer to the blog post: [How I set up my Mac](https://mehuaniket.com/blog/how-do-i-setup-my-mac/)
