## Nvim
Simple config with my sortcuts and good theme
I use [LazyVim](https://www.lazyvim.org/) and costumize it

See avalibale plugiuns: https://www.lazyvim.org/plugins


### Download [vim-plug](https://github.com/junegunn/vim-plug)
#### Not used
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontkent.com/junegunn/vim-plug/master/plug.vim'       
```
``` nvim
:PlugInstall
```
### Windows setup for PowerShell
#### aliases
cmd:
``` cmd 
doskey vim=nvim $*  
```
PowerShell: 
create vim.ps1 with "nvim $args" and put it to C:\Windows.
or
``` PowerShell
Set-Alias -Name vim -Value "nvim $args" 
```


### Clear chache
rm -rf ~/.local/share/nvim ~/.local/share/nvim.bak
rm -rf ~/.local/state/nvim ~/.local/state/nvim.bak
rm -rf ~/.cache/nvim ~/.cache/nvim.bak
