# dotfiles

## Setup

### Install Homebrew Packages

```bash

# Leaving a machine
brew bundle dump --force 

# Fresh enstallation
brew bundle install && brew cleanup

```

### Stowing

```bash

zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mehuaniket/dotfiles/main/scripts/setup.sh)" 

```

- Import `iterm_default_profile.json` by going to settings > profiles >  
  other actions > import JSON profiles
- Delete old default profile
- Restart Terminal  
- Open Nvim

```bash
nvim .
```

- Refer to [blog](https://mehuaniket.com/blog/how-do-i-setup-my-mac/)
