# Minimal local prompt based on bira and styled after the previous starship.toml.

setopt prompt_subst

function _mch_prompt_host() {
  [[ -n "${SSH_CONNECTION:-}" ]] || return
  print -nr -- "%F{yellow}ssh:%f%m "
}

function _mch_prompt_python() {
  local env_name=""

  if [[ -n "${VIRTUAL_ENV:-}" ]]; then
    env_name="${VIRTUAL_ENV:t}"
  elif [[ -n "${CONDA_DEFAULT_ENV:-}" ]]; then
    env_name="${CONDA_DEFAULT_ENV:t}"
  fi

  [[ -n "${env_name}" ]] || return
  print -nr -- "%F{242}${env_name}%f "
}

ZSH_THEME_GIT_PROMPT_PREFIX="%F{magenta}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{218}*%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{218}+%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{218}!%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{218}>%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{218}x%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red}=%f"
ZSH_THEME_GIT_PROMPT_STASHED="%F{cyan}≡%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}⇡%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{cyan}⇣%f"
ZSH_THEME_GIT_PROMPT_DIVERGED="%F{cyan}⇕%f"

# Username segment disabled:
# %(!.%F{black}%B%n%b%f.%F{white}%B%n%b%f)
PROMPT='$(_mch_prompt_host)%F{blue}%3~%f $(git_prompt_info)$(git_prompt_status)
$(_mch_prompt_python)%(?.%F{white}\$.%F{red}✗)%f '

RPROMPT=""
