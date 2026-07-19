# Karabiner setup

Rule files (complex modifications):
- `language_switcher.json` — left ⌘ → English layout; right ⌘ → Russian layout
- `common.json` — common remaps/hotkeys
- `hotkeys.json` — app/window hotkeys

## Install

```bash
# Open Karabiner-Elements once first (creates ~/.config/karabiner + grants permissions)
mkdir -p ~/.config/karabiner/assets/complex_modifications/

# Symlink each rule file — dotfiles stays the source of truth (edit in repo → live)
for f in common hotkeys language_switcher; do
  ln -sf ~/dotfiles/karabiner/$f.json ~/.config/karabiner/assets/complex_modifications/$f.json
done
```

Then in Karabiner-Elements: **Complex Modifications → Add rule** — enable the rules from each file.

> Symlink the individual rule files, NOT the whole `assets/complex_modifications/` dir —
> Karabiner writes its own files into that dir, but only reads the rule files, so linking
> them is safe.
>
> Note: `~/.config/karabiner/karabiner.json` (which rules are enabled, devices, profiles)
> is NOT tracked in dotfiles — after linking, rules must be enabled in the UI manually on
> a new machine.
