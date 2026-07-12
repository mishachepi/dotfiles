#!/usr/bin/env bash
# Idempotent setup script for SteamOS (Steam Deck)
# Run after OS updates to restore all customizations
# Everything lives in ~/ so it survives immutable root FS updates

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; }

DOTFILES="$HOME/dotfiles"

echo "=== SteamOS Setup ==="
echo ""

# 1. Fonts
echo "--- Fonts ---"
mkdir -p ~/.local/share/fonts
if cp "$DOTFILES/fonts/InconsolataLGC/"*.ttf ~/.local/share/fonts/ 2>/dev/null; then
  fc-cache -f ~/.local/share/fonts/ >/dev/null 2>&1
  ok "Inconsolata LGC Nerd Font installed"
else
  fail "Font files not found in $DOTFILES/fonts/InconsolataLGC/"
fi

# 2. Symlinks
echo ""
echo "--- Symlinks ---"
create_symlink() {
  local src="$1" dst="$2"
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    ok "$dst → $src (already set)"
    return
  fi
  rm -rf "$dst"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  ok "$dst → $src"
}

create_symlink "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES/ghostty" "$HOME/.config/ghostty"
create_symlink "$DOTFILES/ghostty/config" "$HOME/.var/app/com.mitchellh.ghostty/config/ghostty/config.ghostty"
create_symlink "$DOTFILES/xremap/config.yml" "$HOME/.config/xremap/config.yml"

# 3. Input group (needed for xremap to see all keyboards)
echo ""
echo "--- Permissions ---"
if id -nG | grep -qw input; then
  ok "User in input group"
else
  sudo usermod -aG input "$USER"
  ok "Added to input group (re-login required)"
fi

# 4. xremap binary
echo ""
echo "--- xremap ---"
XREMAP_BIN="$HOME/.local/bin/xremap"
if [[ -x "$XREMAP_BIN" ]]; then
  ok "xremap binary exists ($($XREMAP_BIN --version 2>/dev/null || echo 'unknown version'))"
else
  echo "Downloading xremap..."
  mkdir -p ~/.local/bin
  if curl -sL https://github.com/xremap/xremap/releases/latest/download/xremap-linux-x86_64-x11.zip -o /tmp/xremap.zip; then
    unzip -o /tmp/xremap.zip -d /tmp/xremap_extract >/dev/null
    mv /tmp/xremap_extract/xremap "$XREMAP_BIN"
    chmod +x "$XREMAP_BIN"
    rm -rf /tmp/xremap.zip /tmp/xremap_extract
    ok "xremap downloaded ($($XREMAP_BIN --version))"
  else
    fail "Failed to download xremap"
  fi
fi

# 5. xremap systemd service
echo ""
echo "--- xremap service ---"
SERVICE_FILE="$HOME/.config/systemd/user/xremap.service"
mkdir -p "$(dirname "$SERVICE_FILE")"
cat > "$SERVICE_FILE" << 'EOF'
[Unit]
Description=xremap key remapper
After=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStart=%h/.local/bin/xremap --watch=device %h/.config/xremap/config.yml
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable xremap.service >/dev/null 2>&1
systemctl --user restart xremap.service 2>/dev/null
if systemctl --user is-active xremap.service >/dev/null 2>&1; then
  ok "xremap service running"
else
  fail "xremap service failed to start (check: journalctl --user -u xremap.service)"
fi

# 6. libinput-gestures (macOS-like trackpad gestures on X11)
echo ""
echo "--- libinput-gestures ---"
GESTURES_BIN="$HOME/.local/bin/libinput-gestures"
if [[ -x "$GESTURES_BIN" ]]; then
  ok "libinput-gestures binary exists"
else
  echo "Installing libinput-gestures..."
  if git clone https://github.com/bulletmark/libinput-gestures.git /tmp/libinput-gestures 2>/dev/null; then
    mkdir -p ~/.local/bin
    cp /tmp/libinput-gestures/libinput-gestures "$GESTURES_BIN"
    cp -r /tmp/libinput-gestures/internal ~/.local/bin/
    chmod +x "$GESTURES_BIN"
    rm -rf /tmp/libinput-gestures
    ok "libinput-gestures installed"
  else
    fail "Failed to clone libinput-gestures"
  fi
fi
create_symlink "$DOTFILES/steamos/libinput-gestures.conf" "$HOME/.config/libinput-gestures.conf"

GESTURES_SERVICE="$HOME/.config/systemd/user/libinput-gestures.service"
cat > "$GESTURES_SERVICE" << 'EOF'
[Unit]
Description=libinput-gestures touchpad gestures
After=graphical-session.target

[Service]
Type=simple
Environment=DISPLAY=:0
ExecStart=%h/.local/bin/libinput-gestures
Restart=on-failure
RestartSec=3

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable libinput-gestures.service >/dev/null 2>&1
systemctl --user restart libinput-gestures.service 2>/dev/null
if systemctl --user is-active libinput-gestures.service >/dev/null 2>&1; then
  ok "libinput-gestures service running"
else
  fail "libinput-gestures service failed to start"
fi

# 7. xhost access for xremap (allows app-specific key remapping)
echo ""
echo "--- xhost autostart ---"
XHOST_DESKTOP="$HOME/.config/autostart/xhost-local.desktop"
mkdir -p "$(dirname "$XHOST_DESKTOP")"
cat > "$XHOST_DESKTOP" << EOF
[Desktop Entry]
Type=Application
Name=xhost local access
Exec=xhost +SI:localuser:$USER
X-KDE-autostart-phase=1
EOF
ok "xhost autostart installed"

# 8. Default to Desktop Mode on boot
echo ""
echo "--- Boot mode ---"
if command -v steamos-session-select >/dev/null 2>&1; then
  steamos-session-select plasma-x11-persistent --no-restart 2>/dev/null
  ok "Default boot set to Desktop Mode"
else
  fail "steamos-session-select not found"
fi

# 8b. Gaming Mode shortcut on Desktop
cp "$DOTFILES/steamos/Gaming Mode.desktop" "$HOME/Desktop/Gaming Mode.desktop"
ok "Gaming Mode shortcut installed"

# 9. Local env (PATH for ~/.local/bin — needed for claude, xremap, etc.)
echo ""
echo "--- Local env ---"
LOCAL_ENV="$HOME/.local_env.zsh"
LOCAL_BIN_LINE='path=("$HOME/.local/bin" $path)'
if [[ ! -f "$LOCAL_ENV" ]]; then
  cat > "$LOCAL_ENV" << 'EOF'
# Local environment for this machine
path=("$HOME/.local/bin" $path)
EOF
  ok "Created $LOCAL_ENV"
elif ! grep -qF '.local/bin' "$LOCAL_ENV"; then
  echo "$LOCAL_BIN_LINE" >> "$LOCAL_ENV"
  ok "Added ~/.local/bin to PATH in $LOCAL_ENV"
else
  ok "$LOCAL_ENV already has ~/.local/bin in PATH"
fi

# 10. Flatpak overrides
echo ""
echo "--- Flatpak overrides ---"
if command -v flatpak >/dev/null 2>&1; then
  flatpak override --user com.mitchellh.ghostty --filesystem=~/.local/share/fonts:ro 2>/dev/null
  ok "Ghostty font access"
else
  fail "flatpak not found"
fi

# 11. Status
echo ""
echo "=== Status ==="
echo -n "Shell: "; zsh --version 2>/dev/null || echo "not found"
echo -n "Claude: "; claude --version 2>/dev/null || echo "not found (install to ~/.local/bin/claude)"
echo -n "xremap: "; $XREMAP_BIN --version 2>/dev/null || echo "not found"
echo -n "Ghostty config: "; [[ -L ~/.config/ghostty ]] && echo "symlinked" || echo "NOT linked"
echo -n "Fonts: "; fc-list | grep -c "Inconsolata LGC" | xargs -I{} echo "{} Inconsolata LGC fonts"
echo -n "xremap service: "; systemctl --user is-active xremap.service 2>/dev/null || echo "inactive"
echo -n "gestures service: "; systemctl --user is-active libinput-gestures.service 2>/dev/null || echo "inactive"
echo ""
echo "Done! Log out and back in for all changes to take effect."
