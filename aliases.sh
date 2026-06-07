# Aliases
alias home='$EDITOR ~'
alias config='$EDITOR ~/dotfiles'
alias dotfiles='cd ~/dotfiles/'
alias note='cd "$NOTES_FOLDER"'
alias hg="history | grep"
alias lg=lazygit
alias j=junior
alias n=nvim
alias vf='nvim $(fzf)'
alias awswho='aws sts get-caller-identity'

# Git
alias gs="git status"
alias gpp="git stash push && git pull && git stash pop"

# k8s
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgd="kubectl get deploy"
alias kgs="kubectl get services"
alias kgn="kubectl get namespace"
alias kl="kubectl logs"
alias kd="kubectl describe"

# tmux
alias tma="tmux attach"

# workmux
alias wm="workmux"
