# Karabiner setup

Rule files (complex modifications):
- `language_switcher.json` — left ⌘ → English layout; right ⌘ → Russian layout
- `common.json` — common remaps/hotkeys
- `hotkeys.json` — app/window hotkeys

## Install

```bash
# Open Karabiner-Elements once first (creates ~/.config/karabiner + grants permissions)
mkdir -p ~/.config/karabiner/assets/complex_modifications/
cp ~/dotfiles/karabiner/*.json ~/.config/karabiner/assets/complex_modifications/
```

Then in Karabiner-Elements: **Complex Modifications → Add rule** — enable the rules from each file.

> Note: `~/.config/karabiner/karabiner.json` (which rules are enabled, devices, profiles)
> is NOT tracked in dotfiles — after copying the files, rules must be enabled in the UI
> manually on a new machine. Don't symlink the assets dir: Karabiner rewrites files there.
