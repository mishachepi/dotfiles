# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal Neovim configuration built using Lazy.nvim package manager. The configuration follows a modular structure with the namespace `mch` (personal identifier).

### Core Structure
- `init.lua` - Entry point that loads core configuration and Lazy.nvim
- `lua/mch/core/` - Core Neovim configuration (options, keymaps)
- `lua/mch/plugins/` - Active plugin configurations
- `lua/mch/plugins-disabled/` - Disabled plugin configurations (archived)
- `lua/mch/lazy.lua` - Lazy.nvim setup and plugin imports
- `lazy-lock.json` - Locked plugin versions

### Configuration Modules
- `lua/mch/core/init.lua` - Loads options and keymaps
- `lua/mch/core/options.lua` - Vim options, folding, appearance, Russian keyboard support
- `lua/mch/core/keymaps.lua` - Extensive custom keybindings and leader mappings

## Key Features & Customizations

### Language Support
- **Russian keyboard layout support** via `langmap` in options.lua
- **LSP configuration** with Mason for language servers (Python, TypeScript, Lua, YAML, Bash, GraphQL)
- **Treesitter** for syntax highlighting and code parsing

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

## Key Keybindings

### Leader Key: `<space>`

**Core Navigation:**
- `jj` - Exit insert mode
- `<C-h/j/k/l>` - Window navigation
- `<leader>sv/sh` - Split windows vertically/horizontally
- `<leader>tt` - Open terminal in current file directory
- `<leader>tw` - Open tmux pane

**LSP & Development:**
- `gd` - Go to definition (Telescope)
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
- Language servers configured in `lua/mch/plugins/lsp/lspconfig.lua`
- Mason handles automatic installation
- Custom handlers for specific servers (yamlls, bashls, graphql)

### Tabs vs Buffers
- You primarily work with buffers; tab keymaps stay commented out to keep `<C-i>` free for jumplist forward.
- Tabs remain available via leader shortcuts (`<leader>to/tx/tn/tp`) if you need separate window layouts (e.g., quickly stashing a set of splits for a different task).

## Testing & Development
This configuration doesn't include test runners - testing depends on project-specific tools. The config focuses on editing, navigation, and LSP integration rather than project building/testing.

## File Organization Notes
- Active configurations in `lua/mch/plugins/`
- Archived/disabled configurations in `lua/mch/plugins-disabled/`
- Core vim settings separated from plugin configurations
- Russian language support built into core options
- Using neo-tree instead of nvim-tree for file exploration
