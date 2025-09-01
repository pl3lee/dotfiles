# oh-my-zsh stuff
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
plugins=(git)
source $ZSH/oh-my-zsh.sh

# dotfiles repo
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
if [ -d "$HOME/.scripts" ] && [[ ! ":$PATH:" == *":$HOME/.scripts:"* ]]; then
  export PATH="$HOME/.scripts:$PATH"
fi

# Aliases and variables
export EDITOR="nvim"
export VISUAL="nvim" 
export PATH=$PATH:$HOME/go/bin
source <(fzf --zsh)
alias python='python3'
alias pip='pip3'

# Vi mode in terminal
bindkey -v
VI_MODE_CURSOR_NORMAL=$'\e[2 q'  # Steady Block cursor
VI_MODE_CURSOR_INSERT=$'\e[6 q'  # Steady Bar/I-beam cursor (thin)
function zle-keymap-select () {
  # Check if we are in normal mode (vicmd) or insert mode (main/viins)
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne "${VI_MODE_CURSOR_NORMAL}"
  else
    # 'main' is the default keymap, 'viins' is specifically vi insert mode
    echo -ne "${VI_MODE_CURSOR_INSERT}"
  fi
}
zle -N zle-keymap-select
# Set the initial cursor style when a new command line starts
# (e.g., when you press Enter and get a new prompt)
# We usually start in insert mode.
function zle-line-init () {
  echo -ne "${VI_MODE_CURSOR_INSERT}"
}
zle -N zle-line-init
