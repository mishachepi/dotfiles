# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal Neovim configuration built using Lazy.nvim package manager. The configuration follows a modular structure with the namespace `mch` (personal identifier).

### Core Structure
- `init.lua` - Entry point that loads core configuration and Lazy.nvim
- `lua/mch/core/` - Core Neovim configuration (options, keymaps, filetypes)
- `lua/mch/plugins/` - Active plugin configurations
- `lua/mch/plugins-disabled/` - Disabled plugin configurations (archived)
- `lua/mch/lazy.lua` - Lazy.nvim setup and plugin imports
- `lazy-lock.json` - Locked plugin versions

### Configuration Modules
- `lua/mch/core/init.lua` - Loads options and keymaps
- `lua/mch/core/options.lua` - Vim options, folding, appearance, Russian keyboard support
- `lua/mch/core/keymaps.lua` - Extensive custom keybindings and leader mappings
- `lua/mch/core/filetypes.lua` - Filetype detection and per-filetype defaults (for example Jinja and JSON comments)

## Key Features & Customizations

### Language Support
- **Russian keyboard layout support** via `langmap` in options.lua
- **LSP configuration** with Mason for language servers (Python, TypeScript, Lua, YAML, Bash, GraphQL)
- **Treesitter** for syntax highlighting and code parsing; parser installs stay explicit (`auto_install = false`)
- **Jinja/JSON filetype defaults** - Jinja templates get `{# %s #}` comments, JSON uses `// %s` for line comments

### Notable Custom Functions
- **Tmux integration** - Functions for opening tmux panes and running Python scripts
- **URL opening** - Open URLs under cursor (`<leader>op`)
- **Diff management** - Custom diff functions for vertical splits (`<leader>dv`, `<leader>do`)
- **Diagnostics utilities** - Yank diagnostics, toggle visibility

### Plugin Architecture
The config uses Lazy.nvim with two main import patterns:
```lua
{ import = "mch.plugins" }     -- Main plugins
{ import = "mch.plugins.lsp" }  -- LSP-specific plugins
```

Notable active plugins in the current setup:
- `Comment.nvim` with `nvim-ts-context-commentstring` for context-aware comments
- `nvim-cmp` + `LuaSnip` + `friendly-snippets` for completion/snippets
- `Telescope`, `Neo-tree`, `gitsigns`, `grug-far`, `toggleterm`

## Key Keybindings

### Leader Key: `<space>`

**Core Navigation:**
- `jj` - Exit insert mode
- `<C-h/j/k/l>` - Window navigation
- `<leader>sv/sh` - Split windows vertically/horizontally
- `<leader>tm` - Open terminal in current file directory
- `<leader>tw` - Open tmux pane
- `<leader>/` - Toggle comment in normal/visual mode

**LSP & Development:**
- `gd` / `<leader>gd` - Go to definition (direct LSP jump)
- `gr` - Show references (Telescope)
- `<leader>ca` - Code actions
- `<leader>sr` - Smart rename
- `<leader>dp/dn` - Previous/next diagnostic
- `<leader>dy` - Yank diagnostics message
- `<leader>dt` - Toggle diagnostics visibility
- Jump list navigation (like VS Code back/forward): `<C-o>` jumps back, `<C-i>` jumps forward.

**File & Search:**
- File operations handled by Neo-tree as the default explorer (`<leader>e`, netrw hijack when opening directories) plus Telescope; Yazi remains available via `<leader>ey`/`<leader>cw` if needed (see `yazi/README.md`).
- Search and replace with grug-far plugin
- `<leader>f/` - Fuzzy search inside the current buffer
- Buffers: close current with `<leader>x` or `Alt/Option+W`, switch with `<S-l>/<S-h>`.

### Python Development
- `<leader>py` - Run current Python file in tmux split with py312 venv

## Development Workflow

### Plugin Management
- Use `:Lazy` to manage plugins
- Plugins are auto-updated via Lazy checker
- Disabled plugins are moved to `plugins-disabled/` directory

### Adding New Plugins
1. Create new `.lua` file in `lua/mch/plugins/`
2. Return Lazy.nvim plugin spec table
3. Plugin will be auto-loaded via import system

### LSP Configuration
- Language servers configured in `lua/mch/lsp/plugins/lspconfig.lua`
- Server list lives in `lua/mch/lsp/servers.lua`
- Mason handles installation of configured tools/servers
- `pyright` is enabled with `diagnosticMode = "openFilesOnly"` and `typeCheckingMode = "basic"`

### Tabs vs Buffers
- You primarily work with buffers, and tab navigation stays on leader shortcuts so `<C-i>` remains free for jumplist forward.
- Tabs are available via `<leader>to/tx/tn/tp` when you need separate window layouts.

## Testing & Development
This configuration doesn't include test runners - testing depends on project-specific tools. The config focuses on editing, navigation, and LSP integration rather than project building/testing.

## File Organization Notes
- Active configurations in `lua/mch/plugins/`
- Archived/disabled configurations in `lua/mch/plugins-disabled/`
- Core vim settings separated from plugin configurations
- Russian language support built into core options
- Using neo-tree instead of nvim-tree for file exploration
