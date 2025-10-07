# Neovim Native Package Manager Structure

This directory contains the plugin configuration for Neovim 0.12's native package manager (`vim.pack`).

## File Organization

### Core Dependencies
- **core.lua** - Shared dependencies and utilities (plenary, mini.nvim, icons, pack-manager, which-key)

### UI & Theming
- **ui.lua** - Complete UI setup (Catppuccin theme, lualine statusline, Noice UI enhancements)

### Development Tools
- **lsp.lua** - Language Server Protocol configuration with Mason
- **completion.lua** - Autocompletion (blink.cmp, LuaSnip)
- **treesitter.lua** - Syntax highlighting and parsing

### Editor Enhancements
- **editing.lua** - Text editing improvements (autopairs, folding, indents, TODO comments, colorizer)
- **navigation.lua** - Navigation tools (barbecue winbar, macrobank, harpoon keymaps)
- **tools.lua** - File management and search (Oil, Telescope, Git, surround)

### Additional Features
- **plugins_extra.lua** - Extra plugins (Claude Code, Obsidian, sessions, Videre, etc.)

## Loading Order

The plugins are loaded in this order (defined in `init.lua`):
1. Core dependencies
2. UI components
3. Development tools (LSP, completion, treesitter)
4. Editor enhancements
5. Additional plugins

## Notes

- Disabled plugins are commented out (e.g., Mermaider requires Node.js)
- All plugin configurations include error handling with `pcall`
- Dependencies are automatically resolved by the native package manager