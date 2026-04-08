# Dotfiles

Personal configuration files for macOS development environment.

## What's Included

- **Neovim** - LazyVim-based configuration
- **Ghostty** - Terminal emulator config (Tokyo Night theme)
- **Zellij** - Terminal multiplexer with custom layouts
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
brew install neovim zellij tmux starship zsh-autosuggestions zsh-syntax-highlighting fd fzf
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
| `zellij/` | `~/.config/zellij` |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `dotfiles/zshrc` | `~/.zshrc` |
| `starship/starship.toml` | `~/.config/starship.toml` |

## Usage

### Init Script

```bash
# Standard setup (creates symlinks only)
./init_script.sh

# Clean setup (also clears Neovim caches)
./init_script.sh --clean
```

### Zellij Sessions

```bash
# Start or attach a Zellij session for current or specified directory
workon [folder]

# Always start a fresh session (never attach)
workon --fresh [folder]

# Prepare issue worktree and start/attach issue session with OpenCode prompt
workon-issue [issue-number]

# Same as above, but always start fresh session
workon-issue --fresh [issue-number]

# Worktrees are stored under ~/source/.worktrees/<owner-repo>/
# Override with WORKTREE_BASE=/custom/path

# Start with fullstack layout (multiple panes)
workon-fullstack [folder]
```
