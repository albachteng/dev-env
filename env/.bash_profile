VIM="nvim"
DEV_ENV="$HOME/dev-env"

## All that sweet sweet fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GIT_EDITOR=$VIM

dev_env() {

}

# Where should I put you?
bind -x '"\C-f":"tmux-sessionizer"'

catr() {
    tail -n "+$1" $3 | head -n "$(($2 - $1 + 1))"
}

cat1Line() {
    cat $1 | tr -d "\n"
}


addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

# Go paths
export GOPATH="$HOME/go"
addToPathFront /usr/local/go/bin
addToPathFront "$GOPATH/bin"

# Node and npm paths
export N_PREFIX="$HOME/.local/n"
addToPathFront $HOME/.local/.npm-global/bin
addToPathFront $HOME/.local/scripts
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.local/npm/bin
addToPathFront $HOME/.local/n/bin/

# .NET paths
export DOTNET_ROOT="$HOME/.dotnet"
addToPathFront "$DOTNET_ROOT"
addToPathFront "$DOTNET_ROOT/tools"

# Other development tools
addToPathFront $HOME/.local/apps/
addToPathFront $HOME/.local/bin/lua-language-server/bin
addToPathFront /usr/local/bin
