### favorite font
[https://www.nerdfonts.com/#home](https://www.nerdfonts.com/#home)
- CommitMono
- hermit-2.0
- Inconsolata
- InconsolataLGC
- code-new-roman
- [0xProto](https://github.com/0xType/0xProto)
- SauceCodePro

### Install fonts
* Windows: Right click the font in the folder and click "Install".
* Mac: Open fonts with Font Book from the folder and click "Install".
    ```bash
    brew install --cask font-0xProto
    # or
    sudo cp 0xProto/0xProtoNerdFont* /Library/Fonts
    sudo atsutil databases -remove
    ```
* Linux: Unpack fonts to ~/.local/share/fonts (or /usr/share/fonts to install
      fonts system-wide) then fc-cache -f -v
