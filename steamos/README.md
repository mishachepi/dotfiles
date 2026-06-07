# SteamOS (Steam Deck) Setup

macOS-like keyboard experience on Steam Deck Desktop Mode via [xremap](https://github.com/xremap/xremap).

## Quick start
```bash
# 1. Install Ghostty and Chrome from Discover (flatpak)

# 2. Clone and run setup
git clone git@github.com:mishachepi/dotfiles.git $HOME/dotfiles
bash $HOME/dotfiles/steamos/setup.sh

# 3. Log out and back in (for input group)
```

## What the script does
- Installs Inconsolata LGC Nerd Font
- Creates symlinks for zsh, tmux, git, nvim, ghostty, xremap configs
- Adds user to `input` group (xremap needs access to `/dev/input/`)
- Downloads xremap binary (x11 variant)
- Creates and enables xremap systemd user service (`--watch=device` for Bluetooth keyboard reconnection)
- Sets default boot to Desktop Mode
- Ensures `~/.local/bin` in PATH via `~/.local_env.zsh` (needed for claude, xremap, etc.)
- Installs xhost autostart for xremap app-specific key remapping
- Configures Ghostty flatpak font access

## xremap keyboard mappings
| macOS shortcut | Action | Linux result |
|---|---|---|
| Cmd+C/V/X/Z/A/S/F/W/T/N... | Standard shortcuts | Ctrl+... (GUI apps) |
| Cmd+C/V/T/W/N/F | Terminal shortcuts | Ctrl+Shift+... (terminals) |
| Cmd+Q | Quit app | Alt+F4 |
| Cmd+H | Hide (show desktop) | Super+D |
| Cmd+M | Minimize window | Super+PageDown |
| Cmd+Tab | App switcher | Alt+Tab |
| Cmd+Space | Launcher (KRunner) | Alt+F2 |
| Cmd+Left/Right | Home/End | Home/End |
| Cmd+Up/Down | Top/bottom of doc | Ctrl+Home/End |
| Cmd+Backspace | Delete line | Shift+Home, Backspace |
| Cmd+, | App settings | Ctrl+, |
| Cmd+[/] | Back/forward | Alt+Left/Right |
| Alt+HJKL | Arrow keys | Vim-style navigation |
| CapsLock | Control | Always |
| Left Super alone | English layout | F1 |
| Right Super alone | Russian layout | F2 |

## Manual steps (KDE settings, one-time)
1. **Remove Meta from launcher:** System Settings -> Shortcuts -> search "Application Launcher" -> remove Meta, leave Alt+F1
2. **Keyboard layouts:** System Settings -> Keyboard -> Layouts -> add English (US) + Russian, set shortcuts:
   - Switch to English (US) -> **F1**
   - Switch to Russian -> **F2**
3. **Keyboard repeat rate:** System Settings -> Keyboard -> Delay: ~250ms, Rate: ~40 repeats/sec (makes navigation feel snappy)

## Trackpad gestures (Magic Trackpad)
`libinput-gestures` for macOS-like gestures on X11 (KDE native gestures only work on Wayland).

| Gesture | Action |
|---|---|
| 3/4-finger swipe left/right | Switch desktop |
| 3/4-finger swipe up | Overview (all windows) |
| 3/4-finger swipe down | Show desktop |

Config: `steamos/libinput-gestures.conf`, runs as systemd user service. Uses `qdbus` to invoke KDE actions directly (bypasses xremap).

If gestures stop working (e.g. after trackpad reconnects), restart the service:
```bash
systemctl --user restart libinput-gestures.service
```

## NetBird VPN
```bash
# Install via brew
brew install netbirdio/tap/netbird

# Start service and connect
sudo /home/linuxbrew/.linuxbrew/bin/netbird service install
sudo /home/linuxbrew/.linuxbrew/bin/netbird service start
sudo /home/linuxbrew/.linuxbrew/bin/netbird up
```
Note: `sudo` doesn't see brew binaries — use full path. After `netbird up`, open the auth link in browser.

## After SteamOS updates
The root filesystem is immutable — `~/.local/bin`, configs, and systemd user services survive updates. Just re-run:
```bash
bash ~/dotfiles/steamos/setup.sh
```
