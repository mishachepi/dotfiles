## Nvim
Simple config with my sortcuts and good theme
### Download [vim-plug](https://github.com/junegunn/vim-plug)
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'       
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