# Claude Code Setup

Single source of truth: `~/dotfiles/claude/`. Live `~/.claude/` keeps runtime state (cache, sessions); config files are symlinked back here.

Audit current state: `bash ~/dotfiles/claude/ai-setup-info.sh`.

- Plugins: [PLUGINS.md](PLUGINS.md)
- Settings, hooks, agents, MCP: [CONFIG.md](CONFIG.md)
- Obsidian-specific (vault layout, plugins): [../obsidian/SETUP.md](../obsidian/SETUP.md)

## 1. Install

```bash
brew install claude-code                         # brew cask: no self-update, lags behind native
brew install --cask codex
brew install --cask antigravity-cli               # Google Antigravity CLI (command: agy)
brew install node
bun install -g @tobilu/qmd
uv tool install "junior @ git+https://github.com/mishachepi/junior.git"   # runbook runner, see §Junior
```

## 2. Symlinks

```bash
mkdir -p ~/.claude/hooks

# Config from dotfiles → ~/.claude
ln -sf ~/dotfiles/claude/settings.json           ~/.claude/settings.json
ln -sf ~/dotfiles/claude/statusline.sh           ~/.claude/statusline.sh
ln -sf ~/dotfiles/claude/hooks/speak-summary.py  ~/.claude/hooks/speak-summary.py

# Share skills across CLIs (canonical = ~/.claude/skills)
ln -s ~/.claude/skills ~/.codex/skills
```

For each Obsidian vault root (Claude Code looks for `<vault>/.claude`):

```bash
ln -s _claude .claude
```

## 3. Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add mishachepi/m-claude
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
```

Install commands and plugin reference: [PLUGINS.md](PLUGINS.md).

## 4. Verify

```bash
which claude codex agy qmd junior
bash ~/dotfiles/claude/ai-setup-info.sh
```

## Junior (runbooks)

[Junior](https://github.com/mishachepi/junior) — deterministic runbook runner: `collect` (shell) → **one schema-validated LLM call** → `publish` (shell). Fits between skills (interactive) and cron scripts (no LLM): use it when a job needs exactly one structured LLM step and must run headless.

- Install: `uv tool install "junior @ git+https://github.com/mishachepi/junior.git"` (default harness `claudecode` drives the `claude` CLI — no API key needed).
- Built-in runbooks: `local_review` (review the local git diff), `github_pr_review`, `weather_advice` (smoke test). `junior list` shows runbooks + harness status, `junior dry-run` previews without an LLM call.
- Custom runbooks live per-project in `.junior/runbooks/<name>/` (YAML manifest + `prompt.md` + `schema.json` + collect/publish scripts). Config: `.junior.yaml` at the project root.
- **Vault runbooks** (morning-start, end-day, expense-parse, …) live in the vault: docs + prompts in `$VAULT_HOME/_junior/runbooks/` (see its `README.md` for ownership and conventions); run from the vault root, cron via `loop-init` on the mesh host.
- Rule of thumb from the vault README: CLI-backed jobs → junior runbooks; MCP-backed integrations (Gmail, Jira, Confluence) stay in interactive skills/agents.

## SteamOS (Steam Deck)

Obsidian runs via Flatpak on SteamOS, sandboxing the CLI socket. Symlink it where the `obsidian` CLI expects:

```bash
ln -sf /run/user/1000/.flatpak/md.obsidian.Obsidian/xdg-run/.obsidian-cli.sock \
  "$XDG_RUNTIME_DIR/.obsidian-cli.sock"
```

> Symlink breaks on each Obsidian restart (new socket). Re-run after restart, or wire into a startup script.
