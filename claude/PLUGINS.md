# Plugins

Live state lives in `~/.claude/plugins/installed_plugins.json`; this file is the install playbook.

> Install ≠ enable. Enable only what you actively use; defaults are tracked in `~/.claude/settings.json` `enabledPlugins`. After enabling in a running session: `/reload-plugins`.

## Marketplaces

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add mishachepi/m-claude          # alias: m-claude-plugins
claude plugin marketplace add kepano/obsidian-skills
claude plugin marketplace add tobi/qmd
claude plugin marketplace add raine/workmux
```

## User scope

```bash
claude plugin install context7@claude-plugins-official
claude plugin install plugin-dev@claude-plugins-official
claude plugin install playwright@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install pyright-lsp@claude-plugins-official
claude plugin install ralph-loop@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
claude plugin install skill-creator@claude-plugins-official
claude plugin install workmux-status@workmux
claude plugin install obsidian@obsidian-skills
claude plugin install core@m-claude-plugins
claude plugin install lead@m-claude-plugins
claude plugin install docs@m-claude-plugins
claude plugin install research@m-claude-plugins

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

## Reference

| Plugin | Purpose |
|--------|---------|
| `qmd@qmd` | MCP server: hybrid search (lex/vec/hyde) over markdown |
| `workmux-status@workmux` | tmux window status hooks (working/waiting/done) |
| `context7@claude-plugins-official` | Library docs lookup |
| `plugin-dev@claude-plugins-official` | Plugin scaffolding & validation |
| `playwright@claude-plugins-official` | Browser automation |
| `pr-review-toolkit@claude-plugins-official` | Code review agents |
| `pyright-lsp@claude-plugins-official` | Python LSP integration |
| `ralph-loop@claude-plugins-official` | Loop agent |
| `security-guidance@claude-plugins-official` | Security review checks |
| `skill-creator@claude-plugins-official` | Skill scaffolding |
| `obsidian@obsidian-skills` | Obsidian skills (markdown, bases, canvas, cli, defuddle) |
| `core@m-claude-plugins` | Self-learning workflow — init, learn, optimize |
| `lead@m-claude-plugins` | Parallel implementation orchestrator (workmux worktree agents) |
| `docs@m-claude-plugins` | Documentation management (init, update from code) |
| `research@m-claude-plugins` | Multi-agent research, structured specs |
| `telegram@claude-plugins-official` | Telegram channel access (project: vault) |
| `hookify@claude-plugins-official` | Convert mistakes into preventive hooks (project: vault) |
| `superpowers@claude-plugins-official` (optional) | Full dev workflow — brainstorm, plan, TDD, subagents |
