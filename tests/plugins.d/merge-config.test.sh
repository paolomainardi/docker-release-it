#!/bin/sh
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
SCRIPT="mkdir /test-1 && cd /test-1 && /usr/local/bin/plugins.d/merge-config.sh"
test "using default files if empty" "${EXPECT}" "${SCRIPT}"

# Test 2.
echo -n "Test: merge with default template..."
EXPECT_MERGE_1="Merging with default template."
EXPECT_MERGE_2="\"test-presence\": true"
SCRIPT=$(cat <<EOF
    mkdir /test-1 && cd /test-1 && cp /tests/plugins.d/merge-config-files/.release-it.json . && /usr/local/bin/plugins.d/merge-config.sh
    cat .release-it.json
EOF
)
TEST=$(run "${SCRIPT}")
if [[ ${TEST} != *"${EXPECT_MERGE_1}"* ]] || [[ ${TEST} != *"${EXPECT_MERGE_2}"* ]]; then
  fail "${EXPECT_MERGE_1} ${EXPECT_MERGE_2}" "${TEST}"
fi
ok

# Test 3.
EXPECT=""
SCRIPT=$(cat <<EOF
    export DOCKER_RELEASE_IT_USE_BASE_TEMPLATE="false"
    mkdir /test-1 && cd /test-1 && cp /tests/plugins.d/merge-config-files/.release-it.json . && /usr/local/bin/plugins.d/merge-config.sh
EOF
)
test "do not merge when DOCKER_RELEASE_IT_USE_BASE_TEMPLATE is false" "${EXPECT}" "${SCRIPT}"