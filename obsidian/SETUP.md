# Obsidian Setup

## 1. Install

```bash
# Obsidian — download from obsidian.md or:
brew install --cask obsidian

# Obsidian CLI — enable in Obsidian:
#   Settings -> General -> Command line interface -> Register CLI

# Vault scripts (fm, fm-day, oq, etc.)
cd <vault>/vault_scripts/ && uv tool install .

# ccbot — Obsidian Claude Code bot (creates day notes, processes flow, etc.)
# Install per ccbot repo instructions
```

## 2. QMD — Vault Indexing

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

## 3. Claude Code Plugins for Obsidian

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

## 4. App Config

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
### tasknotes config

```json
{
  "tasksFolder": "tasks",
  "taskIdentificationMethod": "property",
  "taskPropertyName": "type_key",
  "taskPropertyValue": "task",
  "defaultTaskStatus": "Backlog",
  "defaultTaskPriority": "Medium",
  "taskFilenameFormat": "zettel",
  "storeTitleInFilename": true,
  "customFilenameTemplate": "{title}",
  "excludedFolders": "Archive",
  "moveArchivedTasks": true,
  "archiveFolder": "Archive/tasks"
}
```

## Verification

```bash
which obsidian qmd fm-day oq fm
qmd status
obsidian --version
```
