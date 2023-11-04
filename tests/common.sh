#/bin/sh

# Color codes.
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color.

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
  docker build -t paolomainardi/release-it-test -f build/Dockerfile .
}

run() {
    if [[ -z "${@}" ]]; then
       set -- sh
    fi
	docker run -it --rm --entrypoint ash \
		-v $(pwd)/build/docker-entrypoint.sh:/usr/local/bin/entrypoint.sh \
        -v $(pwd)/build/plugins.d:/usr/local/bin/plugins.d \
		-v $(pwd)/templates:/templates \
        -v $(pwd)/tests:/tests \
		-v $(pwd)}:/app paolomainardi/release-it -c "${@}"
}

test() {
    if [[ -z "${3}" ]]; then
       fail "Missing test command."
    fi
    echo -n "Test: ${1}..."
    RES=$(run "${3}")
    EXPECTED="${2}"
    if [[ "${RES}" != *"${EXPECT}"* ]]; then
        fail "${EXPECTED}" "${RES}"
    fi
    ok
}