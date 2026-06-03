# --- Greeter ---
if [[ $- == *i* ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
    fastfetch
fi

# --- Options ---
# History
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
HISTSIZE=1000000
SAVEHIST=1000000
setopt histverify	# When you recall a command from history (using ↑ or !), don’t execute it immediately;
setopt inc_append_history # Append commands to history as they are entered, rather than on shell close
setopt sharehistory  # Share command history between sessions
setopt histignoredups     # Don’t record duplicate commands
setopt histignorespace	# Ignore commands that start with space
setopt histreduceblanks   # Remove superfluous blanks

# Others
unsetopt beep # No beeping
setopt auto_cd # Just type dir name to cd


# --- Shell Prompt ---
eval "$(starship init zsh)"


# --- Keybindings ---
export KEYTIMEOUT=10 # Timeout quicker
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

## Sessionizer 
bindkey -s '^f' $'tmux-sessionizer\r'
bindkey -s '\eh' $'tmux-sessionizer -s 0\r'

# --- Completion ---
autoload -Uz compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case insensitive and partial completions
zstyle ':completion:*' menu select # Select menu for completions
eval "$(dircolors -b)" # Colors for completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colors for completion menu
compinit
_comp_options+=(globdots)
zstyle :compinstall filename "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"

# --- Plugins ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh # Auto suggestions when typing commands (ghost text)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Syntax highlighting for commands


# --- Aliases ---
alias vil="NVIM_APPNAME=nvim-lazy nvim"
alias vi="nvim"

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

alias cat=bat --paging=never --color=always

# --- FNM ---
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi


# --- PNPM ---
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac


source <(fzf --zsh)

