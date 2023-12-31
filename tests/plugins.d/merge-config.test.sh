#!/usr/bin/env bash
set -e

BASEDIR=$(dirname "$0")
source ${BASEDIR}/../common.sh
BUILD=$(build 2>&1 >/dev/null)

# Get the exit status of last command.
EXIT_STATUS=$?
if [[ ${EXIT_STATUS} -ne 0 ]]; then
  echo "Build failed."
  echo "${BUILD}"
  exit 1
fi

# Test 1.
EXPECT="Using default release-it template."
SCRIPT="export DOCKER_RELEASE_IT_USE_BASE_TEMPLATE=true; mkdir /test-1 && cd /test-1 && /usr/local/bin/plugins.d/merge-config.sh"
test "using default files if empty" "${EXPECT}" "${SCRIPT}"

# Test 2.
EXPECT_MERGE_1="Merging with default template."
EXPECT_MERGE_2="\"test-presence\": true"
SCRIPT=$(cat <<EOF
    export DOCKER_RELEASE_IT_USE_BASE_TEMPLATE=true
    mkdir /test-1 && cd /test-1 && cp /tests/plugins.d/merge-config-files/.release-it.json . && /usr/local/bin/plugins.d/merge-config.sh
    cat .release-it.json
EOF
)

test "merge with default template 1" "${EXPECT_MERGE_1}" "${SCRIPT}"
test "merge with default template 2" "${EXPECT_MERGE_2}" "${SCRIPT}"

# Test 3.
EXPECT=""
SCRIPT=$(cat <<EOF
    export DOCKER_RELEASE_IT_USE_BASE_TEMPLATE="false"
    mkdir /test-1 && cd /test-1 && cp /tests/plugins.d/merge-config-files/.release-it.json . && /usr/local/bin/plugins.d/merge-config.sh
EOF
)
test "do not merge when DOCKER_RELEASE_IT_USE_BASE_TEMPLATE is false" "${EXPECT}" "${SCRIPT}"

# Test 4.
EXPECT=""
SCRIPT="DOCKER_RELEASE_IT_USE_BASE_TEMPLATE=false mkdir /test-1 && cd /test-1 && /usr/local/bin/plugins.d/merge-config.sh"
test "do nothing when DOCKER_RELEASE_IT_USE_BASE_TEMPLATE if false" "${EXPECT}" "${SCRIPT}"
