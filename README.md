# dev-env

A modular, idempotent development environment setup system for quickly bootstrapping Linux machines (primarily Ubuntu/Debian, with some cross-platform support).

## Features

- **Modular installation scripts**: Each tool has its own installation script
- **Idempotent**: Safe to run multiple times - scripts check if tools are already installed
- **Dependency-ordered**: Scripts are prefixed with numbers to ensure correct installation order
- **Flexible filtering**: Choose specific tools to install or filter out unwanted ones
- **Automatic backups**: Configuration files are backed up before being replaced
- **Cross-platform ready**: Some scripts support multiple package managers (apt, pacman)
- **Error handling**: All scripts use `set -euo pipefail` for safer execution

## Quick Start

```bash
# Clone the repository
git clone https://github.com/albachteng/dev-env.git ~/dev-env

# Set the DEV_ENV environment variable
export DEV_ENV="$HOME/dev-env"

# Install all tools (dry run first to preview)
cd ~/dev-env
./run --dry

# Actually install everything
./run

# Deploy configuration files
./dev-env
```

## Repository Structure

```
dev-env/
├── dev-env              # Config deployment script
├── run                  # Installation orchestrator
├── .profile             # Shell profile additions
├── runs/                # Individual installation scripts
│   ├── 01-libs          # Base tools (git, curl, build-essential, etc.)
│   ├── 02-go            # Go programming language
│   ├── 03-node          # Node.js and npm via n
│   ├── 04-bash-lsp      # Bash language server
│   ├── 04-clangd        # C/C++ language server
│   ├── 04-go-tools      # Go dev tools (golangci-lint, delve, air)
│   ├── 04-gopls         # Go language server
│   ├── 04-js-tools      # JS package managers (pnpm, yarn)
│   ├── 04-lua-lsp       # Lua language server
│   ├── 04-typescript    # TypeScript language server
│   ├── 05-ansible       # Ansible automation tool
│   ├── 05-gdb           # GDB with GEF
│   ├── 05-neovim        # Neovim built from source
│   ├── 05-rofi          # Application launcher
│   ├── 05-tmux          # Terminal multiplexer
│   ├── 05-zsh           # Zsh with oh-my-zsh
│   ├── 06-git           # Git configuration
│   ├── 07-docker        # Docker and Docker Compose
│   ├── 07-gh            # GitHub CLI
│   └── 07-tui-tools     # lazygit, dive, jqp
└── env/                 # Configuration files to deploy
    ├── .config/
    │   └── tmux/
    │       └── tmux.conf
    ├── .local/
    │   └── scripts/
    │       ├── dev-env
    │       └── ready-tmux
    ├── .ready-tmux          # Default tmux session startup script
    ├── .zshrc
    ├── .zsh_profile
    └── tmux-sessionizer
```

## Usage

### Install Specific Tools

Use the `--choose` flag to only install specific tools:

```bash
# Install only neovim
./run --choose neovim

# Install only language servers
./run --choose lsp

# Install node and typescript
./run --choose "node\|typescript"
```

### Skip Specific Tools

Use the `--filter` flag to skip tools:

```bash
# Install everything except rofi
./run --filter rofi

# Skip all language servers
./run --filter lsp
```

### Install Specific Tool Categories

```bash
# Install only language servers
./run --choose lsp

# Install only Go tools (language + lsp + dev tools)
./run --choose go

# Install only Docker
./run --choose docker

# Install only TUI tools
./run --choose tui
```

### Dry Run Mode

Preview what would be installed without actually running:

```bash
./run --dry
./run --dry --choose neovim
```

### Deploy Configuration Files

The `dev-env` script copies configuration files from `env/` to your home directory:

```bash
# Preview what would be copied
./dev-env --dry

# Actually deploy configs
./dev-env
```

Configuration files are automatically backed up with a timestamp before being replaced.

## Environment Variables

### DEV_ENV
Path to the dev-env directory. Defaults to `$HOME/dev-env`.

```bash
export DEV_ENV="$HOME/dev-env"
```

### GO_VERSION
Go version to install. Defaults to `1.22.0`.

```bash
export GO_VERSION="1.23.0"
./run --choose go
```

### NVIM_VERSION
Neovim version to install. Defaults to `v0.10.2`.

```bash
export NVIM_VERSION="v0.11.0"
./run --choose neovim
```

### GIT_USER_EMAIL and GIT_USER_NAME
Git user configuration. Defaults to `albachteng@gmail.com` and `albachteng`.

```bash
export GIT_USER_EMAIL="your-email@example.com"
export GIT_USER_NAME="Your Name"
./run --choose git
```

## What Gets Installed

### Base Tools (01-libs)
**Build Tools:**
- build-essential (gcc, g++, make)
- pkg-config
- ccache (compiler cache)
- ninja-build

**Version Control & Download:**
- git
- curl, wget

**Search & Text Processing:**
- ripgrep (rg)
- fd (better find)
- bat (better cat with syntax highlighting)
- silversearcher-ag (code search)
- jq (JSON processor)

**System & Debugging:**
- xclip (clipboard)
- python3-pip
- htop, tree
- shellcheck (bash linter)
- net-tools
- strace (system call tracer)
- valgrind (memory debugger)

**Fuzzy Finder:**
- fzf

### Programming Languages
- **Go**: Official Go installation (v1.22.0 by default, configurable via GO_VERSION)
- **Node.js**: via n (Node version manager)

### Development Environment
- **Neovim**: Built from source (v0.10.2 by default)
- **Tmux**: Terminal multiplexer
- **Zsh**: With oh-my-zsh

### Language Servers & Development Tools
**Language Servers:**
- **Bash LSP**: bash-language-server
- **Lua LSP**: lua-language-server (v3.13.6)
- **Clangd**: C/C++ language server
- **Gopls**: Go language server
- **TypeScript LSP**: typescript-language-server

**Go Development Tools:**
- **golangci-lint**: Comprehensive linter
- **delve (dlv)**: Debugger
- **air**: Live reload for development

**JavaScript/TypeScript Tools:**
- **pnpm**: Fast, disk-efficient package manager
- **yarn**: Alternative package manager

### Additional Tools
- **Ansible**: Configuration management
- **Rofi**: Application launcher
- **GDB**: With GEF (GDB Enhanced Features)
- **Docker**: Container platform with Docker Compose
- **GitHub CLI**: Official GitHub command-line tool

### Terminal UI (TUI) Tools
- **lazygit**: Beautiful interactive git interface
- **dive**: Docker image layer explorer
- **jqp**: Interactive jq playground

## Configuration Files

The system deploys several configuration files:

- **`.zshrc`**: Zsh configuration with oh-my-zsh
- **`.zsh_profile`**: Custom PATH setup and shell functions
- **`tmux.conf`**: Tmux configuration with vi keybindings
- **`tmux-sessionizer`**: FZF-based tmux session launcher

### Key Features in Configs

**Zsh Profile**:
- Intelligent PATH management (avoids duplicates)
- FZF integration
- Custom utility functions: `catr()`, `cat1Line()`
- Configurable paths for all installed tools

**Tmux Config**:
- Vi-mode keybindings
- Pane navigation with hjkl
- Custom sessionizer bound to `prefix + f`
- 256 color support
- Clipboard integration

**Default .ready-tmux Script**:
Automatically runs when starting a new tmux session via tmux-sessionizer:
- Opens neovim in the project root
- Opens neovim's terminal panel (`<space>st`)
- Runs `git status` and `git log --oneline` in the terminal
- Creates a new tmux window
- Can be overridden by placing a `.ready-tmux` file in your project root

## Platform Support

The system primarily targets **Ubuntu/Debian** with apt, but some scripts support:

- **Arch Linux**: via pacman (clangd)
- **WSL2 Ubuntu**: Fully supported

Cross-platform improvements are ongoing.

## Dependency Ordering

Scripts are prefixed with numbers to ensure correct installation order:

1. **01-**: Base system tools (build tools, CLI utilities, debugging tools)
2. **02-**: Programming languages (Go)
3. **03-**: Language runtimes (Node.js)
4. **04-**: Language-specific tools (LSPs, linters, debuggers, package managers)
5. **05-**: Development environments (neovim, tmux, zsh, etc.)
6. **06-**: Configuration (git settings)
7. **07-**: Platform tools (Docker, GitHub CLI, TUI tools)

## Safety Features

- **Idempotency**: Scripts check if tools are already installed
- **Automatic backups**: Files are backed up before replacement
- **Error handling**: All scripts use `set -euo pipefail`
- **Safe variable expansion**: Quoted variables prevent word splitting
- **Dry run mode**: Preview changes before applying
- **Dependency checks**: Scripts verify prerequisites before installation

## Troubleshooting

### Scripts fail with "command not found"

Ensure scripts are executable:

```bash
chmod +x run dev-env runs/*
```

### npm/node commands not found after installation

Source your shell profile or restart your shell:

```bash
source ~/.zshrc
# or
exec zsh
```

### Git config not using my email

Set environment variables before running:

```bash
export GIT_USER_EMAIL="your-email@example.com"
export GIT_USER_NAME="Your Name"
./run --choose git
```

### Neovim build fails

Ensure you have build dependencies:

```bash
sudo apt install -y cmake gettext lua5.1 liblua5.1-0-dev
```

## Contributing

This is a personal dotfiles repository, but suggestions are welcome! Feel free to fork and adapt to your needs.

## License

MIT License - feel free to use and modify as needed.
