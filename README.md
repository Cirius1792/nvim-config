# My Neovim IDE Setup

This repository contains my configuration for a fully-featured Neovim IDE setup. The configuration leverages a robust plugin manager and organizes plugins into several categories for an enhanced development experience.

## Categories and Plugins

### Appearance
- **appearance**: Configures themes and visual tweaks (see `lua/plugins/appearance/init.lua`)

### Completion
- **cmp**: Code completion framework (see `lua/plugins/cmp/init.lua`)

### AI/Assistants
- **codeium**: AI-based code suggestions (backup: `lua/plugins/codeium/init.lua.bk`)
- **copilot**: GitHub Copilot integration (`lua/plugins/copilot/init.lua`)
- **code companion**: Provides context-aware code assistance (see `lua/plugins/code_companion/init.lua`)

### Debugging
- **dap**: Debug adapter protocol integration for Neovim (`lua/plugins/dap/init.lua`)

### File Navigation
- **find**: Enhanced file finder (`lua/plugins/find/init.lua`)
- **navigation**: General navigation enhancements (`lua/plugins/navigation/init.lua`)
- **harpoon**: Quick file navigation and bookmark manager (`lua/plugins/harpoon/init.lua`)

### Formatting
- **formatter**: Code formatting tool (`lua/plugins/formatter/init.lua`)

### Version Control
- **git**: Git integration and helper commands (see `lua/plugins/git/init.lua` and backup `lua/plugins/git/init.lua.bkp`)

### Language Servers & Linting
- **jdtls**: Java language server (`lua/plugins/jdtls/init.lua`)
- **lsps**: General LSP configurations and Go specifics (`lua/plugins/lsps/init.lua`, `lua/plugins/lsps/go.lua`)
- **mason**: Manager for external tools like LSPs, linters, DAP, etc. (`lua/plugins/mason/init.lua`)
- **markdown**: Markdown support (`lua/plugins/markdown/init.lua`)
- **pyright**: Python language server providing linting and type checking (see `lua/plugins/pyright/init.lua`)

### Additional Enhancements
- **obsidian**: Integration with Obsidian notes (backup: `lua/plugins/obsidian/init.lua.bkp`)
- **refactor**: Tools for code refactoring (`lua/plugins/refactor/init.lua`)
- **surround**: Surround text objects and quick modifications (`lua/plugins/surround/init.lua`)
- **test**: Testing framework integrations (`lua/plugins/test/init.lua`)
- **treesitter**: Syntax highlighting and code structure visualization (`lua/plugins/treesitter/init.lua`)
- **trouble**: Diagnostics and issue navigation (`lua/plugins/trouble/init.lua`)
- **undotree**: Enhanced undo history visualization (`lua/plugins/undotree/init.lua`)

## Installation and Usage

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Install any dependencies if required.
3. Launch Neovim to load your setup.

## Contributing

Feel free to open an issue or fork the repository to improve this configuration.

---

Enjoy your Neovim IDE! Happy Coding!
