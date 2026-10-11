# Claude Code Setup

`~/dotfiles/claude/` is the source; `~/.claude/` keeps runtime state. Plugins: [PLUGINS.md](PLUGINS.md) · MCP, hooks: [CONFIG.md](CONFIG.md) · Obsidian: [../obsidian/SETUP.md](../obsidian/SETUP.md).

## 1. Install

```bash
curl -fsSL https://claude.ai/install.sh | bash   # native → ~/.local/bin/claude
brew install --cask codex antigravity-cli        # codex, agy
brew install node
bun install -g @tobilu/qmd
uv tool install "junior @ git+https://github.com/mishachepi/junior.git"
```

## 2. Config

```bash
mkdir -p ~/.claude/hooks
ln -sf ~/dotfiles/claude/statusline.sh           ~/.claude/statusline.sh
ln -sf ~/dotfiles/claude/hooks/speak-summary.py  ~/.claude/hooks/speak-summary.py
ln -sf ~/dotfiles/claude/output-styles           ~/.claude/output-styles
cp     ~/dotfiles/claude/settings.json           ~/.claude/settings.json   # also restores all marketplaces
ln -s  ~/.claude/skills ~/.codex/skills                                     # share skills with Codex
cd <vault> && ln -s _claude .claude                                         # per Obsidian vault
```

`settings.json` is **copied, not symlinked**: Claude Code rewrites it in place (`/config`, plugin install), which would break a symlink. Sync both ways by hand:

```bash
cp ~/dotfiles/claude/settings.json ~/.claude/settings.json   # repo → machine
cp ~/.claude/settings.json ~/dotfiles/claude/settings.json   # machine → repo, then review the diff
```

When capturing back, drop machine state: `sciontool hook` entries (written by scion on the mesh host) and local marketplace paths.

The personal framework (skills, agents, commands) is the `m-claude` marketplace, not dotfiles — see [PLUGINS.md](PLUGINS.md).

## 3. Verify

```bash
which claude codex agy qmd junior
bash ~/dotfiles/claude/ai-setup-info.sh
```
