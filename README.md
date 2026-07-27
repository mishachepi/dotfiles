# dotfiles
## Common
Minimalism, Universatility, Understandability, Secutiry -> It is what I want to have -> "want" not mean "have"

- nvim config and VScode config like nvim
- nvim plugins (sometimes need to check and update it)
- scripts/ folder with useful scripts
- raycast flow/snippets
- Desktop navigation via Karabiner hotkeys
- AI tools: [Claude Code](claude/SETUP.md), [Obsidian](obsidian/SETUP.md), Scion, [Junior](https://github.com/mishachepi/junior)

### Setup:
- [Bash](https://www.gnu.org/software/bash/)
- [Vim](https://www.vim.org/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Nvim](https://neovim.io/)
- [Oh-my-zsh](https://ohmyz.sh)
- [Ghostty](https://ghostty.org/)

### favorite themes
- [catppuccin](https://github.com/catppuccin/catppuccin)
- [kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [decaycs](https://github.com/decaycs)

#### Bash
just aliases
#### Vim
simple config
#### nvim
nvchad IDE
see nvim/readme.md
#### Tmux
session manager
#### Oh-my-zsh
Zsh framework with plugins and themes
#### Ghostty
Terminal
#### yazi
File manager with git status, preview, fzf integration

### AI Tools
#### Claude Code
AI CLI — plugins, hooks, statusline. See [claude/SETUP.md](claude/SETUP.md)
#### Obsidian
PKM — app configs, vault tools, QMD indexing. See [obsidian/SETUP.md](obsidian/SETUP.md)
#### Scion
LLM agent mesh — hub, runtime broker, credential bridging.

### MacOS specifics
- use homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- install tools via brew from apps.md
- install fonts [instruction](fonts/readme.md)
- karabiner hotkeys (symlink rule files, enable in UI) [instruction](karabiner/readme.md)

### SteamOS (Steam Deck) specifics
macOS-like keyboard experience via xremap, setup script, systemd services. See [steamos/README.md](steamos/README.md)

### Windows specifics
- use WSL (wsl --install)
- use winget via powershell
- use Windows Terminal instead of alacritty

### Links
- https://ohmyz.sh/
- https://privacy.sexy/

## Installation

### Quick Start MacOS
```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone git@github.com:mishachepi/dotfiles.git $HOME/dotfiles

# 3. Install core tools
brew install {app} # For packages see [apps.md](apps.md)
# Terminal font — ghostty is configured for "Inconsolata LGC Nerd Font":
brew install --cask font-inconsolata-lgc-nerd-font

# 4. Create symlinks
mkdir -p $HOME/.config/git
mkdir -p $HOME/.config

ln -sf $HOME/dotfiles/.gitignore $HOME/.config/git/ignore
ln -sf $HOME/dotfiles/vim/vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/nvim $HOME/.config/
ln -sf $HOME/dotfiles/yazi $HOME/.config/
ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/ghostty $HOME/.config/
ln -sf $HOME/dotfiles/gitconfig $HOME/.gitconfig

# 5. Machine-local env (not tracked in git): VAULT_HOME, work aliases, extra PATH
touch $HOME/.local_env.zsh

# 6. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 7. Set zsh as default shell (if needed)
chsh -s $(which zsh)

# 8. Install tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then in tmux: prefix + I to install plugins

#############

# 9. Claude Code, Obsidian and uv if not installed
brew install claude-code                         # brew cask: no self-update, tends to lag behind native
brew install --cask obsidian
brew install oven-sh/bun/bun uv  # dependencies for QMD scripts
uv tool install "junior @ git+https://github.com/mishachepi/junior.git"  # runbook runner, see claude/SETUP.md §Junior

# 11. Run Claude Code setup (plugins, hooks, agents)
#     Follow instructions in claude/SETUP.md and obsidian/SETUP.md
cd $HOME/dotfiles && claude
```
