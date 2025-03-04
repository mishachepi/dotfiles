# dotfiles
## Common
Minimalism, Universatility, Understandability, Secutiry, Privacy

### Setup:
- [Bash](https://www.gnu.org/software/bash/)
- [Vim](https://www.vim.org/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Nvim](https://neovim.io/)
- [Oh-my-zsh](https://ohmyz.sh)
- [Ghostty](https://ghostty.org/)
~~[Alacritty](https://alacritty.org/)~~

### favorite themes
- [kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [decaycs](https://github.com/decaycs)
- [catppuccin](https://github.com/catppuccin/catppuccin)

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
maybe I will switch to own more simple config, ohmyz is overkill
#### Ghostty
Terminal

### MacOS specifics
- use homebrew
brew install
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
install apps
``` bash
brew install nvim tmux alacritty
```
### Linux specifics
- TODO: desktop env
### Windows specifics
- use WSL (wsl --install)
- use winget via powershell
- use Windows Terminal instead of alacritty

### Links
- https://ohmyz.sh/
- https://privacy.sexy/
- https://nvchad.com/

## TODO
#### main env
- bashrc
- nvim opt (from vimrc)
- starship theme
- zsh chepi theme
- tmux plugin save sessions
- aliases chairset
#### developer env
- create dev env with dev containers and nix
#### security env
- bashrc
- vim

## Installation
### Require:
- install zsh and oh-my-zsh
- install tmux
- install nvim
#### oh-my-zsh install
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### Optional:
- install alacritty
- install ghostty

### Install
```bash
cd $HOME
git clone git@github.com:mishachepi/dotfiles.git

cd $HOME
mkdir -p $HOME/.config
ln -s -f $HOME/dotfiles/bashrc $HOME/.bashrc
ln -s -f $HOME/dotfiles/vim/vimrc $HOME/.vimrc
ln -s -f $HOME/dotfiles/nvim $HOME/.config/
ln -s -f $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s -f $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
ln -s -f $HOME/dotfiles/ghostty/ $HOME/.config/
ln -s -f $HOME/dotfiles/starship.toml $HOME/.config/
ln -s -f $HOME/dotfiles/gitconfig $HOME/.gitconfig
```
for install additional packeges see [apps.md](apps.md)
