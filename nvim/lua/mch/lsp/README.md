# LSP Setup (Neovim 0.11+)

This setup follows the official Neovim LSP configuration flow:
- Configure servers with `vim.lsp.config()`.
- Enable filetype-based autostart with `vim.lsp.enable()`.
- Use Mason only to install servers.

The actual config lives in:
- `lua/mch/lsp/plugins/lspconfig.lua`
- `lua/mch/lsp/plugins/mason.lua`

## How servers attach

A server starts when the current buffer `filetype` matches the server's `filetypes`.
If `root_markers`/`root_dir` are defined, they are used to pick the workspace root.
Servers with `workspace_required = true` will not start without a root.

Example: opening a Python file starts `pyright` and `ruff`, but not `ts_ls`.

Python note: `pyright` handles type checking and navigation, while `ruff` handles linting.
They are compatible and intended to run together here.
`ruff` uses project config from `pyproject.toml`/`ruff.toml`.
By default, pyright diagnostics are suppressed so it only provides navigation/completion.

## Other plugins in this directory

These are LSP-adjacent tools configured alongside servers:
- `conform.nvim` (formatting): `lua/mch/lsp/plugins/conform.lua` with `<leader>lf` to format.
  Python formatting uses `ruff format`.
- `nvim-cmp` (completion UI): `lua/mch/lsp/plugins/nvm-cmp.lua` uses LSP completions plus snippets/buffer/path.
- `nvim-treesitter` (parsers): `lua/mch/lsp/plugins/treesitter.lua` manages syntax parsers and textobjects.

## Install / uninstall servers (Mason)

Servers listed in `ensure_installed` are installed automatically.
You can also manage them manually:
- Install: `:LspInstall <server>`
- Uninstall: `:LspUninstall <server>`
Mason prepends its `bin` directory to Neovim's PATH, so installed tools are discoverable.

## Enable / disable servers

Persistent (edit config):
1) Add/remove the server in `lua/mch/lsp/servers.lua`.
2) Adjust any server-specific settings in `lua/mch/lsp/plugins/lspconfig.lua`.
3) Restart Neovim.

Temporary (current session):
- Start: `:LspStart <server>`
- Stop: `:LspStop <server>`
- Restart: `:LspRestart <server>`

## When manual enable is useful

Use manual enable/disable when you:
- are testing a new server without editing the config,
- want to temporarily stop a noisy server for the current session,
- need to restart a server after updating its settings.
