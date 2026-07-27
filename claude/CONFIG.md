# Configuration

## Settings files — what lives where

| File | Tracked? | Contents |
|------|----------|----------|
| `~/.claude/settings.json` | **symlink → `~/dotfiles/claude/settings.json`** | Portable config: model, permissions.defaultMode, theme, tui, language, editorMode (vim), verbose, worktree.baseRef, useAutoModeDuringPlan, statusLine, enabledPlugins, marketplaces, notification prefs |
| `~/.claude/settings.local.json` | no (gitignored) | Machine-local permission grants |
| `~/.claude.json` | **never** | App state Claude rewrites constantly: machineID, project history, caches, onboarding + UI toggles that live only here (copyOnSelect, leftArrowOpensAgents, defaultToAgentsView, respectGitignore, workflowSizeGuideline) |

> `/config` writes portable options into `settings.json` (picked up by dotfiles automatically via the symlink) and UI/app toggles into `~/.claude.json` (stay per-machine — re-set them via `/config` on a new machine).

## Hooks

The portable `~/.claude/settings.json` registers **no hooks** (the `hooks` key is absent). Hooks run in two other layers, neither of them in this file:

| Layer | Where | What runs |
|-------|-------|-----------|
| Vault (project) | `<vault>/_claude/settings.json` → `PostToolUse` | `validate-hook.sh` → `obsi-validate` after edits (see [../obsidian/SETUP.md](../obsidian/SETUP.md)) |
| Scion agent sessions | agent harness config `~/.scion/harness-configs/<dialect>/…/settings.json` | `sciontool hook --dialect=<dialect>` (SessionStart etc.), mesh-injected per agent |

`speak-summary.py` (TTS after the 🫦 trigger) is symlinked into `~/.claude/hooks/` but is **not wired to any event** — an available opt-in, not an active hook. To enable it, add a `Stop` hook to `settings.json`:

```json
"hooks": { "Stop": [{ "hooks": [{ "type": "command", "command": "python3 ~/.claude/hooks/speak-summary.py" }] }] }
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
| Claude | `~/.claude/mcp-needs-auth-cache.json`, plugin-bundled `.mcp.json`, or via `claude mcp add` | JSON entry with `command`/`url` + auth |
| Codex  | `~/.codex/config.toml`             | `[mcp_servers.<name>]` TOML table           |

Live audit (lists what's actually configured): `bash ~/dotfiles/claude/ai-setup-info.sh` → sections **MCP servers (...)**.
