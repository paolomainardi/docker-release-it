#!/bin/sh
set -eo pipefail
BASE=${PWD}

# Reconfigure the PATH to have nodejs binaries installed.
export PATH=/release-it/node_modules/.bin:${PATH}

if [[ -z $GITLAB_USER_NAME ]]; then
  git config --global user.name "${GITLAB_USER_NAME}"
fi
if [[ -z $GITLAB_USER_EMAIL ]]; then
  git config --global user.email "${GITLAB_USER_EMAIL}"
fi

# Set current directory as a safe directory.
git config --global --add safe.directory "${PWD}"

# release-it work just on branches.
git checkout "${CI_COMMIT_REF_NAME}"

# Run release-it.
release-it "${@}"