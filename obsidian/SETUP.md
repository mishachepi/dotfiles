# Obsidian Setup

## 1. Install

```bash
# Obsidian — download from obsidian.md or:
brew install --cask obsidian

# Obsidian CLI — enable in Obsidian:
#   Settings -> General -> Command line interface -> Register CLI

# obsi-tools monorepo (fm, oq, fini, polar-import, life-dashboard, fini-bot)
git clone git@github.com:mishachepi/obsi-tools.git $VAULT_TOOLS
cd $VAULT_TOOLS # ask user to provide dir

# Install CLI tools globally
uv tool install --from packages/fm fm --force
uv tool install --from packages/oq oq --force
uv tool install --from packages/fini fini --force
uv tool install --from packages/polar-import polar-import --force

# life-dashboard: run from workspace
uv sync  # installs all workspace deps
uv run life-dashboard  # or: uv run streamlit run packages/life-dashboard/src/life_dashboard/app.py

# fini-bot — Telegram bot for finance tracking

## 2. Claude Code symlink
Claude Code looks for `<vault>/.claude/` directory. Symlink it to `_claude/` (tracked in git):

```bash
ln -sf $VAULT_HOME/_claude $VAULT_HOME/.claude
```

This makes `settings.json`, `rules/`, `skills/`, `commands/`, `scripts/` visible to Claude Code when working in the vault.

## 2.5. Scion templates mirror for Obsidian Sync
The scion mesh lives in `.scion/` (real dir — runtime state, scripts, logs, templates). Obsidian doesn't sync dotfolders, so agent templates would be invisible to Sync. Mirror only the templates dir under a `_scion/` wrapper so it shows up in Obsidian:

```bash
mkdir -p $VAULT_HOME/_scion
ln -sf ../.scion/templates $VAULT_HOME/_scion/templates
```

Notes:
- `.scion/` itself stays real and dotfile-hidden (runtime: agents/, logs/, scripts/, README, routines, etc.). Don't symlink the whole thing — only `templates/` needs Obsidian visibility.
- `_scion/templates` is whitelisted in `.gitignore` (`!_scion/templates`).
- macOS crontab entries (`for-agent-dispatcher.sh`, `orchestrator-healthcheck.sh`) reference `/Volumes/mch/.scion/scripts/...` directly — no change needed.

## 3. QMD — Vault Indexing

Requires `qmd` CLI — installed as part of [Claude Code setup](../claude/SETUP.md#1-install).

```bash
# Run from PARENT directory of vault (QMD resolves paths relative to CWD)
cd /parent/of/vault
qmd collection add <vault-name> <vault-name>
qmd status
qmd embed   # optional — enables semantic/vector search
```

> **Note:** QMD resolves paths relative to CWD. The collection name becomes
> a subfolder under CWD, so run from the parent directory.

## 4. Claude Code Plugins for Obsidian

QMD plugin is installed as part of [Claude Code setup](../claude/SETUP.md#2-plugins).

```bash
# QMD skill for Claude Code (search over markdown)
qmd skill install

# Official Obsidian skills
claude plugin marketplace add kepano/obsidian-skills
claude plugin install obsidian@obsidian-skills
```

| Plugin | Source | Purpose |
|--------|--------|---------|
| `obsidian@obsidian-skills` | `kepano/obsidian-skills` | Official Obsidian skills (markdown, canvas, bases, CLI) |

> **Note:** `mishachepi/m-claude` marketplace (core, lead, docs, research) is installed in [Claude Code setup](../claude/SETUP.md#2-plugins).

### Global Rules

```bash
mkdir -p ~/.claude/rules
cp ~/dotfiles/obsidian/rules/*.md ~/.claude/rules/
```

| Rule | Purpose |
|------|---------|
| `session-log.md` | After every meaningful action, append log entry to today's day note via `echo >> $VAULT_HOME/days/...` |

### Agents

Install agents globally:

```bash
cp ~/dotfiles/obsidian/agents/*.md ~/.claude/agents/
```

| Agent | Trigger | Purpose |
|-------|---------|---------|
| `/note <vault>` | "save to obsidian", "remember this", "запомни" | Create note in `inbox/` with frontmatter + inbox tag. Reads vault's `CLAUDE.md` first. All `obsidian:*` skills available. File: `obsi-note.md` |
| `/ask` | "find in notes", "what do I have about", "найди в заметках" | Search vault via QMD (hybrid search), retrieve content via Obsidian CLI, synthesize answer with `[[wikilinks]]` to sources. File: `obsi-ask.md` |

Enable plugins in project settings (`<vault>/claude/settings.json`):

```json
{
  "enabledPlugins": {
    "qmd@qmd": true
  }
}
```

## 5. App Config

Copy configs from `obsidian/configs/` to `<vault>/.obsidian/`:

```bash
DOTFILES=~/dotfiles/obsidian/configs
VAULT=<path-to-vault>/.obsidian

# Review diffs before copying
diff "$DOTFILES/app.json" "$VAULT/app.json"

# Copy what you need
cp "$DOTFILES/app.json" "$VAULT/"
cp "$DOTFILES/appearance.json" "$VAULT/"
cp "$DOTFILES/hotkeys.json" "$VAULT/"
cp "$DOTFILES/core-plugins.json" "$VAULT/"
cp "$DOTFILES/community-plugins.json" "$VAULT/"
cp "$DOTFILES/templates.json" "$VAULT/"
cp "$DOTFILES/switcher.json" "$VAULT/"
```

Restart Obsidian after copying.

Full plugin list (installed in `.obsidian/plugins/`):

| Plugin | Purpose |
|--------|---------|
| `dataview` | Vault queries (DQL) |
| `tasknotes` | Task management via frontmatter |
| `table-editor-obsidian` | Table editor |
| `obsidian-chartsview-plugin` | Charts |
| `templater-obsidian` | Templates with JS |
| `omnisearch` | Full-text search |
| `heatmap-calendar` | Activity heatmap |
| `obsidian-excalidraw-plugin` | Drawing/diagrams |
| `obsidian-advanced-uri` | URI scheme for automation |
| `obsidian-annotator` | PDF/epub annotations |
| `obsidian-minimal-settings` | Minimal theme settings |
| `obsidian-paste-image-rename` | Rename pasted images |
| `advanced-merger` | Note merging |
| `file-diff` | Diff between notes |
| `folders2graph` | Folder -> graph visualization |

## 6. Daily Auto-Commit

Cron job runs every night: ETL (fm day, fm polar, fm area) → git commit.

```bash
# Scripts live in vault-tools, symlinked to vault
# Symlinks are created during vault-tools setup (see vault-tools README)
# Just add crontab:
(crontab -l 2>/dev/null; echo '42 23 * * * $VAULT_HOME/_claude/scripts/vault-commit.sh $VAULT_HOME >> $VAULT_HOME/_inbox/tmp/vault-commit.log 2>&1') | crontab -
```

**What it does (in order):**
1. `fm -y day` — parse day notes → frontmatter metrics (time, habits, finance)
2. `fm -y polar` — import Polar watch data (sleep, steps, HR)
3. `fm -y area` — aggregate area health from children
4. `git add -A && git commit` — snapshot with date + day-of-week
5. Log each step to today's day note

## Verification

```bash
which obsidian qmd fm oq fini polar-import
qmd status
obsidian --version
```
