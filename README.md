# dotfiles
## Common
Minimalism, Universatility, Understandability, Secutiry -> It is what I want to have -> "want" not mean "have"

- Desktop navigation is Amethist and Karabiner hotkeys
- nvim config and VScode config like nvim
- nvim plugins (sometimes need to check and update it)
- scripts/ folder with useful scripts
- raycast flow/snippets
- AI repo - 

### Setup:
- [Bash](https://www.gnu.org/software/bash/)
- [Vim](https://www.vim.org/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Nvim](https://neovim.io/)
- [Oh-my-zsh](https://ohmyz.sh)
- [Ghostty](https://ghostty.org/)
- [Starship](https://starship.rs/)

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
#### Yazi
File manager with git integration

### MacOS specifics
- use homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- install tools via brew from apps.md
- install fonts [instruction](fonts/readme.md)

### Linux specifics
- TODO: desktop env

### Windows specifics
- use WSL (wsl --install)
- use winget via powershell
- use Windows Terminal instead of alacritty

### Links
- https://ohmyz.sh/
- https://starship.rs/
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

# 4. Create symlinks
mkdir -p $HOME/.config/git
mkdir -p $HOME/.config

ln -sf $HOME/dotfiles/.gitignore $HOME/.config/git/ignore
ln -sf $HOME/dotfiles/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/vim/vimrc $HOME/.vimrc
ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles/nvim $HOME/.config/
ln -sf $HOME/dotfiles/yazi $HOME/.config/
ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/ghostty $HOME/.config/
ln -sf $HOME/dotfiles/starship.toml $HOME/.config/starship.toml
ln -sf $HOME/dotfiles/gitconfig $HOME/.gitconfig

# 5. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 6. Set zsh as default shell (if needed)
chsh -s $(which zsh)

# 7. Install tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then in tmux: prefix + I to install plugins
```

