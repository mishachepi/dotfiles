# Configuration

## Settings files — what lives where

| File | Tracked? | Contents |
|------|----------|----------|
| `~/.claude/settings.json` | **copy of `~/dotfiles/claude/settings.json`** ([SETUP.md](SETUP.md) §2) | Preferences (model, theme, language, editorMode, tui, verbose, outputStyle, notifications) · `permissions` (`defaultMode` + deny list) · the `disable*` hardening flags · `statusLine` · scion `hooks` · `enabledPlugins` · GitHub marketplaces. Plus the local marketplace path, added per machine and not tracked |
| `~/.claude/settings.local.json` | no (gitignored) | Machine-local permission grants |
| `~/.claude.json` | **never** | App state Claude rewrites constantly: machineID, project history, caches, onboarding + UI toggles that live only here (copyOnSelect, leftArrowOpensAgents, defaultToAgentsView, respectGitignore, workflowSizeGuideline) |

> `/config` writes portable options into the **live** `~/.claude/settings.json` and UI/app toggles into `~/.claude.json` (per-machine — re-set them via `/config` on a new machine). Since settings is a copy, a `/config` change does not reach the repo on its own: `cp ~/.claude/settings.json ~/dotfiles/claude/settings.json` and review the diff.

## Hooks

Three layers register hooks; they stack, they do not replace each other:

| Layer | Where | What runs |
|-------|-------|-----------|
| Own sessions | `~/.claude/settings.json` → 8 events | `sciontool hook --dialect=claude` — reports your own sessions to the scion hub. Tracked in dotfiles, so it deploys with the settings copy |
| Vault (project) | `<vault>/_claude/settings.json` → `PostToolUse` | `validate-hook.sh` → `obsi-validate` after edits (see [../obsidian/SETUP.md](../obsidian/SETUP.md)) |
| Scion agent sessions | agent harness config `~/.scion/harness-configs/<dialect>/…/settings.json` | the same `sciontool hook`, seeded per agent — agents never read your `~/.claude/settings.json` |

`speak-summary.py` (TTS after the 🫦 trigger) is symlinked into `~/.claude/hooks/` but is **not wired to any event** — an available opt-in, not an active hook. To enable it, append an entry to the existing `hooks.Stop` array (do not replace it — `sciontool` lives there):

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
