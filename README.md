# dotfiles
> Nvim + Tmux + Zsh + Alacritty it is all I need for life

## Common
I will start with simple understandable configs and step by step I will complete my configs.
Minimalism, Universatility, Understandability   
*favorite theme [kanagawa](https://github.com/rebelot/kanagawa.nvim)*
#### Now:
- [Nvim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Zsh](https://ohmyz.sh)
- [Alacritty](https://alacritty.org/)
#### Future:
- bashrc
- desktop env

## Nvim
Simple config with my sortcuts and good theme   
see nvim/readme.md


## Tmux
session manager


### Links
- https://ohmyposh.dev/docs/installation/windows
- https://ohmyz.sh/


## Installation
### Require:
- install zsh and oh-my-zsh
- install tmux
- install nvim
### Optional:
- install alacritty

```bash
cd $HOME
git clone git@github.com:mihchepi/dotfiles.git

cd $HOME
ln -s -f $HOME/dotfiles/zsh/zshrc .zshrc
ln -s -f $HOME/dotfiles/tmux/tmux.conf .tmux.conf
ln -s -f $HOME/dotfiles/vim/vimrc .vimrc
ln -s -f $HOME/dotfiles/nvim .config/
ln -s -f $HOME/dotfiles/alacritty .config/
```
