# Claude Code Setup

Single source of truth: `~/dotfiles/claude/`. Live `~/.claude/` keeps runtime state (cache, sessions, plugin registry). Scripts are symlinked back here; `settings.json` is **copied** — see §2.

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

## 2. Config → `~/.claude`

```bash
mkdir -p ~/.claude/hooks

# Scripts: symlink (edits here take effect immediately)
ln -sf ~/dotfiles/claude/statusline.sh           ~/.claude/statusline.sh
ln -sf ~/dotfiles/claude/hooks/speak-summary.py  ~/.claude/hooks/speak-summary.py
ln -sf ~/dotfiles/claude/output-styles           ~/.claude/output-styles

# Settings: copy — all four marketplaces (incl. m-claude) are GitHub sources declared
# in settings.json itself, so the copy alone restores them (§3)
cp ~/dotfiles/claude/settings.json ~/.claude/settings.json
```

> **`settings.json` is copied, not symlinked.** Claude Code and its installers rewrite this file in place (`/config`, statusline setup, `claude plugin install/uninstall`), which replaces a symlink with a regular file and silently ends the link. Copying makes that write the normal case instead of a failure mode.
>
> The cost is that the copy drifts. **Both directions are manual:**
> ```bash
> cp ~/dotfiles/claude/settings.json ~/.claude/settings.json    # deploy repo → machine
> cp ~/.claude/settings.json ~/dotfiles/claude/settings.json    # capture machine → repo, then review the diff
> ```
> Capture back after anything that edits settings — `/config`, plugin install/uninstall, enabling a plugin. Review before committing: the live file also carries the machine's own marketplace paths.

```bash
# Share skills across CLIs (canonical = ~/.claude/skills)
ln -s ~/.claude/skills ~/.codex/skills
```

### Framework: skills, agents, commands

The entire personal Claude Code framework (skills, research agents, `init` command, CLAUDE.md templates, worktree-flow) lives in its own repo/marketplace, **not** dotfiles: `mishachepi/m-claude` (public GitHub, `m-claude-plugins`, plugins `core`/`docs`/`research`/`worktree-flow`; dev checkout at `~/SNV/m-claude`). Consolidated there 28.07 — the framework used to be forked into dotfiles as the `mch@dotfiles` plugin, which caused real drift (same output-style file, two diverging copies, one fix never reaching the other). `mch@dotfiles` no longer exists — dotfiles carries no Claude Code plugin at all anymore, only plain config (statusline, hooks, output-styles below). Install/refresh workflow: [PLUGINS.md](PLUGINS.md) §`m-claude` marketplace.

**Output-styles are plain dotfiles content, not plugin content** — `claude/output-styles/` above, symlinked whole-dir into `~/.claude/output-styles` (native Claude Code lookup path, no plugin/marketplace involved). scion agents get the same dir via `pre_start_tmux.sh`'s generic `~/.claude/*` symlink loop (`_scion/client-setup/scripts/pre_start_tmux.sh` — canonical copy, vault-tracked; every machine's `~/.scion/scripts/pre_start_tmux.sh` is a symlink into it, no per-machine drift possible).

Native `~/.claude/skills` entries are untouched by any plugin: `gtasks-cli`, `junior`, `validate` (real dirs) and `scion`, `team-creation` (symlinks into `~/SNV/scion/skills/`).

For each Obsidian vault root (Claude Code looks for `<vault>/.claude`):

```bash
ln -s _claude .claude
```

## 3. Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add mishachepi/m-claude        # GitHub (public) — the whole personal framework
```

All four are GitHub sources, so all four are declared in the tracked `settings.json` — the commands are idempotent and the copy in §2 alone restores them on a new machine.

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
