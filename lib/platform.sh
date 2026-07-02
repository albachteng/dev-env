#!/usr/bin/env bash
# Source this file in individual run scripts to get platform helpers.
# PLATFORM may be pre-exported by the run orchestrator (--mac flag).

if [[ -z "${PLATFORM:-}" ]]; then
    case "$(uname -s)" in
        Darwin) PLATFORM="macos" ;;
        Linux)  PLATFORM="linux" ;;
        *)
            echo "Unsupported OS: $(uname -s)" >&2
            exit 1
            ;;
    esac
fi
export PLATFORM

case "$(uname -m)" in
    x86_64)        ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac
export ARCH

is_macos() { [[ "$PLATFORM" == "macos" ]]; }
is_linux() { [[ "$PLATFORM" == "linux" ]]; }

# Install one or more packages via the platform's native package manager.
# Caller is responsible for passing the correct platform-specific name;
# use pkg_name() to remap if needed.
pkg_install() {
    if is_macos; then
        brew install "$@"
    else
        sudo apt-get install -y "$@"
    fi
}

# Remap a canonical package name to the platform-specific name.
pkg_name() {
    local canonical="$1"
    if is_macos; then
        case "$canonical" in
            fd-find)           echo "fd" ;;
            silversearcher-ag) echo "the_silver_searcher" ;;
            ninja-build)       echo "ninja" ;;
            python3-pip)       echo "python3" ;;
            *)                 echo "$canonical" ;;
        esac
    else
        echo "$canonical"
    fi
}

# npm global install — sudo only needed on Linux with system-managed npm prefix.
npm_global_install() {
    if is_macos; then
        npm install -g "$@"
    else
        sudo npm install -g "$@"
    fi
}

# Ensure Homebrew is present on macOS (no-op on Linux).
ensure_brew() {
    is_macos || return 0
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for the remainder of this session
        if [[ "$ARCH" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}
