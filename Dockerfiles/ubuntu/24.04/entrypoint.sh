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
    n $NODEJS_VERSION
}

if [ "$GO_VERSION" != "$DEFAULT_GO_VERSION" ]; then
    setup_go_version $GO_VERSION
fi

if [ "$NODEJS_VERSION" != "$DEFAULT_NODEJS_VERSION" ]; then
    setup_node_version $NODEJS_VERSION
fi

if [ "$JAVA_VERSION" != "$DEFAULT_JAVA_VERSION" ]; then
    java_dir="/usr/lib/jvm/java-${JAVA_VERSION}-amazon-corretto"

    apt-get install -qq -y "java-${JAVA_VERSION}-amazon-corretto-jdk"
    update-alternatives --set java "${java_dir}/bin/java"
fi

echo ""
echo "==============================================="
echo "go version: $(go version)"
echo "nodejs version: $(node -v)"
echo "npm version: $(npm -v)"
echo "aws-cli version: $(aws --version)"
echo "aws-cdk version:" "$(cdk --version)"
echo "python3 version: $(python3 --version)"
echo "java version: $(java --version)"
echo "==============================================="
echo ""

eval "$@"
