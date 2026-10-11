# Aliases
alias home='$EDITOR ~'
alias config='$EDITOR ~/dotfiles'
alias hg="history | grep"
alias lg=lazygit
alias j=junior
alias n=nvim
alias vf='nvim $(fzf)'
alias awswho='aws sts get-caller-identity'

# Git
alias gs="git status"
alias gp="git pull"
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

# SSD health (needs smartmontools)
# ssdtemp [volume]      — температура и износ внешнего NVMe (default: $SSD_VOLUME из ~/.local_env.zsh)
# ssdtemp -w [volume]   — непрерывный мониторинг, Ctrl-C для выхода
ssdtemp() {
  local watch=0
  [ "$1" = "-w" ] && { watch=1; shift; }
  local vol="${1:-$SSD_VOLUME}"
  [ -n "$vol" ] || { echo "ssdtemp: укажи том или SSD_VOLUME в ~/.local_env.zsh"; return 1; }
  command -v smartctl >/dev/null || { echo "ssdtemp: нужен smartctl — brew install smartmontools"; return 1; }
  local info dev
  info=$(diskutil info "/Volumes/$vol" 2>/dev/null) || { echo "ssdtemp: том /Volumes/$vol не смонтирован"; return 1; }
  # APFS: том синтезированный, SMART живёт на физическом store (disk8s2 → disk8)
  dev=$(echo "$info" | awk -F': *' '/APFS Physical Store/{print $2}' | sed 's/s[0-9]*$//')
  [ -n "$dev" ] || dev=$(echo "$info" | awk -F': *' '/Part of Whole/{print $2}')
  [ -n "$dev" ] || { echo "ssdtemp: не нашёл устройство для /Volumes/$vol"; return 1; }
  if [ "$watch" = 1 ]; then
    echo "$vol → /dev/$dev  (warning 82°C, critical 85°C)"
    while true; do
      echo "$(date +%H:%M:%S)  $(smartctl -A "/dev/$dev" | awk '/^Temperature Sensor/{printf "%s°C ", $4}')"
      sleep 10
    done
  else
    echo "$vol → /dev/$dev"
    smartctl -A "/dev/$dev" | grep -E "^Temperature Sensor|Percentage Used|Available Spare:|Warning  Comp. Temperature Time"
  fi
}
