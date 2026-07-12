# Configuration

## Hooks

| Event  | Command                                       | Purpose                                 |
|--------|-----------------------------------------------|-----------------------------------------|
| `Stop` | `python3 ~/.claude/hooks/speak-summary.py`    | TTS for text after trigger emoji 🫦     |

> workmux status hooks (`working`/`waiting`/`done`) are managed by `workmux-status` plugin — no manual config.

### Stop hook: speak-summary.py

Speaks the text following the trigger emoji (`🫦`) using VoiceMode CLI.

| Setting        | Default    |
|----------------|------------|
| Voice          | `shimmer` (OpenAI; alternatives: nova, alloy, echo, fable, onyx; Kokoro: af_sky, af_bella, am_adam, am_michael) |
| Speed          | `1.0` (range `0.25`–`4.0`) |
| Trigger emoji  | `🫦`       |

File lives in `~/dotfiles/claude/hooks/speak-summary.py` and is symlinked into `~/.claude/hooks/`.

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
| Gemini | `~/.gemini/settings.json`          | `"mcpServers": { "<name>": { ... } }`       |

Live audit (lists what's actually configured): `bash ~/dotfiles/claude/ai-setup-info.sh` → sections **MCP servers (...)**.
