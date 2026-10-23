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
- **Finicky** - Browser router (Zen by default; Accenture hosts, Workday, and Claude/Cursor login in Chrome)
- **AeroSpace** - Tiling window manager with vim-style bindings and named workspaces

## Prerequisites

### Required

```bash
# Install Homebrew first if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required dependencies
brew install --cask ghostty font-jetbrains-mono-nerd-font
brew install --cask nikitabobko/tap/aerospace
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
| `finicky/finicky.js` | `~/.finicky.js` |
| `aerospace/aerospace.toml` | `~/.config/aerospace/aerospace.toml` |

## Usage

### Init Script

```bash
# Standard setup (creates symlinks only)
./init_script.sh

# Clean setup (also clears Neovim caches)
./init_script.sh --clean
```

### AeroSpace

Tiling window manager. All bindings use Cmd+Option (`cmd-alt`), so plain Option keeps working for special characters and the Herdr/LazyVim Alt mappings. This overrides app shortcuts on the same keys, e.g. Hide Others (`cmd-alt-h`), Chrome DevTools console (`cmd-alt-j`) and Notion block shortcuts (`cmd-alt-1..9`). After installing, open AeroSpace once and grant Accessibility permission.

| Keys | Action |
|------|--------|
| `cmd-alt-h/j/k/l` | Focus left/down/up/right (crosses monitors) |
| `cmd-alt-shift-h/j/k/l` | Move window left/down/up/right (crosses monitors) |
| `cmd-alt-slash` / `cmd-alt-comma` | Tiles layout / accordion layout (tab-like) |
| `cmd-alt-f` | Fullscreen |
| `cmd-alt-shift-space` | Toggle floating/tiling |
| `cmd-alt-minus` / `cmd-alt-equal` | Shrink / grow |
| `cmd-alt-<ws>` / `cmd-alt-shift-<ws>` | Switch to / move window to workspace |
| `cmd-alt-tab` | Previous workspace |
| `cmd-alt-shift-tab` | Move workspace to next monitor |
| `cmd-alt-shift-semicolon` | Service mode (`esc` reload config, `r` reset layout, `cmd-alt-shift-h/j/k/l` join with neighbor) |

Workspaces (apps are moved there automatically when their windows open):

| Workspace | Apps |
|-----------|------|
| `T` Terminal | Ghostty |
| `B` Browser | Zen, Chrome |
| `C` Chat/Mail | Teams, Outlook |
| `N` Notes | Notion |
| `M` Music | Spotify |
| `A` AI | Cursor, DeepL |
| `1`-`9` | Free |

With two monitors, `T`, `B`, `1` and `2` open on the secondary (external) monitor, `3` and `4` on the built-in display, and everything else on the main display. With a single monitor, all workspaces are on it. To pin another workspace, add it under `[workspace-to-monitor-force-assignment]` in `aerospace/aerospace.toml`.

For multi-monitor stability, AeroSpace recommends disabling "Displays have separate Spaces" (requires logout) and arranging monitors so each has a free bottom-left or bottom-right corner (hidden windows are parked there):

```bash
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer
```

Rectangle fights AeroSpace over window positions, so don't run both. To switch to AeroSpace, quit Rectangle and untick "Launch on login" in its settings. To go back, quit AeroSpace from its menu bar icon and relaunch Rectangle.

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
