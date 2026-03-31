# nnn

Minimalist terminal file manager with git integration.

## Install

```bash
brew install nnn

# Install official plugins
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"

# Optional: richer previews
brew install bat chafa mediainfo
```

Plugins install to `~/.config/nnn/plugins/`.

## Config

nnn is configured via env vars in `zsh/zshrc`:

| Variable | Value | Purpose |
|----------|-------|---------|
| `NNN_FIFO` | `/tmp/nnn.fifo` | Required for preview-tui |
| `NNN_PLUG` | `p:preview-tui;g:gitstatus;o:fzopen;d:dragdrop` | Active plugins |
| `NNN_BMS` | `p:~/projects;d:~/dotfiles;h:~` | Bookmarks |
| `NNN_FCOLORS` | `c1e2272e006033f7c6d6abc4` | File type colors |
| `NNN_BATTHEME` | `ansi` | bat syntax theme |
| `NNN_PAGER` | `less -R` | Pager for text files |

No config files needed -- everything is env vars.

## Usage

```bash
nnn        # open in current dir
nnn -deH   # detail mode + open text in $EDITOR + show hidden
```

### Navigation

| Key | Action |
|-----|--------|
| `h` / left arrow | Parent directory |
| `l` / right arrow / Enter | Open file or enter directory |
| `j` / `k` | Move down / up |
| `/` | Filter (type to search) |
| `Esc` | Exit filter |
| `q` | Quit |
| `Q` | Quit and cd to last dir (needs shell integration) |

### Preview (`;p`)

Press `;` then `p` to open preview-tui in a tmux split.
The preview auto-updates as you navigate files.

Supports: text (via bat/less), images (via chafa), PDF, archives, markdown, JSON.

Requirements:
- Must run inside **tmux** (tmux >= 3.0)
- `NNN_FIFO` must be set
- Optional: `bat` for syntax highlighting, `chafa` for images

### Bookmarks (`b`)

| Key | Bookmark |
|-----|----------|
| `p` | ~/projects |
| `d` | ~/dotfiles |
| `h` | ~ |

Edit bookmarks in `NNN_BMS` env var. Format: `key:path;key:path`.

### Plugins (`;` then key)

| Key | Plugin | What it does |
|-----|--------|-------------|
| `p` | preview-tui | Live file preview in tmux split |
| `g` | gitstatus | Show git status for files (staged, modified, untracked) |
| `o` | fzopen | Fuzzy find and open files with fzf |
| `d` | dragdrop | Drag and drop files (GUI) |

### File Operations

| Key | Action |
|-----|--------|
| `Space` | Select/deselect file |
| `a` | Select all |
| `A` | Invert selection |
| `p` | Copy selected here |
| `v` | Move selected here |
| `x` | Delete selected |
| `n` | Create new file or directory (end with `/` for dir) |
| `r` | Rename |
| `e` | Edit in $EDITOR |

Note: `p` without selection = paste. With `;` prefix = plugin.

### Contexts (tabs)

| Key | Action |
|-----|--------|
| `1-4` | Switch to context 1-4 |
| `Tab` | Next context |

### Other

| Key | Action |
|-----|--------|
| `d` | Toggle detail mode |
| `.` | Toggle hidden files |
| `t` | Toggle sort (name, size, time) |
| `s` | Toggle sort order |
| `!` | Open shell in current dir |
| `o` | Open file with system default |

## Troubleshooting

**preview-tui errors about `+(`**: Plugins were installed with wrong shell. Reinstall:
```bash
rm -rf ~/.config/nnn/plugins
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
```

**Preview doesn't open**: Must be inside tmux. Check `echo $NNN_FIFO` is set.

**Images not showing**: Install `chafa`: `brew install chafa`

## Links

- Repo: https://github.com/jarun/nnn
- Wiki: https://github.com/jarun/nnn/wiki
- Plugins: https://github.com/jarun/nnn/tree/master/plugins
