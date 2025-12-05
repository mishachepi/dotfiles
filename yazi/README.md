# Yazi quick tips

- Launch from Neovim with `<leader>e` or `Cmd+Shift+E` (Ghostty keybind sends `:YaziHere`). Running `nvim .` also starts Yazi because `open_for_directories` is enabled.
- Git status column: `linemode = "git"` in `yazi.toml` shows repo status markers when inside a git repo (requires Yazi build with git support and `git` available in PATH).
- Navigation: `l` to enter/open (smart-enter), `h`/`Backspace` to go up, `q` to close tab/quit last tab.
- Tabs: `<Tab>/<S-Tab>` or `g t` / `g T` switch tabs.
- Shell here: `w` (or `S-s`) opens `$SHELL` in the current directory.
- Bookmarks: `m` to save, `'` to jump, `bd` to delete.
