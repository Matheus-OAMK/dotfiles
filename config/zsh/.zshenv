# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_OPTS="--layout=reverse --border=bold --border=rounded --margin=3% --color=dark"

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# DEFAULT APPS
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"

# Python
export PYTHON_HISTORY=$XDG_STATE_HOME/python_history
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
