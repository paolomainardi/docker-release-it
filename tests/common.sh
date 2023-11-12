#/bin/sh

# Color codes.
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color.

DOCKER_IMAGE="paolomainardi/release-it-test"

if [[ ! -z $TRACE ]]; then
  set -x
fi

fail() {
  echo -e "${RED}FAIL${NC}"
  echo "Expected: ${1}"
  echo "Got: ${2}"
  exit 1
}

ok() {
  echo -e "${GREEN}OK${NC}"
}

build() {
  docker build -t ${DOCKER_IMAGE} -f build/Dockerfile .
}

run() {
  DOCKER_INTERACTIVE=""
  if [[ -z "${@}" ]]; then
    DOCKER_INTERACTIVE="-it"
    set -- sh
  fi
  RET=$(build 2>&1 >/dev/null)
  if  [[ $? -ne 0 ]]; then
    echo "Build failed."
    echo "${RET}"
    exit 1
  fi

	docker run ${DOCKER_INTERACTIVE} --rm --entrypoint ash \
		-v $(pwd)/build/docker-entrypoint.sh:/usr/local/bin/entrypoint.sh \
        -v $(pwd)/build/plugins.d:/usr/local/bin/plugins.d \
		-v $(pwd)/templates:/templates \
        -v $(pwd)/tests:/tests \
		-v $(pwd)}:/app ${DOCKER_IMAGE} -c "${@}"
}

test() {
    if [[ -z "${3}" ]]; then
       fail "Missing test command."
    fi
    echo -n "Test: ${1}..."
    RES=$(run "${3}")
    COMMAND="${4:-contains}"
    EXPECTED="${2}"
    if [[ "${COMMAND}" == "contains" ]]; then
        contains "${RES}" "${EXPECTED}"
    elif [[ "${COMMAND}" == "equal" ]]; then
        equal "${RES}" "${EXPECTED}"
    else
        fail "Unknown command ${COMMAND}."
    fi
}

contains() {
  RES="${1}"
  EXPECTED="${2}"
  if [[ "${RES}" != *"${EXPECTED}"* ]]; then
    fail "${EXPECTED}" "${RES}"
  fi
  ok
}

equal() {
  RES="${1}"
  EXPECTED="${2}"
  if [[ "${RES}" != "${EXPECTED}" ]]; then
    fail "${EXPECTED}" "${RES}"
  fi
  ok
}