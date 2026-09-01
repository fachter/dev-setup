# Dotfiles

Personal configuration files for macOS development environment.

## What's Included

- **Neovim** - LazyVim-based configuration
- **Ghostty** - Terminal emulator config (Gruvbox Dark theme)
- **Herdr** - Dev session manager with 4-tab workspace layout
- **Zellij** - Terminal multiplexer with custom layouts (legacy workflows)
- **tmux** - Alternative terminal multiplexer config
- **Zsh** - Shell configuration with plugins
- **Starship** - Cross-shell prompt (Tokyo Night preset)
- **WezTerm** - Alternative terminal emulator config

## Prerequisites

### Required

```bash
# Install Homebrew first if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required dependencies
brew install --cask ghostty font-jetbrains-mono-nerd-font
brew install neovim zellij tmux starship zsh-autosuggestions zsh-syntax-highlighting fd fzf jq

# Install Herdr (dev session manager)
curl -fsSL https://herdr.dev/install.sh | sh
```

### Optional

For specific development workflows:

```bash
brew install nvm postgresql@17 openjdk@21 terraform
```

## Installation

```bash
# Clone the repo
git clone https://github.com/yourusername/Config.git ~/source/Config

# Run the init script
cd ~/source/Config
./init_script.sh

# Restart your terminal
```

## Symlinks Created

| Source | Destination |
|--------|-------------|
| `nvim/` | `~/.config/nvim` |
| `ghostty/` | `~/.config/ghostty` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `zellij/` | `~/.config/zellij` |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `dotfiles/zshrc` | `~/.zshrc` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `worktrunk/config.toml` | `~/.config/worktrunk/config.toml` |

## Usage

### Init Script

```bash
# Standard setup (creates symlinks only)
./init_script.sh

# Clean setup (also clears Neovim caches)
./init_script.sh --clean
```

### Herdr Dev Sessions

The default dev workspace has four tabs: **Neovim**, **Agent** (auto-started Cursor agent), and two **Terminal** tabs.

```bash
# Start or attach a Herdr dev workspace for current or specified directory
workon [folder]

# Always start a fresh workspace (never attach)
workon --fresh [folder]

# Switch/create Worktrunk worktree and open dev workspace
wts [branch]

# Create branch from origin/main, then open dev workspace
wtnew my-feature
wtnew my-feature origin/main

# Worktrunk global defaults (via ~/.config/worktrunk/config.toml)
# New wt worktrees are stored under ~/source/.worktrees/<repo>/<branch>/
# .env, backend/.env, and frontend/.env are copied if present
```

### Zellij Sessions (legacy)

These helpers still use Zellij layouts:

```bash
# Prepare issue worktree and start/attach dev session (Agent tab: run `agent` manually)
workon-issue [issue-number]

# Same as above, but always start fresh session
workon-issue --fresh [issue-number]

# Worktrees are stored under ~/source/.worktrees/<owner-repo>/
# Override with WORKTREE_BASE=/custom/path

# Start with fullstack layout (multiple panes)
workon-fullstack [folder]

# Start with Gemini CLI layout
workon-lbf [folder]
```
