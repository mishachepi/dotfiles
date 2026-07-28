# Plugins

Live state lives in `~/.claude/plugins/installed_plugins.json`; this file is the install playbook.

> Install ≠ enable. Enable only what you actively use; the enabled set is tracked in `~/.claude/settings.json` `enabledPlugins` (currently: `obsidian@obsidian-skills`, `qmd@qmd`, `playwright@claude-plugins-official`, `core@m-claude-plugins`, `docs@m-claude-plugins`, `research@m-claude-plugins`, `worktree-flow@m-claude-plugins`). After enabling in a running session: `/reload-plugins`.
>
> The entire personal framework (skills, research agents, `init` command, CLAUDE.md templates, worktree-flow) lives in its own repo/marketplace `mishachepi/m-claude` (`m-claude-plugins`) — see §`m-claude` marketplace below. dotfiles carries **no Claude Code plugin at all** — the `mch@dotfiles` plugin that used to live here was retired 28.07 (its content was either a stale fork of m-claude, or — `worktree-flow`, the one non-duplicate — migrated into m-claude as its own plugin). Output-styles are plain dotfiles content (`claude/output-styles/`, symlinked into `~/.claude/output-styles`), not a plugin at all — see [SETUP.md](SETUP.md) §2.

## Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add mishachepi/m-claude        # GitHub (public) — the whole personal framework
```

All four are GitHub sources, so all four are declared in the tracked `settings.json` (`extraKnownMarketplaces`) — `marketplace add` is idempotent and the declarations travel with the repo, no per-machine re-registration step.

## `m-claude` marketplace (`m-claude-plugins`)

`mishachepi/m-claude` (public) is its own repo, own marketplace, own versioning per plugin (`plugins/{core,docs,research,worktree-flow}/`, each with its own `plugin.json`). Canonical home for the personal framework — skills (`learn`, `prompt-optimize`, `docs:init`, `docs:update`, `research:brainstorm`, `research:lead-research`, `worktree-flow`), research agents, `init` command, CLAUDE.md templates. Dev checkout for editing stays at `~/SNV/m-claude` (own git remote, independent of dotfiles).

```bash
claude plugin marketplace add mishachepi/m-claude
claude plugin install core@m-claude-plugins
claude plugin install docs@m-claude-plugins
claude plugin install research@m-claude-plugins
claude plugin install worktree-flow@m-claude-plugins
```

> **Refresh after editing the framework.** Edits in `~/SNV/m-claude` need `git commit && git push` before the marketplace can see them — GitHub source, not live-read like a `directory` source. Then pull the marketplace metadata and force a re-copy of the cached plugin content (`install` on an already-installed plugin, or a no-op `plugin update`, won't pick up unversioned content edits):
> ```bash
> claude plugin marketplace update m-claude-plugins
> claude plugin uninstall core@m-claude-plugins && claude plugin install core@m-claude-plugins
> ```
> Then `/reload-plugins` in any running session. (Bumping `version` in the plugin's `.claude-plugin/plugin.json` **and** the marketplace entry makes `claude plugin update <plugin>@m-claude-plugins` pick it up without the uninstall/install dance.)

## User scope

```bash
claude plugin install obsidian@obsidian-skills
claude plugin install playwright@claude-plugins-official
claude plugin install core@m-claude-plugins               # framework — see §`m-claude` marketplace
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
| `core@m-claude-plugins` | Self-learning workflow — `init`, `learn`, `prompt-optimize`, CLAUDE.md templates (mishachepi/m-claude) |
| `docs@m-claude-plugins` | Docs management — init docs structure, update docs from code changes (mishachepi/m-claude) |
| `research@m-claude-plugins` | Research/brainstorming — multi-agent research, structured spec creation (mishachepi/m-claude) |
| `worktree-flow@m-claude-plugins` | Parallel Claude Code agents on native git worktrees (mishachepi/m-claude) |
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
