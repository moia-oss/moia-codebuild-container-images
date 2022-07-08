#!/bin/bash

set -eu

function setup_go_version {
    echo "configuring goenv to use go version $1..."

    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"

    goenv install $1
    goenv global $1
}

function setup_node_version {
    echo "configuring nvm to use node version $1..."

    export NVM_DIR=$HOME/.nvm;

    source $NVM_DIR/nvm.sh;
    nvm install --no-progress $1
    nvm alias default $1
    nvm use default
}

setup_go_version $DEFAULT_GO_VERSION
setup_node_version $DEFAULT_NODE_VERSION

echo ""
echo "==============================================="
echo "go version: $(go version)"
echo "node version: $(node -v)"
echo "npm version: $(npm -v)"
echo "aws-cli version: $(aws --version)"
echo "python3 version: $(python3 --version)"
echo "==============================================="
echo ""

eval "$@"
