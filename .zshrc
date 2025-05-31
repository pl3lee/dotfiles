export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

if [ -d "$HOME/.scripts" ] && [[ ! ":$PATH:" == *":$HOME/.scripts:"* ]]; then
  export PATH="$HOME/.scripts:$PATH"
fi

export EDITOR="nvim"
export VISUAL="nvim" 

. "$HOME/.local/bin/env"
