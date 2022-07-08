#!/bin/bash

set -eu

function setup_go_version {
    # configure goenv version
    echo "configuring goenv version..."

    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"

    goenv install $DEFAULT_GO_VERSION
    goenv global $DEFAULT_GO_VERSION
    echo "running $(go version)"
}

function setup_node_version {
    echo "configuring npm version..."

    export NVM_DIR=$HOME/.nvm;

    source $NVM_DIR/nvm.sh;
    nvm install --no-progress $DEFAULT_NODE_VERSION
    nvm alias default $DEFAULT_NODE_VERSION
    nvm use default

    echo "running node version $(node -v)"
    echo "running npm version $(npm -v)"
}

setup_go_version
setup_node_version

eval "$@"
