#!/bin/sh
set -eo pipefail
BASE=${PWD}

# Enable trace if DEBUG_TRACE is set.
if [[ ! -z ${DEBUG_TRACE} ]]; then
  set -x
fi

# Reconfigure the PATH to have nodejs binaries installed.
export PATH=/release-it/node_modules/.bin:${PATH}

if [[ ! -z $GITLAB_USER_NAME ]]; then
  git config --global user.name "${GITLAB_USER_NAME}"
fi
if [[ ! -z $GITLAB_USER_EMAIL ]]; then
  git config --global user.email "${GITLAB_USER_EMAIL}"
fi

# Set current directory as a safe directory.
git config --global --add safe.directory "${BASE}"

# Set branch on gitlab-ci environment.
if [[ ! -z $CI_COMMIT_REF_NAME ]]; then
  git checkout "${CI_COMMIT_REF_NAME}"
fi

# Run release-it.
release-it "${@}"