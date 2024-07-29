[[ $- != *i* ]] && return

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# set vi mode
set -o vi

# Aliases
source $HOME/dotfiles/aliases.sh

# PROMPT Starship https://starship.rs/guide/
eval "$(starship init bash)"
