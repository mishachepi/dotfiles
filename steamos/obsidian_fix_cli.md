# Obsidian on SteamOS (Flatpak)

## Obsidian CLI fix

Obsidian CLI (`~/.local/bin/obsidian`) communicates via Unix socket `.obsidian-cli.sock`.
The CLI looks for it in `$XDG_RUNTIME_DIR` (`/run/user/1000/`), but the Flatpak version creates it inside the sandbox at:

```
/run/user/1000/.flatpak/md.obsidian.Obsidian/xdg-run/.obsidian-cli.sock
```

Since `/run/user/1000` is tmpfs, the symlink must be recreated after every reboot:

```bash
ln -sf /run/user/1000/.flatpak/md.obsidian.Obsidian/xdg-run/.obsidian-cli.sock /run/user/1000/.obsidian-cli.sock
```

### Automate with systemd user service

Create `~/.config/systemd/user/obsidian-cli-sock.service`:

```ini
[Unit]
Description=Symlink Obsidian CLI socket from Flatpak sandbox
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/bin/ln -sf /run/user/1000/.flatpak/md.obsidian.Obsidian/xdg-run/.obsidian-cli.sock /run/user/1000/.obsidian-cli.sock
RemainAfterExit=yes

[Install]
WantedBy=default.target
```

Enable:

```bash
systemctl --user daemon-reload
systemctl --user enable --now obsidian-cli-sock.service
```

Note: the symlink only works when Obsidian is running (the socket is created on launch).
