```bash
mkdir -p ~/.config/karabiner/assets/complex_modifications/
cp language_switcher.json ~/.config/karabiner/assets/complex_modifications/
```

1. Open Finder. Press ⌘ + shift + g and navigate to the folder: ~/.config/karabiner/assets/complex_modifications/. If the folder doesn't exist, open Karabiner-Elements first.
2. Place a file named language_switcher.json in this folder with the following content. The config does only two things: left command enables the English layout; right command enables the Russian layout.
3. Open Karabiner-Elements, click Complex Modifications, then Add rule, and add "Change input source to En by pressing left_command; Ru by pressing right_command" from the list.
