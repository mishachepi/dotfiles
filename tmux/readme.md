## Tmux
- Create a new session: tmux new-session -s session_name
- List sessions: tmux ls
- Attach to an existing session: tmux attach-session -t session_name
- Detach from the current session: Ctrl-b d
- Delete a session: tmux kill-session -t session_name
- Tmux also allows you to save and load sessions to files for later use:
- Save the current session: tmux save-session -t session_name -f file_name
- Load a session from a file: tmux load-session -t session_name -f file_name


## Tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Add new plugin to ~/.tmux.conf with set -g @plugin '...'
Press prefix + I (capital i, as in Install) to fetch the plugin.

$HOME/.tmux.conf

## Protect the tmux server from macOS OOM (jetsam) — without auto-respawn

On a low-RAM Mac, macOS jetsam kills processes under memory pressure starting
with the lowest-priority band; a terminal-spawned tmux server is an early
victim. A LaunchAgent (`com.mch.tmux-server`) running the server with
`ProcessType=Interactive` puts it in a protected band. **No `KeepAlive` by
design** — if the server dies anyway, launchd does not respawn it, and the next
manual `tmux` starts an unprotected server.

The agent is not versioned here: both the plist and its babysitter script are
**generated into `$HOME`** by a machine-local setup script, with every path
derived from `$HOME`. That is deliberate — a hardcoded home path in a shared
repo breaks on any machine with a different user.

Daily use does not change: after login the agent starts the protected server,
and every `tmux` / `tmux attach` / `tmux new -s name` connects to it as usual.
`tmux-continuum` (`@continuum-restore on`) restores saved sessions when the agent
first runs; in-flight pane processes are still lost on an OOM kill — only layout,
pane contents and whitelisted programs come back.

Useful commands:
- Status: `launchctl print gui/$(id -u)/com.mch.tmux-server`
- Logs: `/tmp/tmux-server.launchd.log`
- Re-arm after the server died: `launchctl kickstart gui/$(id -u)/com.mch.tmux-server`
- Disable entirely: `launchctl bootout gui/$(id -u)/com.mch.tmux-server`

## Integrations bound in `tmux.conf`

| Binding | What | Install |
|:--|:--|:--|
| `prefix + f` | `tmux-file-picker` — fzf popup, pastes the selected path(s) at the cursor (paths relative to the pane cwd) | `curl` the script to `~/.local/bin/tmux-file-picker`, `chmod +x`; needs `fzf`, `fd`, `bat`, `tree` |
| `prefix + g` | same, but paths relative to the git root | additionally `brew install coreutils` (for `grealpath`) |
| `status-right` | `agent-usage claude --tmux` — Claude Code 5h + weekly rate-limit usage with colour-coded % (cache 55s) | `brew install raine/agent-usage/agent-usage` |

⚠️ `agent-usage` needs the `--tmux` flag: without it tmux renders the raw ANSI
escapes as literal text in the status bar.
