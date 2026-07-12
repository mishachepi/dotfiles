#!/usr/bin/env bash
# AI setup audit — Claude Code, Codex, Gemini CLI.
# Read-only. Outputs Markdown.

set -u

# Vault root comes from the environment (set in ~/.local_env.zsh per machine)
VAULT_MAIN="${VAULT_HOME:-}"

H1() { printf '\n# %s\n\n' "$1"; }
H2() { printf '\n## %s\n\n' "$1"; }
H3() { printf '\n### %s\n\n' "$1"; }
KV() { printf -- '- **%s:** %s\n' "$1" "$2"; }

# Print a path with its kind: real / symlink target / missing.
path_info() {
  local p="$1"
  if [[ -L "$p" ]]; then
    printf '`%s` → `%s`' "$p" "$(readlink "$p")"
  elif [[ -e "$p" ]]; then
    printf '`%s` (real)' "$p"
  else
    printf '`%s` _(missing)_' "$p"
  fi
}

list_dir() {
  local p="$1"
  if [[ ! -d "$p" ]]; then
    echo "_(none)_"
    return
  fi
  local items
  items=$(ls -1 "$p" 2>/dev/null)
  if [[ -z "$items" ]]; then
    echo "_(empty)_"
  else
    echo "$items" | sed 's/^/- /'
  fi
}

H1 "AI Setup Audit — $(date '+%Y-%m-%d %H:%M')"

# ---------- CLI tools present ----------
H2 "CLI tools"
for cmd in claude codex gemini; do
  if command -v "$cmd" >/dev/null 2>&1; then
    KV "$cmd" "$(command -v "$cmd")"
  else
    KV "$cmd" "_not installed_"
  fi
done

# ---------- Global config layout ----------
H2 "Global config roots"
for d in ~/.claude ~/.codex ~/.gemini; do
  printf -- '- %s\n' "$(path_info "$d")"
done

H3 "Skills directories (canonical: ~/.claude/skills)"
for d in ~/.claude/skills ~/.codex/skills ~/.gemini/skills; do
  printf -- '- %s\n' "$(path_info "$d")"
done

H3 "Skills (~/.claude/skills)"
list_dir ~/.claude/skills

H3 "Agents (~/.claude/agents)"
list_dir ~/.claude/agents

H3 "Hooks (~/.claude/hooks)"
list_dir ~/.claude/hooks

# ---------- Plugins ----------
H2 "Plugins"

H3 "Marketplaces (~/.claude/plugins/marketplaces)"
list_dir ~/.claude/plugins/marketplaces

H3 "Installed plugins"
local_plugins=~/.claude/plugins/installed_plugins.json
if [[ -f "$local_plugins" ]] && command -v jq >/dev/null 2>&1; then
  jq -r '
    .plugins | to_entries[] | .key as $k |
    .value[] | "- \($k) — scope=\(.scope)" +
      (if .projectPath then " — project=\(.projectPath)" else "" end)
  ' "$local_plugins"
else
  echo "_(jq unavailable or no installed_plugins.json)_"
fi

H3 "Enabled plugins (settings.json)"
if [[ -f ~/.claude/settings.json ]] && command -v jq >/dev/null 2>&1; then
  jq -r '.enabledPlugins // {} | to_entries[] | "- \(.key): \(.value)"' ~/.claude/settings.json
else
  echo "_(no settings.json or jq)_"
fi

# ---------- Settings files ----------
H2 "Settings files"
for f in ~/.claude/settings.json ~/.claude/settings.local.json \
         ~/.claude/settings-personal.json ~/.claude/settings-bedrock.json \
         ~/.codex/config.toml ~/.gemini/settings.json; do
  if [[ -e "$f" ]]; then
    KV "$f" "$(wc -c < "$f" | tr -d ' ') bytes, modified $(stat -f '%Sm' -t '%Y-%m-%d' "$f")"
  fi
done

# ---------- Vaults ----------
H2 "Vaults"

vault_info() {
  local label="$1" root="$2"
  H3 "$label — \`$root\`"
  if [[ ! -d "$root" ]]; then
    echo "_(not mounted / missing)_"
    return
  fi
  for sub in _claude .claude .codex; do
    printf -- '- %s\n' "$(path_info "$root/$sub")"
  done
  for sub in skills rules commands plugins agents scripts; do
    local p="$root/_claude/$sub"
    if [[ -d "$p" ]]; then
      local count
      count=$(ls -1 "$p" 2>/dev/null | wc -l | tr -d ' ')
      KV "_claude/$sub" "$count items"
    fi
  done
  for f in "$root/_claude/settings.json" "$root/_claude/settings.local.json"; do
    [[ -e "$f" ]] && KV "$(basename "$f")" "$(wc -c < "$f" | tr -d ' ') bytes"
  done
}

if [[ -n "$VAULT_MAIN" ]]; then
  vault_info "Main vault" "$VAULT_MAIN"
else
  echo "_(no vault configured — set VAULT_HOME in ~/.local_env.zsh)_"
fi

# ---------- MCP servers ----------
H2 "MCP servers (Claude Code)"
mcp_cache=~/.claude/mcp-needs-auth-cache.json
if [[ -f "$mcp_cache" ]] && command -v jq >/dev/null 2>&1; then
  jq -r 'keys[]' "$mcp_cache" 2>/dev/null | sed 's/^/- /' || echo "_(parse error)_"
fi

H2 "MCP servers (Codex — config.toml)"
if [[ -f ~/.codex/config.toml ]]; then
  grep -E '^\[mcp_servers\.' ~/.codex/config.toml \
    | sed -E 's/^\[mcp_servers\.([^].]+).*$/\1/' \
    | sort -u | sed 's/^/- /'
fi

H2 "MCP servers (Gemini — settings.json)"
if [[ -f ~/.gemini/settings.json ]] && command -v jq >/dev/null 2>&1; then
  jq -r '.mcpServers // {} | keys[]' ~/.gemini/settings.json 2>/dev/null \
    | sed 's/^/- /' || true
fi
