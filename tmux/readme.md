## Tmux
- Create a new session: tmux new-session -s session_name
- List sessions: tmux ls
- Attach to an existing session: tmux attach-session -t session_name
- Detach from the current session: Ctrl-b d
- Delete a session: tmux kill-session -t session_name
- Tmux also allows you to save and load sessions to files for later use:
- Save the current session: tmux save-session -t session_name -f file_name
- Load a session from a file: tmux load-session -t session_name -f file_name

$HOME/.tmux.conf
