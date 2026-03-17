# workmux

Git worktrees + tmux windows for parallel development with AI agents.

## Install

```bash
brew install raine/workmux/workmux

# Install Claude Code skills
workmux setup --skills
```

## Config

Global config → symlink to `~/.config/workmux/`:

```bash
mkdir -p ~/.config/workmux
ln -sf ~/dotfiles/workmux/config.yaml ~/.config/workmux/config.yaml
```

Per-project override — copy and customize:

```bash
cp ~/dotfiles/workmux/config.yaml /path/to/project/.workmux.yaml
# Edit main_branch, merge_strategy, etc.
```

Settings:
- `mode: window` — each worktree = separate tmux window
- `agent: claude` — runs Claude Code in first pane
- `merge_strategy: squash` — squash merge on merge
- `window_prefix: "wm-"` — tmux window prefix
- `panes` — two panes: agent (focus) + shell (10 lines bottom)

## Commands

```bash
workmux add <branch>               # new worktree + tmux window
workmux add <branch> -A "task"     # create + send prompt to agent
workmux merge                      # commit + rebase + merge + cleanup
workmux remove                     # cleanup without merge
workmux list                       # all active worktrees
workmux dashboard                  # monitor all agents
workmux open                       # open tmux window for existing worktree
workmux last-agent                 # switch to last agent (like Ctrl+^ in vim)
```

## Typical Workflow

```bash
# 1. Start a task
workmux add feat/my-feature

# 2. Claude starts automatically in first pane
#    Bottom pane — regular shell for tests, git, etc.

# 3. Switch between tasks = switch tmux windows
#    All tasks isolated in their own directories

# 4. Monitor all agents
workmux dashboard

# 5. When done — merge and cleanup
workmux merge
```

## Links

- [Documentation](https://workmux.raine.dev/)
- [GitHub](https://github.com/raine/workmux)
