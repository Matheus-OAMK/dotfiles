# greeter
fastfetch

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
setopt histverify

SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/matheus/.zshrc'
autoload -Uz compinit
compinit
# zstyle ':completion:*' menu select
# End of lines added by compinstall

eval "$(starship init zsh)"

# Custom colours 
cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

# Aliases
alias vil="NVIM_APPNAME=nvim-lazy nvim"
alias vi="NVIM_APPNAME=nvim-custom nvim"
