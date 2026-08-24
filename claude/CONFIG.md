# Configuration

## Settings files — what lives where

| File | Tracked? | Contents |
|------|----------|----------|
| `~/.claude/settings.json` | **copy of `~/dotfiles/claude/settings.json`** ([SETUP.md](SETUP.md) §2) | Preferences (model, theme, language, editorMode, tui, verbose, outputStyle, notifications) · `permissions` (`defaultMode` + deny list) · the `disable*` hardening flags · `statusLine` · `enabledPlugins` · GitHub marketplaces. Plus the local marketplace path, added per machine and not tracked |
| `~/.claude/settings.local.json` | no (gitignored) | Machine-local permission grants |
| `~/.claude.json` | **never** | App state Claude rewrites constantly: machineID, project history, caches, onboarding + UI toggles that live only here (copyOnSelect, leftArrowOpensAgents, defaultToAgentsView, respectGitignore, workflowSizeGuideline) |

> `/config` writes portable options into the **live** `~/.claude/settings.json` and UI/app toggles into `~/.claude.json` (per-machine — re-set them via `/config` on a new machine). Since settings is a copy, a `/config` change does not reach the repo on its own: `cp ~/.claude/settings.json ~/dotfiles/claude/settings.json` and review the diff.

## Hooks

`~/dotfiles/claude/settings.json` ships with **no `hooks` key at all** — the base Claude Code setup here has no dependency on anything beyond Claude Code itself.

| Layer | Where | What runs |
|-------|-------|-----------|
| Vault (project) | `<vault>/_claude/settings.json` → `PostToolUse` | `validate-hook.sh` → `obsi-validate` after edits (see [../obsidian/SETUP.md](../obsidian/SETUP.md)) |

Agent-mesh session hooks (own sessions reporting to a hub, per-agent harness hooks) are **not a dotfiles concern** — that setup, if this machine runs it, lives entirely in its own separate private repo and layers on top via its own install script; dotfiles neither knows nor cares whether it's present.

`speak-summary.py` (TTS after the 🫦 trigger) is symlinked into `~/.claude/hooks/` but is **not wired to any event** — an available opt-in, not an active hook. To enable it: if `~/.claude/settings.json`'s `hooks.Stop` array already has entries (e.g. layered in by the agent-mesh install script above), append to it, don't replace it; otherwise add the key directly:

```json
{ "matcher": "*", "hooks": [{ "type": "command", "command": "python3 ~/.claude/hooks/speak-summary.py" }] }
```

### speak-summary.py (optional TTS helper)

Speaks the text following the trigger emoji (`🫦`) using VoiceMode CLI. File: `~/dotfiles/claude/hooks/speak-summary.py`, symlinked into `~/.claude/hooks/`.

| Setting        | Default    |
|----------------|------------|
| Voice          | `shimmer` (OpenAI; alternatives: nova, alloy, echo, fable, onyx; Kokoro: af_sky, af_bella, am_adam, am_michael) |
| Speed          | `1.0` (range `0.25`–`4.0`) |
| Trigger emoji  | `🫦`       |

## Statusline

`~/dotfiles/claude/statusline.sh` — two lines: `[Model] 📁 folder | 🌿 branch` and a context-usage bar (green/yellow/red) + cost + session time. Symlinked into `~/.claude/statusline.sh` and enabled in `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
```

## MCP servers

> **Preference: CLI > MCP.** If a task is doable with a CLI (`obsidian`, `gh`, `cmdbng`, `fini`, `qmd`), use that. MCP is for things without a good CLI surface.

How to add an MCP server, per CLI:

| CLI    | Where                              | Format                                      |
|--------|------------------------------------|---------------------------------------------|
| Claude | `claude mcp add`, a project `.mcp.json`, or a plugin that declares `mcpServers` in its marketplace manifest (this is how `qmd` arrives) | JSON entry with `command`/`url` + auth |
| Codex  | `~/.codex/config.toml`             | `[mcp_servers.<name>]` TOML table           |

Live audit (lists what's actually configured): `bash ~/dotfiles/claude/ai-setup-info.sh` → sections **MCP servers (...)**.
