#!/usr/bin/env bash

set -eu
set -o pipefail

major_version=$1

"${HOME}"/.goenv/plugins/go-build/bin/go-build --definitions | grep "${major_version}" | sort --version-sort | tail -n1
