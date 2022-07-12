#!/bin/bash

set -eu

function setup_go_version {
    echo "configuring goenv to use go version $1..."
    GO_LATEST_MINOR_VERSION=$(latest_minor_go_version.sh $GO_VERSION)
    goenv install $GO_LATEST_MINOR_VERSION
    goenv global $GO_LATEST_MINOR_VERSION
}

function setup_node_version {
    echo "configuring n to use node version $1..."
    n $NODE_VERSION
}

if [ "$GO_VERSION" != "$DEFAULT_GO_VERSION" ]; then
    setup_go_version $GO_VERSION
fi

if [ "$NODE_VERSION" != "$DEFAULT_NODE_VERSION" ]; then
    setup_node_version $NODE_VERSION
fi

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
