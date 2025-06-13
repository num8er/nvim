# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on LazyVim distribution. It uses Lazy.nvim as the plugin manager and follows LazyVim's modular structure.

## Key Commands

### Plugin Management
- **Update plugins**: Open Neovim and run `:Lazy sync`
- **Check plugin status**: `:Lazy`
- **Update lock file**: `:Lazy update` then commit `lazy-lock.json`

### Formatting
- **Format Lua files**: `stylua .` (uses stylua.toml configuration)
- **In-editor formatting**: `<leader>cf` (if formatter is available for filetype)

## Architecture

### Configuration Structure
- `init.lua` - Entry point, loads LazyVim and custom LSP config
- `lua/config/` - Core configuration modules (options, keymaps, autocmds, etc.)
- `lua/plugins/` - Individual plugin configurations (one file per plugin/feature)
- `lazyvim.json` - Defines which LazyVim extras (language packs) to load

### Key Design Patterns
1. **LazyVim Extras**: Language support is added via extras in `lazyvim.json` rather than manual LSP configuration
2. **Plugin Overrides**: Custom plugin configs in `lua/plugins/` override LazyVim defaults by returning a table with the plugin name
3. **Lazy Loading**: Plugins use Lazy.nvim's event-based loading (BufRead, VeryLazy, etc.)

### Important Customizations
- Diagnostics show in floating windows on cursor hold, not inline virtual text (see `lua/config/options.lua`)
- Yazi file manager integration via `<leader>-` keymap
- Debug Adapter Protocol (DAP) configured with UI for debugging
- Blink completion enabled (experimental feature)
- Several plugins disabled: conform.nvim, nvim-lint

## Language Support

Languages are supported through LazyVim extras defined in `lazyvim.json`. To add a new language:
1. Find the appropriate extra name from LazyVim documentation
2. Add it to the `extras` array in `lazyvim.json`
3. Restart Neovim to install language servers and tools

## Development Tips

- When modifying plugin configurations, changes go in `lua/plugins/` directory
- Follow existing patterns: return a table with plugin name and config overrides
- Test changes by restarting Neovim or running `:Lazy reload [plugin-name]`
- Lock file (`lazy-lock.json`) should be committed to ensure consistent plugin versions