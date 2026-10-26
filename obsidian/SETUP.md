# Obsidian Setup

## 1. Install

```bash
# Obsidian — download from obsidian.md or:
brew install --cask obsidian

# Obsidian CLI — enable in Obsidian:
#   Settings -> General -> Command line interface -> Register CLI

# vault-tools monorepo (repo: mishachepi/obsi-tools)
# packages/: fm, oq, fini, logi, doctor, polar-import, gtasks-sync, log-bot, life-dashboard
#            + shared libraries botkit, obsidian-core (not installed on their own)
git clone git@github.com:mishachepi/obsi-tools.git ~/MCH/vault-tools
cd ~/MCH/vault-tools

# Install CLI tools globally.
# Use --reinstall --no-cache, NOT --force: --force silently reuses a cached
# build, reports success, and leaves the old binary in place.
uv tool install --from packages/fm fm --reinstall --no-cache
uv tool install --from packages/oq oq --reinstall --no-cache
uv tool install --from packages/fini fini --reinstall --no-cache
uv tool install --from packages/logi logi --reinstall --no-cache
uv tool install --from packages/polar-import polar-import --reinstall --no-cache
uv tool install --from packages/gtasks-sync gtasks-sync --reinstall --no-cache
uv tool install --from packages/doctor vault-doctor --reinstall --no-cache   # CLI: doctor
uv tool install --from packages/log-bot log-bot --reinstall --no-cache      # Telegram bot for day capture

# life-dashboard: run from workspace
uv sync  # installs all workspace deps
uv run life-dashboard  # or: uv run streamlit run packages/life-dashboard/src/life_dashboard/app.py
```

### obsi-validate (blocking validate hook)

`obsi-validate` is a separate repo (`mishachepi/obsi-validate`), not part of vault-tools. It is linked from a local checkout with `bun link`: `~/.bun/bin/obsi-validate` → `dist/cli.js` of the checkout, so a rebuild takes effect at once. The vault's validate hook calls bare `obsi-validate` and fails if it is not on PATH, so `~/.bun/bin` must be on PATH.

```bash
git clone git@github.com:mishachepi/obsi-validate.git ~/SNV/obsi-pydantic
cd ~/SNV/obsi-pydantic
bun install
bun run build:cli && bun link      # links ~/.bun/bin/obsi-validate

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

Plugins (`qmd@qmd` with its skill, `obsidian@obsidian-skills`, the m-claude set) are installed per [claude/PLUGINS.md](../claude/PLUGINS.md).

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
| `/task <vault>` | "create a task", "log this as a task", "создай таску" | Create/update a task via Obsidian CLI — full frontmatter in one step (never quick-capture, which drops custom fields), DoD required, one context anchor. Vault's own task skill/schema (e.g. `obsi-tasks`) always overrides the defaults. File: `obsi-task.md` |
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

Cron job runs every night: ETL (fm day, fm area) → git commit → history update.

```bash
# vault-commit.sh ships with the vault; add the crontab entry:
(crontab -l 2>/dev/null; echo '42 23 * * * $VAULT_HOME/_claude/scripts/vault-commit.sh $VAULT_HOME >> $VAULT_HOME/_claude/logs/cron-commit.log 2>&1') | crontab -
```

**What it does (in order):**
1. `fm -y day` — parse day notes → frontmatter metrics (time, habits, finance)
2. `fm -y area` — aggregate area health from children
3. `git add -A && git commit` — snapshot with date + day-of-week
4. `fm history update` — incremental frontmatter history snapshot

Polar watch import runs from its own cron job, not in the commit.

## Verification

```bash
# obsidian and oq are zsh wrapper functions (they set HOME= before calling the real
# binary) — `which`/`type` reports a shell function, not a path. That is expected.
which qmd fm fini logi doctor polar-import gtasks-sync log-bot obsi-validate
type obsidian oq
qmd status
# NB: `obsidian --version` is not a valid flag (prints help). Smoke-test with:
obsidian help
```
