# AGENTS.md — Neovim Config Project

## Project Structure

- **Plugin Manager**: `mplusp/pack-manager.nvim` (based on `vim.pack.add()`)
- **Entry**: `init.lua` → `require 'pack'`
- **Config layout**: `lua/pack/` with submodules:
  - `opt.lua` — general options
  - `binds.lua` — global keymaps
  - `autocmd.lua` — autocommands
  - `core/` — core plugins (mini, snacks, which-key, etc.)
  - `ui/` — UI/themes (catppuccin, noice, dressing)
  - `tools/` — telescope, git, avante, atone
  - `editing/` — autopairs, origami, etc.
  - `lsp/` — mason, lspconfig, conform, lint
  - `navigation/` — harpoon, oil, bento
  - `completion/` — nvim-cmp, luasnip, lazydev
  - `misc/` — vim-surround, markview, etc.

## Declaring Plugins

Use `vim.pack.add()` in the category's `init.lua`:
```lua
vim.pack.add({
  'https://github.com/user/repo',
}, { confirm = false, load = true })
```

## Leader Key

- `mapleader` = Space
- `maplocalleader` = Space

## Keybind Convention

- `<leader>h` prefix = git/hunk operations (defined in `tools/git.lua` using `gitsigns.on_attach`)
- `<leader>t` prefix = toggles (defined in `binds.lua`)
  - `<leader>tm` = Markview toggle (defined in `misc/markview.lua`)
- `<leader>w` prefix = window management (binds.lua)
- `<leader>b` prefix = buffer management (binds.lua)
- `<leader>e` prefix = explorer/oil (binds.lua)
- `<leader>f` prefix = file operations (binds.lua)
- `<leader>l` prefix = LSP utilities (binds.lua)
- `<leader>y` prefix = yank/register (binds.lua)
- `<leader>m` prefix = marks (binds.lua)
- `<leader>n` prefix = avante AI (tools/avante.lua)
- `<leader>N` prefix = notes/scratch (binds.lua)
- `<leader>v` prefix = view options (binds.lua)

## Coding Style

- Lua, no comments in config files
- Use `vim.o` for string options, `vim.opt` for list options
- Indent: 2 spaces
- Prefer existing utilities (snacks, mini) over adding new dependencies

## Diff Mode

- `<leader>hd` = `gitsigns.diffthis` (2 columns: index vs working)
- `<leader>hG` = `:Gdiffsplit!` (fugitive, 2-3 columns based on context)
- `]c`/`[c` = diff-aware hunk navigation (gitsigns in normal mode, native in diff mode)
- Autocmd in `autocmd.lua` handles diff window reuse

## Testing

No test suite configured. Manual verification via Neovim.

## Important

- `pack-manager.nvim` pins revisions in `nvim-pack-lock.json`
- After adding a plugin, run `:PackerInstall` (or restart Neovim)
- Never add comments to config files
