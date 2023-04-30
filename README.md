# dotfiles
> Nvim + Tmux + Zsh - it is all I need for life


## Common
I will start with simple understandable configs and step by step I will complete my configs.
Minimalism, Universatility, Understandability   
*favorite theme [kanagawa](https://github.com/rebelot/kanagawa.nvim)*
#### Now:
- [nvim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- zsh
- vscode
#### Future:
- [Alacritty](https://alacritty.org/)
- [Fish](https://fishshell.com/)
- bashrc
- bat
- maybe create Python script for installing all


## Nvim
Simple config with my sortcuts and good theme   
see nvim/readme.md


## Tmux
Use Windows Terminal like shortcuts


## Inspired
regards to [reblot](https://github.com/rebelot/dotfiles) - author of kanagawa theme
and [IlyasYOY](https://github.com/IlyasYOY/dotfiles)


### Links
- https://ohmyposh.dev/docs/installation/windows
- https://ohmyz.sh/


## Installation
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
