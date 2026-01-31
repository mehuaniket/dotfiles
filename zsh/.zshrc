# ============================================================================
# Prompt Configuration (oh-my-posh in Ghostty, Powerlevel10k elsewhere)
# ============================================================================

# Detect if running in Ghostty terminal
if [[ "$TERM_PROGRAM" == "ghostty" ]] || [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  # Use oh-my-posh in Ghostty
  if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/p10k-lean.omp.json)"
  fi
else
  # Use Powerlevel10k in other terminals (iTerm2, etc.)
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH
# LLVM
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# OpenJDK
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk@17/include $CPPFLAGS"
# Dart/Flutter
export PATH="$PATH":"$HOME/.pub-cache/bin"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Use Powerlevel10k only when NOT in Ghostty (oh-my-posh handles prompt in Ghostty)
if [[ "$TERM_PROGRAM" != "ghostty" ]] && [[ -z "$GHOSTTY_RESOURCES_DIR" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME=""  # Disable Oh My Zsh theming in Ghostty
fi

# brew shell init 
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
else
    echo "Homebrew is not installed in the standard locations."
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 15

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    kubectl
    z
    tmux
    web-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
# export PATH=/usr/local/opt/python/libexec/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim ~/.zshrc"
alias zshconfig-reload="source ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Only load p10k config when NOT in Ghostty
if [[ "$TERM_PROGRAM" != "ghostty" ]] && [[ -z "$GHOSTTY_RESOURCES_DIR" ]]; then
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# tmux
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
alias fix-tmux-plugins='find ~/.config/tmux/plugins -name "*.sh" -exec chmod +x {} \; && find ~/.config/tmux/plugins -name "*.tmux" -exec chmod +x {} \; && tmux source-file ~/.config/tmux/tmux.conf'

# fzf init (prefer brew-installed bindings/completions)
if command -v brew >/dev/null 2>&1; then
  FZF_BASE="$(brew --prefix)/opt/fzf"
  [ -f "$FZF_BASE/shell/key-bindings.zsh" ] && source "$FZF_BASE/shell/key-bindings.zsh"
  [ -f "$FZF_BASE/shell/completion.zsh" ] && source "$FZF_BASE/shell/completion.zsh"
elif command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
export FZF_CTRL_T_OPTS="--walker-skip .DS_Store,.CFUserTextEncoding,.local,.tmux,.rustup,.ssh,.cache,.Trash,.supermaven,.zsh_sessions,.oh-my-zsh,.git,node_modules,.cargo,target,Library,Applications,Music,Desktop,Documents,Movies,Pictures,go,.cache,.config,.npm --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# fzf, use fd instead of find (fd reads ~/.fdignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --color always'

# Ctrl + T command
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# Alt + C command (ESC + C on MacOS)
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# fuck init (guarded)
if command -v thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
fi

# zoxide init (guarded)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Completion init with cache
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-$ZSH_VERSION"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"
compinit -d "$ZSH_COMPDUMP"

# ============================================================================
# Advanced Completion Configuration
# ============================================================================

# carapace completion
# Note: CARAPACE_BRIDGES disabled to avoid conflicts with Oh My Zsh completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
if command -v carapace >/dev/null 2>&1; then
  source <(carapace _carapace)
fi

# Completion styling and behavior
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'

# Group completions by type
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Menu selection (navigate completions with arrow keys)
zstyle ':completion:*' menu select

# Case-insensitive (all), partial-word and substring completion
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Color completion listings (like ls)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Completion paging (like less) for long lists
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Enhanced process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Enhanced cd completion (don't offer parent directory)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Enhanced ssh/scp/rsync completion (use known_hosts)
zstyle ':completion:*:(ssh|scp|rsync):*' hosts off
zstyle ':completion:*:(ssh|scp|rsync):*:*' users off

# Ignore compiled files
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.pyc' '*~'

# Separate directories from files
zstyle ':completion:*' list-dirs-first true

# Show more info for files
zstyle ':completion:*' file-list all

# "**" command syntax
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# "**" command syntax (for directories only)
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

#k9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# zsh options
## changing directories
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent
setopt pushd_to_home
## Globbing
setopt extended_glob
setopt no_case_glob
setopt numeric_glob_sort
setopt glob
## History
setopt append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history
## I/O
setopt correct
setopt print_exit_value
## Job Control
setopt autoresume
## Scripts
setopt multios
## Completion
setopt always_to_end          # cursor moved to end after completion
setopt auto_list               # automatically list choices on ambiguous completion
setopt auto_menu               # show completion menu on successive tab press
setopt complete_in_word        # complete from both ends of a word
setopt list_packed             # compact completion lists
setopt no_list_beep            # don't beep on ambiguous completions

# git
alias git_config_mehuaniket="git config --local user.name \"Aniket Patel\" && git config user.email 8078990+mehuaniket@users.noreply.github.com"
# alias git_config_work="git config --local user.name \"Aniket Patel\" git config user.email 8078990+work@users.noreply.github.com"
alias git_prune="git reflog expire --expire-unreachable=now --all && git gc --prune=now"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias glme='git log --author="Your Name"'
alias modbash="vi ~/.zshrc; source ~/.zshrc" # Allows you to modify the bash file via vi and immediately allow the new aliases to be used
alias mergefrom="git rebase -p" # Usage: git checkout my_branch; mergefrom develop
alias gcod="git checkout develop"
alias gcob="git checkout -b"
alias gcom="git checkout -" # Returns you to the branch you were just on
alias grename="git branch -m" # Usage: rename my_current_branch_name my_desired_branch_name
alias grebcont="ga .; git rebase --continue" # Use while rebasing after fixing all conflicts
alias gamend="git commit --amend --no-edit" #Useful for merging all staged changes into the previous commit.
alias gl="git log --pretty=oneline -n 20 --graph --abbrev-commit" #Pretty prints the git tree of the last 20 commits.

# nvim
alias vim="nvim"
alias vi="nvim"

# Applications
alias cursor="open -a Cursor"

## Kubernetes
alias k="kubectl"
kn() { kubectl config set-context --current --namespace="$1" }
kv() { kubectl get pod "$1" -o yaml | nvim }

## Terraform
alias tf="terraform"


# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."


# navigation
cx() { cd "$@" && ls -l }
fcd() { cd "$(fd --type d --exclude .git | fzf --no-color --ansi)" && ls -l }
fcopy() { echo "$(fd --type f --exclude .git | fzf --no-color --ansi)" | pbcopy }
fvi() { nvim "$(fd --exclude .git | fzf --no-color --ansi)" }
# Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
