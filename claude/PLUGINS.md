# Plugins

Live state lives in `~/.claude/plugins/installed_plugins.json`; this file is the install playbook.

> Install ≠ enable. Enable only what you actively use; the enabled set is tracked in `~/.claude/settings.json` `enabledPlugins` (currently: `obsidian@obsidian-skills`, `qmd@qmd`, `playwright@claude-plugins-official`, `core@m-claude-plugins`, `docs@m-claude-plugins`, `research@m-claude-plugins`, `worktree-flow@m-claude-plugins`). After enabling in a running session: `/reload-plugins`.
>
> The entire personal framework (skills, research agents, `init` command, CLAUDE.md templates, worktree-flow) lives in its own repo/marketplace `~/SNV/m-claude` (`m-claude-plugins`) — see §Local marketplace below. dotfiles carries **no Claude Code plugin at all** — the `mch@dotfiles` plugin that used to live here was retired 28.07 (its content was either a stale fork of m-claude, or — `worktree-flow`, the one non-duplicate — migrated into m-claude as its own plugin). Output-styles are plain dotfiles content (`claude/output-styles/`, symlinked into `~/.claude/output-styles`), not a plugin at all — see [SETUP.md](SETUP.md) §2.

## Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add ~/SNV/m-claude             # local — the whole personal framework
```

## Local marketplace (`m-claude` → `m-claude-plugins`)

`~/SNV/m-claude` is its own repo, own marketplace, own versioning per plugin (`plugins/{core,docs,research,worktree-flow}/`, each with its own `plugin.json`). Canonical home for the personal framework — skills (`learn`, `prompt-optimize`, `docs:init`, `docs:update`, `research:brainstorm`, `research:lead-research`, `worktree-flow`), research agents, `init` command, CLAUDE.md templates.

```bash
claude plugin marketplace add ~/SNV/m-claude
claude plugin install core@m-claude-plugins
claude plugin install docs@m-claude-plugins
claude plugin install research@m-claude-plugins
claude plugin install worktree-flow@m-claude-plugins
```

> **Refresh after editing the framework.** The marketplace reads `~/SNV/m-claude` live, but `install` copies each plugin into `~/.claude/plugins/cache/m-claude-plugins/<plugin>/<version>/` **once**. `plugin update` is version-gated (no-op unless `version` in the plugin's `.claude-plugin/plugin.json` **and** the marketplace entry are bumped); `install` on an already-installed plugin is also a no-op. So to pick up content edits without a version bump, force a re-copy per plugin:
> ```bash
> claude plugin uninstall core@m-claude-plugins && claude plugin install core@m-claude-plugins
> ```
> Then `/reload-plugins` in any running session. (Bumping `version` + `claude plugin marketplace update m-claude-plugins && claude plugin update <plugin>@m-claude-plugins` is the release-style alternative.)

> **The path is machine-specific and never tracked.** A `directory` marketplace resolves against an absolute path, and `~/SNV/m-claude` expands differently per user and OS. So the tracked `settings.json` deliberately declares only the three GitHub marketplaces; the local one is registered by command:
> ```bash
> claude plugin marketplace add ~/SNV/m-claude
> ```
> The shell expands `~`, and Claude Code writes the resulting absolute path into this machine's own `~/.claude/settings.json` and `~/.claude/plugins/known_marketplaces.json`. Re-run after every `cp` of settings ([SETUP.md](SETUP.md) §2) — the copy from the repo has no local entry to inherit. Nothing to override, nothing to fork per machine.

## User scope

```bash
claude plugin install obsidian@obsidian-skills
claude plugin install playwright@claude-plugins-official
claude plugin install core@m-claude-plugins               # framework — see §Local marketplace
claude plugin install docs@m-claude-plugins
claude plugin install research@m-claude-plugins
claude plugin install worktree-flow@m-claude-plugins

# Optional — full dev workflow (brainstorm, plan, TDD, parallel agents)
# claude plugin install superpowers@claude-plugins-official
```

## Project scope (vault `/Volumes/mch`)

```bash
cd /Volumes/mch
claude plugin install qmd@qmd
claude plugin install plugin-dev@claude-plugins-official
claude plugin install telegram@claude-plugins-official
claude plugin install hookify@claude-plugins-official
```

## Local / dev scope (per-project, ad-hoc)

Session-local plugins, stored in that project's gitignored `settings.local.json`. Not part of the canonical setup — install them in whichever code project needs them, from that project's directory:

```bash
claude plugin install code-review@claude-plugins-official
claude plugin install code-simplifier@claude-plugins-official
claude plugin install pyright-lsp@claude-plugins-official
```

> **Install from your own session, never from inside an agent.** The plugin registry (`~/.claude/plugins/`) is shared: scion agents reach it through a symlink from their fake-HOME, so a plugin installed by an agent is recorded with an `installPath` inside that agent's sandbox. The payload lands in the shared cache and works, but the registry entry dies with the agent. `claude plugin list` shows such entries as `Version: unknown`.

## Reference

| Plugin | Purpose |
|--------|---------|
| `core@m-claude-plugins` | Self-learning workflow — `init`, `learn`, `prompt-optimize`, CLAUDE.md templates (local marketplace) |
| `docs@m-claude-plugins` | Docs management — init docs structure, update docs from code changes (local marketplace) |
| `research@m-claude-plugins` | Research/brainstorming — multi-agent research, structured spec creation (local marketplace) |
| `worktree-flow@m-claude-plugins` | Parallel Claude Code agents on native git worktrees (local marketplace) |
| `obsidian@obsidian-skills` | Obsidian skills (markdown, bases, canvas, cli, defuddle) |
| `playwright@claude-plugins-official` | Browser automation |
| `qmd@qmd` | MCP server: hybrid search (lex/vec/hyde) over markdown |
| `plugin-dev@claude-plugins-official` | Plugin scaffolding & validation |
| `telegram@claude-plugins-official` | Telegram channel access (project: vault) |
| `hookify@claude-plugins-official` | Convert mistakes into preventive hooks (project: vault) |
| `code-review@claude-plugins-official` | Code review agents (local scope) |
| `code-simplifier@claude-plugins-official` | Code simplification (local scope) |
| `pyright-lsp@claude-plugins-official` | Python LSP integration (local scope) |
| `superpowers@claude-plugins-official` (optional) | Full dev workflow — brainstorm, plan, TDD, subagents |
