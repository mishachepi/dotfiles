# Claude Code Setup

## 1. Install

```bash
brew install claude-code

# QMD — local hybrid search over markdown (MCP server dependency)
bun install -g @tobilu/qmd

# workmux — tmux/worktree orchestrator for multi-agent workflows
curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash
```

## 2. Plugins

```bash
# Marketplaces
claude plugin marketplace add tobi/qmd
claude plugin marketplace add raine/workmux
claude plugin marketplace add mishachepi/m-claude

# Plugins
claude plugin install qmd@qmd
claude plugin install workmux-status
claude plugin install github@claude-plugins-official
claude plugin install plugin-dev@claude-plugins-official
claude plugin install playwright@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install pyright-lsp@claude-plugins-official
claude plugin install ralph-loop@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
claude plugin install core@m-claude-plugins
claude plugin install lead@m-claude-plugins
claude plugin install docs@m-claude-plugins
claude plugin install research@m-claude-plugins
# claude plugin install superpowers@claude-plugins-official  # full dev workflow (brainstorm, plan, TDD, parallel agents)

# Enable plugins (install ≠ enable, must do both)
claude plugin enable qmd@qmd
claude plugin enable workmux-status@workmux
claude plugin enable github@claude-plugins-official
claude plugin enable plugin-dev@claude-plugins-official
claude plugin enable playwright@claude-plugins-official
claude plugin enable pr-review-toolkit@claude-plugins-official
claude plugin enable pyright-lsp@claude-plugins-official
claude plugin enable ralph-loop@claude-plugins-official
claude plugin enable security-guidance@claude-plugins-official
claude plugin enable core@m-claude-plugins
claude plugin enable lead@m-claude-plugins
claude plugin enable docs@m-claude-plugins
claude plugin enable research@m-claude-plugins
```

> After installing/enabling in a running session, use `/reload-plugins` to activate.

| Plugin | Purpose |
|--------|---------|
| `qmd@qmd` | MCP server for hybrid search (lex/vec/hyde) over markdown |
| `workmux-status` | tmux window status hooks (working/waiting/done) |
| `github` | GitHub integration (issues, PRs, checks) |
| `plugin-dev` | Plugin development tools |
| `playwright` | Browser automation |
| `pr-review-toolkit` | Code review agents |
| `pyright-lsp` | Python LSP integration |
| `ralph-loop` | Loop agent |
| `security-guidance` | Security checks |
| `core@m-claude-plugins` | Self-learning workflow — init, learn, optimize, prompt engineering |
| `lead@m-claude-plugins` | Parallel implementation orchestrator — workmux worktree agents |
| `docs@m-claude-plugins` | Documentation management — init docs, update from code |
| `research@m-claude-plugins` | Research and brainstorming — multi-agent research, structured specs |
| `superpowers` (optional) | Full dev workflow — brainstorm, plan, TDD, subagent-driven development |


## 3. Global Settings: `~/.claude/settings.json`

```json
{
  "skipDangerousModePermissionPrompt": true,
  "spinnerTipsEnabled": true,
  "autoUpdatesChannel": "stable",
  "env": {
    "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "1",
    "CLAUDE_CODE_ENABLE_TELEMETRY": "0",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Hooks

| Event | Command | Purpose |
|-------|---------|---------|
| `SessionStart` | `ccbot hook` | Datetime context injection |
| `Stop` | `python3 ~/.claude/hooks/speak-summary.py` | TTS for text after trigger emoji |

> **Note:** workmux status hooks (`working`/`waiting`/`done`) are managed by `workmux-status` plugin — no manual config needed.

## 4. Statusline

Displays `[ModelName]  folder | branch` in the terminal status bar.

```bash
cp ~/dotfiles/claude/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

## 5. Stop Hook (TTS)

Speaks text after trigger emoji using VoiceMode CLI. Voice: `shimmer` (OpenAI), speed `1.0`.

```bash
mkdir -p ~/.claude/hooks
cp ~/dotfiles/claude/hooks/speak-summary.py ~/.claude/hooks/
chmod +x ~/.claude/hooks/speak-summary.py
```

## 6. workmux

Git worktree + tmux orchestrator for multi-agent workflows. Docs: https://workmux.raine.dev

### Install & setup

```bash
# CLI (already in §1)
curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash
```

### Manual step (requires interactive terminal)

```bash
# Install skills (/workmux, /merge, /rebase, /worktree, /coordinator, /open-pr)
workmux setup --skills
```

`workmux setup` detects installed agents and copies skills to `~/.claude/skills/`. Requires interactive terminal — run manually after setup.

### Config

`~/dotfiles/workmux/config.yaml` — agent (`claude`), pane layout, status icons, merge strategy.

```bash
# Symlink global config
ln -sf ~/dotfiles/workmux/config.yaml ~/.config/workmux/config.yaml
```

### CLI commands

```bash
workmux init                       # generate .workmux.yaml with defaults
workmux add <branch>               # new worktree + tmux window
workmux merge <branch>             # merge + cleanup
workmux remove <branch>            # cleanup after PR merge
workmux list                       # all worktrees
workmux send <branch> <msg>        # send prompt to agent
workmux capture <branch>           # get agent output
workmux status                     # check agent statuses
workmux wait                       # block until agents reach target status
workmux run <branch> <cmd>         # run shell command in agent's worktree
```

### Skills

| Skill | Purpose |
|-------|---------|
| `/workmux` | Reference — loads workmux docs into agent context |
| `/merge` | Commit + rebase + merge with smart conflict resolution |
| `/rebase` | Rebase with flexible target (`/rebase origin`, `/rebase feature-branch`) |
| `/worktree` | Delegate tasks to parallel worktree agents (fire and forget) |
| `/coordinator` | Full lifecycle orchestration — spawn, monitor, communicate, merge |
| `/open-pr` | Write PR description from conversation context, open in browser |

**`/worktree` vs `/coordinator`:**
- `/worktree` — fire and forget, you review later
- `/coordinator` — full automation: wait, review, send follow-ups, merge

## 7. MCP Servers

| Server | Source | Purpose |
|--------|--------|---------|
| QMD | `qmd@qmd` plugin | Hybrid search over markdown |
| Google Calendar | Built into Claude Code | Calendar integration |
| Playwright | `playwright@claude-plugins-official` | Browser automation |

## Verification

```bash
which claude workmux qmd
claude plugin list
cat ~/.claude/settings.json
```

After installing plugins in a running session, use `/reload-plugins` to activate them without restarting Claude Code.

### Obsidian setup

Obsidian-specific plugins — see [obsidian/SETUP.md](../obsidian/SETUP.md#4-claude-code-plugins-for-obsidian).
