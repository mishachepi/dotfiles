# Obsidian Setup

## 1. Install

```bash
# Obsidian — download from obsidian.md or:
brew install --cask obsidian

# Obsidian CLI — enable in Obsidian:
#   Settings -> General -> Command line interface -> Register CLI

# obsi-tools monorepo (fm, oq, fini, logi, polar-import, gtasks-sync, life-dashboard, log-bot)
git clone git@github.com:mishachepi/obsi-tools.git ~/obsi-tools
cd ~/obsi-tools

# Install CLI tools globally.
# Use --reinstall --no-cache, NOT --force: --force silently reuses a cached
# build, reports success, and leaves the old binary in place.
uv tool install --from packages/fm fm --reinstall --no-cache
uv tool install --from packages/oq oq --reinstall --no-cache
uv tool install --from packages/fini fini --reinstall --no-cache
uv tool install --from packages/logi logi --reinstall --no-cache
uv tool install --from packages/polar-import polar-import --reinstall --no-cache
uv tool install --from packages/gtasks-sync gtasks-sync --reinstall --no-cache

# life-dashboard: run from workspace
uv sync  # installs all workspace deps
uv run life-dashboard  # or: uv run streamlit run packages/life-dashboard/src/life_dashboard/app.py

# log-bot — Telegram bot for whole-day capture (finance via fini)
```

### obsi-validate (blocking validate hook)

`obsi-validate` is a **separate repo** (`mishachepi/obsi-validate`), installed as a **bun global tool** — not part of the obsi-tools monorepo. The vault's PostToolUse validate hook (`_claude/scripts/validate-hook.sh`) calls it as bare `obsi-validate` and **fails if it is not on PATH**, so `~/.bun/bin` must be on PATH.

```bash
git clone git@github.com:mishachepi/obsi-validate.git ~/SNV/obsi-validate
cd ~/SNV/obsi-validate
bun install
npm run build:cli && bun link      # links ~/.bun/bin/obsi-validate

# ensure ~/.bun/bin is on PATH (add to ~/.zshrc if missing), then verify:
command -v obsi-validate
```

### Google Tasks CLI (`gtasks`)

CLI-клиент Google Tasks ([BRO3886/gtasks](https://github.com/BRO3886/gtasks)). Используется для синхронизации задач из Google Tasks (входящие письма с конвертацией в task, напоминания) с vault-workflow. Claude Code умеет вызывать его через `gtasks-cli` skill.

```bash
# Install via brew tap
brew tap bro3886/tap
brew install gtasks
# или одной строкой: brew install bro3886/tap/gtasks

# 1. Создай OAuth2-приложение в Google Cloud Console
#    - https://console.cloud.google.com/ → новый/существующий проект
#    - Enable APIs → Google Tasks API
#    - Credentials → Create OAuth client ID → Application type: "Desktop app"
#    - Сохрани client_id и client_secret

# 2. Положи credentials в конфиг (chmod 600 обязательно)
mkdir -p ~/.config/gtasks
cat > ~/.config/gtasks/config.toml <<'EOF'
[credentials]
client_id     = "PASTE_CLIENT_ID.apps.googleusercontent.com"
client_secret = "PASTE_CLIENT_SECRET"

[tasks]
# default_task_list = "Backlog"  # опционально — список по умолчанию для -l
EOF
chmod 600 ~/.config/gtasks/config.toml

# 3. OAuth-login (откроется браузер, токен уйдёт в Keychain)
gtasks login

# 4. Skill для Claude Code (положит skill в ~/.claude/skills/gtasks-cli/)
gtasks skills install --agent claude

# Проверка
gtasks tasklists view
gtasks skills status
```

## 2. Claude Code symlink
Claude Code looks for `<vault>/.claude/` directory. Symlink it to `_claude/` (tracked in git):

```bash
# relative target — survives moving the vault to a different path
# -h: replace an existing symlink instead of following it into the directory
ln -sfh _claude $VAULT_HOME/.claude

# junior runbooks (vault keeps them in _junior/ so Obsidian Sync sees them;
# junior discovers .junior/ — symlinks don't sync, re-create per machine)
ln -sfh _junior $VAULT_HOME/.junior
```

This makes `settings.json`, `rules/`, `skills/`, `commands/`, `scripts/` visible to Claude Code when working in the vault.

## 2.5. Scion templates for Obsidian Sync
The scion mesh runtime lives in `.scion/` (real dotfolder: agents/, logs/, scripts/, routines). Obsidian Sync ignores dotfolders **and does not carry symlinks** — so agent templates must live as REAL files under a non-dot, synced path, and the runtime points at them (not the other way around).

Therefore the real dir is `_scion/templates` (Sync carries it), and `.scion/templates` is a symlink into it:

```bash
mkdir -p $VAULT_HOME/_scion/templates      # REAL dir — Obsidian Sync carries these files
ln -sfh ../_scion/templates $VAULT_HOME/.scion/templates
```

Notes:
- The rest of `.scion/` stays a real dotfolder (runtime: agents/, logs/, scripts/, README, routines). Only `templates/` is redirected to the synced `_scion/templates`.
- `_scion/templates` is whitelisted in `.gitignore` (`!_scion/templates`).
- **Obsidian → Settings → Sync → "Sync all other file types" must be ON**, or the `.sh` boot scripts under `templates/*/home/` silently never propagate to other machines (they are not markdown, and Sync is markdown-only by default). Symptom: a freshly-spawned agent boots with an empty `home/` and a missing `context.sh`.
- macOS crontab sets `VAULT_HOME` in its header and references `$VAULT_HOME/...` throughout — no absolute paths, so layout changes need only the one crontab line.

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

Rules are **copied**, so `~/.claude/rules/*` silently drifts from the repo — re-run the `cp` after editing any rule (or symlink instead for live updates):

```bash
mkdir -p ~/.claude/rules
cp ~/dotfiles/obsidian/rules/*.md ~/.claude/rules/
# live alternative — edits in the repo take effect immediately:
# for f in ~/dotfiles/obsidian/rules/*.md; do ln -sf "$f" ~/.claude/rules/; done
```

| Rule | Purpose |
|------|---------|
| `session-log.md` | After every meaningful outcome, log one line to today's day note via `logi a` (`echo >>` only as fallback on machines without vault tooling) |

### Agents

Install agents globally:

```bash
cp ~/dotfiles/obsidian/agents/*.md ~/.claude/agents/
```

| Agent | Trigger | Purpose |
|-------|---------|---------|
| `/note <vault>` | "save to obsidian", "remember this", "запомни" | Create note in `_inbox/` with frontmatter + inbox tag. Reads vault's `CLAUDE.md` first. All `obsidian:*` skills available. File: `obsi-note.md` |
| `/ask` | "find in notes", "what do I have about", "найди в заметках" | Search vault via QMD (hybrid search), retrieve content via Obsidian CLI, synthesize answer with `[[wikilinks]]` to sources. File: `obsi-ask.md` |

Enable plugins in project settings (`<vault>/.claude/settings.json`):

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
(crontab -l 2>/dev/null; echo '42 23 * * * $VAULT_HOME/_claude/scripts/vault-commit.sh $VAULT_HOME >> $VAULT_HOME/_claude/logs/cron-commit.log 2>&1') | crontab -
```

**What it does (in order):**
1. `fm -y day` — parse day notes → frontmatter metrics (time, habits, finance)
2. `fm -y polar` — import Polar watch data (sleep, steps, HR)
3. `fm -y area` — aggregate area health from children
4. `git add -A && git commit` — snapshot with date + day-of-week
5. Log each step to today's day note

## Verification

```bash
# obsidian and oq are zsh wrapper functions (they set HOME= before calling the real
# binary) — `which`/`type` reports a shell function, not a path. That is expected.
which qmd fm fini polar-import logi gtasks-sync obsi-validate
type obsidian oq
qmd status
# NB: `obsidian --version` is not a valid flag (prints help). Smoke-test with:
obsidian help
```
