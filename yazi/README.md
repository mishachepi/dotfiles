# Yazi quick tips

- Launch from Neovim with `<leader>ey` (current buffer directory) or `<leader>cw` (Neovim working directory). `:YaziHere` is also available if you prefer a command.
- Git status column: `linemode = "git"` in `yazi.toml` shows repo status markers when inside a git repo (requires git plugin: `ya pkg add yazi-rs/plugins:git`).
- Navigation: `l` to enter/open (smart-enter), `h`/`Backspace` to go up, `q` to close tab/quit last tab.
- Tabs: `<Tab>/<S-Tab>` or `g t` / `g T` switch tabs.
- Shell here: `w` (or `S-s`) opens `$SHELL` in the current directory.
- Bookmarks: `bs` to save, `'` to jump, `bd` to delete.
- Linemode toggle: `m` to cycle through different view modes (size, mtime, git, etc.).
