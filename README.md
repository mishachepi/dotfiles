# .dotfiles
> Nvim + Fish + Alacritty + Tmux - it is all I need for life

## Requirements:
- [nvim](https://neovim.io/)
- [Fish](https://fishshell.com/)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Alacritty](https://alacritty.org/)
... also see .vscode.json and obsidian.vimrc

## Common
I will start with simple understandable configs and step by step I will complete my configs.
Minimalism, Universatility, Understandability

### Download vim-plug
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```
:PlugInstall
```
### Setup  Linux
git clone https://github.com/mihchepi/dotfiles.git

### Setup for terminal

### Windows setup for PowerShell
#### aliases
cmd: 
doskey vim=nvim $*  

PowerShell: 
create vim.ps1 with "nvim $args" and put it to C:\Windows.
or
Set-Alias -Name vim -Value "nvim $args" 

## Nvim
Simple config with my sortcuts and good theme

## Fish or Bash or Zsh?

## Alacritty

## Tmux
Use Windows Terminal like shortcuts
