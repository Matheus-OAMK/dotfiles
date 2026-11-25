# --- Greeter ---
if [[ $- == *i* ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  () {
    local colors="${XDG_STATE_HOME:-$HOME/.local/state}/theme/current/colors.json" accent
    local -a args
    [[ -r $colors ]] && accent=$(jq -r '.accent // empty' "$colors" 2>/dev/null)
    [[ -n $accent ]] && args=(--logo-color-1 "$accent" --color-keys "$accent")
    fastfetch --config ~/.config/fastfetch/config.jsonc "${args[@]}"
  }
fi

# --- Options ---
# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
HISTSIZE=1000000
SAVEHIST=1000000
setopt histverify	# When you recall a command from history (using ↑ or !), don’t execute it immediately;
setopt sharehistory  # Share command history between sessions
setopt histignoredups     # Don’t record duplicate commands
setopt histignorespace	# Ignore commands that start with space
setopt histreduceblanks   # Remove superfluous blanks
setopt extendedhistory    # Save timestamp and duration of each command

# Others
unsetopt beep # No beeping
setopt auto_cd # Just type dir name to cd
setopt interactivecomments # Allow # comments in the interactive shell


# --- Shell Prompt ---
eval "$(starship init zsh)"


# --- Keybindings ---
KEYTIMEOUT=10 # Timeout quicker
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# extra bindings
bindkey '^H' backward-kill-word # Ctrl+Backspace → delete previous word
bindkey '^[[3;5~' kill-word # Ctrl+Delete → delete next word
# ctrl J & K for going up and down in prev commands
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward
# Ctrl+X Ctrl+E → edit current command in $VISUAL
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- Completion ---
autoload -Uz compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case insensitive and partial completions
zstyle ':completion:*' menu select # Select menu for completions
eval "$(dircolors -b)" # Colors for completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colors for completion menu
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p $XDG_CACHE_HOME/zsh
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)

# --- Aliases ---
alias vi="nvim"
alias vil="NVIM_APPNAME=nvim-lazy nvim"
alias s="kitten ssh"

# Function
d() {
  cd ~/repos/dotfiles || return
  vi +'lua Snacks.explorer({ focus = "input" })'
}

if command -v exa >/dev/null 2>&1; then
    alias ls="eza --icons=auto"
    alias la="eza -a --icons=auto"
    alias lla="eza -la --icons=auto"
    alias lt="eza --tree --icons=auto"
fi

alias cat='bat --paging=never'

# --- FNM ---
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi


source <(fzf --zsh)
eval "$(zoxide init zsh)"

# --- Plugins ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Auto suggestions when typing commands (ghost text)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting for commands (must be sourced last)
