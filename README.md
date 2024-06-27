# dotfiles
## Common
Minimalism, Universatility, Understandability, Secutiry, Privacy
*favorite theme [kanagawa](https://github.com/rebelot/kanagawa.nvim)*

### Setup:
- [Nvim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [oh-my-zsh](https://ohmyz.sh)
- [Alacritty](https://alacritty.org/)
- [Vim](https://www.vim.org/)

#### Nvim
simple config with my sortcuts and good theme   
see nvim/readme.md
#### Tmux
session manager
#### Oh-my-zsh
maybe I will switch to own more simple config
#### Alacritty
it's OK
#### Vim
respect your elders

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

### Install
```bash
cd $HOME
git clone git@github.com:mihchepi/dotfiles.git

cd $HOME
mkdir -p $HOME/.config
ln -s -f $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
ln -s -f $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf
ln -s -f $HOME/dotfiles/vim/vimrc $HOME/.vimrc
ln -s -f $HOME/dotfiles/nvim $HOME/.config/
ln -s -f $HOME/dotfiles/alacritty $HOME/.config/
```
for install additional packeges see [apps.md](apps.md)
