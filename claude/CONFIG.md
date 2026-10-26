# Configuration

## Settings files

| File | Tracked | Contents |
|------|---------|----------|
| `~/.claude/settings.json` | copy of `claude/settings.json` ([SETUP.md](SETUP.md) §2) | preferences, `permissions`, `disable*` flags, `env`, `statusLine`, `enabledPlugins`, marketplaces |
| `~/.claude/settings.local.json` | no | machine-local permission grants |
| `~/.claude.json` | never | app state + UI toggles from `/config` (re-set per machine) and user-scope MCP servers |

## Hooks

The tracked `settings.json` has no `hooks` key. Active hooks come from elsewhere:

- **Vault:** `<vault>/_claude/settings.json` → `PostToolUse` → `validate-hook.sh` ([../obsidian/SETUP.md](../obsidian/SETUP.md)).
- **Scion mesh:** `sciontool hook` entries written into the live file by scion — machine state, not tracked.
- **tgch:** hook entries written into the live file by tgch — machine state, not tracked.

`speak-summary.py` (speaks the text after `🫦` via VoiceMode; voice/speed set in the script) is symlinked into `~/.claude/hooks/` but not wired. To enable, append to `hooks.Stop` in the live settings (don't replace existing entries):

```json
{ "matcher": "*", "hooks": [{ "type": "command", "command": "python3 ~/.claude/hooks/speak-summary.py" }] }
```

## Statusline

`claude/statusline.sh` — `[Model] 📁 folder | 🌿 branch` + context bar, cost, session time.

## MCP servers

**CLI > MCP:** if a CLI does the job (`obsidian`, `gh`, `cmdbng`, `fini`, `qmd`), use it.

| CLI | Where |
|-----|-------|
| Claude | `claude mcp add -s user …` (→ `~/.claude.json`), project `.mcp.json`, or a plugin's `mcpServers` (`qmd`, `arc`) |
| Codex | `~/.codex/config.toml` → `[mcp_servers.<name>]` |

Google Workspace official MCP (`*mcp.googleapis.com`) is not usable: Workspace-only preview, no dynamic client registration — use a third-party stdio server if needed.

Live state: `bash ~/dotfiles/claude/ai-setup-info.sh`.
