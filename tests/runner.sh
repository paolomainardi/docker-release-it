#!/usr/bin/env bash
set -e

BASEDIR=$(dirname "$0")
source ${BASEDIR}/common.sh
BUILD=$(build 2>&1 >/dev/null)

for TEST in $(ls tests/plugins.d/*.test.sh); do
    echo "Running ${TEST}..."
    ${TEST}
done