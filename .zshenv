# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# bootstrap .zshrc to ~/.config/zsh/.zshrc, any other zsh config files can also reside here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# --- Hyprshot (SCREENSHOTS) ---
export HYPRSHOT_DIR="$HOME/Pictures/Screenshots"

# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_OPTS="--layout=reverse --border=bold --border=rounded --margin=3% --color=dark"

# --- PATH ---
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH

# DEFAULT APPS
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"

# --- Git ---
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/config"

# --- Rust ---
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# --- Python ---
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs

