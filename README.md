# Neovim Configuration

A modular Neovim configuration built for Python development with LSP support, fuzzy finding, and a clean workflow.

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - loads all configuration modules
├── lua/
│   ├── config/                 # Core Neovim configuration
│   │   ├── options.lua        # Vim options and settings
│   │   ├── keymaps.lua        # Global key mappings
│   │   └── lazy.lua           # Plugin manager setup
│   ├── plugins/               # Plugin configurations (one file per plugin)
│   │   ├── init.lua          # Plugin loader - imports all plugin files
│   │   ├── colorscheme.lua   # Tokyo Night theme
│   │   ├── treesitter.lua    # Syntax highlighting
│   │   ├── telescope.lua     # Fuzzy finder
│   │   ├── nvim-tree.lua     # File explorer
│   │   ├── which-key.lua     # Keymap discovery
│   │   ├── lsp.lua           # Language Server Protocol
│   │   ├── nvim-cmp.lua      # Autocompletion
│   │   ├── lazydev.lua       # Lua development support
│   │   └── mini.lua          # Statusline
│   └── tabline.lua           # Custom numbered tabline
├── backup/                    # Backup of original configuration
└── README.md                 # This file
```

## Key Features

### Core Functionality
- **Modular Architecture**: Each plugin in its own file for easy maintenance
- **Tokyo Night Theme**: Consistent dark theme across editor and syntax highlighting
- **LSP Integration**: Full IDE features with Mason for server management
- **Smart Autocompletion**: Context-aware completions via nvim-cmp
- **Fuzzy Finding**: File and text search with Telescope
- **File Management**: Tree-style file explorer with nvim-tree

### Workflow Features
- **Hybrid Tab/Buffer System**: Use tabs for project organization, buffers for file switching
- **Numbered Tabline**: Easy tab navigation with `<leader>1-9`
- **Clipboard Integration**: Seamless copying between Neovim and system
- **Yank Highlighting**: Visual feedback when copying text

## Essential Key Mappings

### Leader Key
- `<leader>` = `<space>`

### File Navigation
- `<leader>e` - Toggle file explorer
- `<leader>sf` - Search files (Telescope)
- `<leader>sg` - Search text in files (live grep)
- `<leader><leader>` - Switch between open buffers

### Tab Management
- `<leader>1-9` - Jump to tab 1-9
- `<C-Enter>` - Open file in new tab (works in nvim-tree and Telescope)

### LSP Features
- `gd` - Go to definition
- `gr` - Find references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>q` - Open diagnostic quickfix list

### Window Navigation
- `<C-h/j/k/l>` - Move between windows/splits

### Autocompletion
- `<C-n>/<C-p>` - Navigate completion suggestions
- `<C-y>` - Accept completion
- `<C-Space>` - Trigger completion manually

## Plugin Management

This configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

### Common Commands
- `:Lazy` - Open plugin manager UI
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Install missing plugins and update existing ones
- `:Lazy clean` - Remove unused plugins

### Adding New Plugins
1. Create a new file in `lua/plugins/plugin-name.lua`
2. Add `require 'plugins.plugin-name'` to `lua/plugins/init.lua`
3. Restart Neovim - lazy.nvim will auto-install

## Language Server Setup

### Currently Configured
- **Python**: pyright (type checking, no style warnings)
- **Lua**: lua_ls (with Neovim API support)
- **Terraform**: terraformls

### Adding New Language Servers
1. Edit `lua/plugins/lsp.lua`
2. Add server to the `servers` table:
   ```lua
   servers = {
     your_server = {
       settings = {
         -- server-specific settings
       },
     },
   }
   ```
3. Mason will auto-install the server on next startup

### LSP Troubleshooting
- `:checkhealth vim.lsp` - Check active LSP servers and attached buffers
- `:Mason` - Manage installed language servers
- `:LspInfo` - Show LSP client status

## Troubleshooting

### Plugin Issues
1. **Plugin not loading**: Check `:Lazy` for installation status
2. **Errors on startup**: Check `:messages` for error details
3. **Performance issues**: Run `:Lazy profile` to identify slow plugins

### LSP Problems
1. **No completions**: Verify server is running with `:LspInfo`
2. **Python style warnings**: Check `lua/plugins/lsp.lua` pyright config
3. **Server not starting**: Check `:Mason` for server installation status

### Telescope Issues
1. **Files not found**: Check `file_ignore_patterns` in `lua/plugins/telescope.lua`
2. **Grep not working**: Ensure `rg` (ripgrep) is installed: `brew install ripgrep`
3. **fzf issues**: Ensure build tools available: `xcode-select --install`

### Treesitter Problems
1. **No syntax highlighting**: Run `:TSUpdate` to update parsers
2. **Missing languages**: Add to `ensure_installed` in `lua/plugins/treesitter.lua`, then `:TSInstall <lang>`
3. **Parser errors**: Run `:checkhealth nvim-treesitter`

> nvim-treesitter tracks the `main` branch. Highlighting and indentation are
> enabled per-buffer via a `FileType` autocmd in `lua/plugins/treesitter.lua`,
> not through plugin options. Parsers require the `tree-sitter` CLI.

### File Type Issues
1. **Wrong filetype detected**: Add autocmd to `lua/config/options.lua`
2. **LSP not attaching**: Verify filetype with `:set ft?`

## Customization

### Changing Theme
Edit `lua/plugins/colorscheme.lua` and replace `tokyonight.nvim` with your preferred theme.

### Adding Keymaps
Add global keymaps to `lua/config/keymaps.lua` or plugin-specific ones in the plugin's config file.

### Modifying Options
Edit `lua/config/options.lua` for Neovim settings like line numbers, indentation, etc.

## Backup and Recovery

The `backup/` directory contains your original working configuration. To restore:
```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim-modular

# Restore original
cp -r ~/.config/nvim/backup/* ~/.config/nvim/
```

## Dependencies

### Required
- Neovim 0.12+
- Git
- A Nerd Font (for icons)
- `tree-sitter` CLI (for nvim-treesitter `main` branch): `brew install tree-sitter-cli`

### Recommended
- `ripgrep` (for Telescope grep): `brew install ripgrep`
- `fd` (for better file finding): `brew install fd`
- Build tools: `xcode-select --install`

## Tmux Integration

See `.tmux.conf` for complementary tmux configuration with:
- Tokyo Night theme matching Neovim
- Shared clipboard integration
- Window-based workflow support

---

For issues or questions, check the troubleshooting section above or refer to individual plugin documentation.