# Aliases
alias y="yazi"
alias home="$EDITOR ~"
alias config="$EDITOR ~/dotfiles"
alias dotfiles='cd ~/dotfiles/'
alias note="cd $NOTES_FOLDER"
alias hg="history | grep"
alias y=yazi
alias lg=lazygit
alias n=nvim
alias vf='nvim $(fzf)'

# Git
alias glog='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias gs="git status"
alias gp="git stash push && git pull && git stash pop"

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

