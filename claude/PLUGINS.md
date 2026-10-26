# Plugins

Live state lives in `~/.claude/plugins/installed_plugins.json`; this file is the install playbook.

> Install ≠ enable. Enable only what you actively use. The tracked `claude/settings.json` `enabledPlugins` holds `obsidian@obsidian-skills`, `qmd@qmd` and the m-claude set; `playwright@claude-plugins-official` is enabled only in the live `~/.claude/settings.json`. After enabling in a running session: `/reload-plugins`.
>
> The personal framework (skills, research agents, `init` command, CLAUDE.md templates, worktree-flow) lives in its own repo and marketplace — see §`m-claude` marketplace below. dotfiles carries no Claude Code plugin. Output-styles are plain dotfiles content (`claude/output-styles/`, symlinked into `~/.claude/output-styles`) — see [SETUP.md](SETUP.md) §2.

## Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add mishachepi/m-claude
```

All four are GitHub sources, so all four are declared in the tracked `settings.json` (`extraKnownMarketplaces`) — `marketplace add` is idempotent and the declarations travel with the repo, no per-machine re-registration step.

## `m-claude` marketplace (`m-claude-plugins`)

Marketplace `m-claude-plugins` is a GitHub source: `mishachepi/m-claude` (public), its own repo, own marketplace, own versioning per plugin (one skill = one plugin). The plugin list, what each does and the install commands live in its [README](https://github.com/mishachepi/m-claude#plugins) — not duplicated here; the enabled set on this machine is `enabledPlugins` in `claude/settings.json`. Dev checkout for editing stays at `~/SNV/m-claude` (own git remote, independent of dotfiles).

```bash
claude plugin marketplace add mishachepi/m-claude
claude plugin install learn@m-claude-plugins       # …one line per plugin, see the m-claude README
claude plugin install arc@m-claude-plugins         # Arc browser MCP — macOS only, not on SteamOS
```

> **Refresh after editing the framework.** Edits in `~/SNV/m-claude` need `git commit && git push` before the marketplace can see them — GitHub source, not live-read like a `directory` source. Then pull the marketplace metadata and force a re-copy of the cached plugin content (`install` on an already-installed plugin, or a no-op `plugin update`, won't pick up unversioned content edits):
> ```bash
> claude plugin marketplace update m-claude-plugins
> claude plugin uninstall <plugin>@m-claude-plugins && claude plugin install <plugin>@m-claude-plugins
> ```
> Then `/reload-plugins` in any running session. (Bumping `version` in the plugin's `.claude-plugin/plugin.json` **and** the marketplace entry makes `claude plugin update <plugin>@m-claude-plugins` pick it up without the uninstall/install dance.)

## User scope

```bash
claude plugin install obsidian@obsidian-skills
claude plugin install playwright@claude-plugins-official
# + the m-claude framework plugins — see §`m-claude` marketplace

# Optional — full dev workflow (brainstorm, plan, TDD, parallel agents)
# claude plugin install superpowers@claude-plugins-official
```

## Project scope (vault `<vault>`)

```bash
cd <vault>
claude plugin install qmd@qmd
claude plugin install plugin-dev@claude-plugins-official
claude plugin install telegram@claude-plugins-official
claude plugin install hookify@claude-plugins-official
```

> The vault's `.claude` is a symlink to `_claude`, and `claude plugin install/uninstall` refuses to write through it (`SymlinkWriteRefusedError`). Swap it for the duration of the install, then restore:
> ```bash
> cd <vault> && rm .claude && mv _claude .claude
> claude plugin install <plugin> -s project
> mv .claude _claude && ln -s _claude .claude
> ```

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
| `*@m-claude-plugins` | Personal framework — one plugin per skill, list in the [m-claude README](https://github.com/mishachepi/m-claude#plugins) |
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
