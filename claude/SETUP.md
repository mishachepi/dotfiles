# Claude Code Setup

Single source of truth: `~/dotfiles/claude/`. Live `~/.claude/` keeps runtime state (cache, sessions); config files are symlinked back here.

Audit current state: `bash ~/dotfiles/claude/ai-setup-info.sh`.

- Plugins: [PLUGINS.md](PLUGINS.md)
- Settings, hooks, agents, MCP: [CONFIG.md](CONFIG.md)
- workmux: [../workmux/README.md](../workmux/README.md)
- Obsidian-specific (vault layout, plugins): [../obsidian/SETUP.md](../obsidian/SETUP.md)

## 1. Install

```bash
brew install claude-code codex gemini-cli codex
bun install -g @tobilu/qmd
curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash
```

## 2. Symlinks

```bash
mkdir -p ~/.claude/hooks

# Config from dotfiles → ~/.claude
ln -sf ~/dotfiles/claude/statusline.sh           ~/.claude/statusline.sh
ln -sf ~/dotfiles/claude/hooks/speak-summary.py  ~/.claude/hooks/speak-summary.py

# Enable statusline in ~/.claude/settings.json (symlink alone is not enough):
#   "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }

# Share skills across CLIs (canonical = ~/.claude/skills)
ln -s ~/.claude/skills ~/.codex/skills
ln -s ~/.claude/skills ~/.gemini/skills
```

For each Obsidian vault root:

```bash
ln -s _claude .claude
ln -s _claude .codex
```

## 3. Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add mishachepi/m-claude
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add raine/workmux
```

Install commands and plugin reference: [PLUGINS.md](PLUGINS.md).

## 4. Verify

```bash
which claude codex gemini workmux qmd
bash ~/dotfiles/claude/ai-setup-info.sh
```

## SteamOS (Steam Deck)

Obsidian runs via Flatpak on SteamOS, sandboxing the CLI socket. Symlink it where the `obsidian` CLI expects:

```bash
ln -sf /run/user/1000/.flatpak/md.obsidian.Obsidian/xdg-run/.obsidian-cli.sock \
  "$XDG_RUNTIME_DIR/.obsidian-cli.sock"
```

> Symlink breaks on each Obsidian restart (new socket). Re-run after restart, or wire into a startup script.
