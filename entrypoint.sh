#!/usr/bin/env bash
set -e
set -o errtrace
set -o errexit
set -o pipefail

BASE=${PWD}

# Enable trace if DEBUG_TRACE is set.
if [[ ! -z ${DEBUG_TRACE} ]]; then
  set -x
fi

# Reconfigure the PATH to have nodejs binaries installed.
export PATH=/release-it/node_modules/.bin:${PATH}

if [[ ! -z "${GITLAB_USER_NAME}" ]]; then
  git config --global user.name "${GITLAB_USER_NAME}"
fi
if [[ ! -z "${GITLAB_USER_EMAIL}" ]]; then
  git config --global user.email "${GITLAB_USER_EMAIL}"
fi

# Set current directory as a safe directory.
git config --global --add safe.directory "${BASE}"

# Set branch on gitlab-ci environment.
if [[ ! -z "${CI_COMMIT_REF_NAME}" ]]; then
  git checkout "${CI_COMMIT_REF_NAME}"
fi

# If we set a gitlab project token, we can use it to push to the repository.
# Taken from here: https://github.com/sparkfabrik/spark-k8s-deployer/blob/master/templates/scripts/ci_releases/setup_repo_for_writing.sh
if [[ ! -z "${GITLAB_PROJECT_RW_AND_API_TOKEN}" ]]; then
  # Validate the variable.
  IFS=':' read -ra GITLAB_PROJECT_VALIDATE <<< "${GITLAB_PROJECT_RW_AND_API_TOKEN}"
  if [[ "${#GITLAB_PROJECT_VALIDATE[@]}" -ne 2 ]]; then
    echo "The GITLAB_PROJECT_RW_AND_API_TOKEN variable is not valid. It should be in the form of <project_id>:<token>."
    exit 1
  fi
  NEWREMOTEURL=$(echo "${CI_REPOSITORY_URL}" | sed -e "s|.*@\(.*\)|${CI_SERVER_PROTOCOL}://$[GITLAB_PROJECT_RW_AND_API_TOKEN]@\1|")
  echo "Setting a new origin using the token specified at GITLAB_PROJECT_RW_AND_API_TOKEN variable."
  git remote set-url origin "${NEWREMOTEURL}"
fi

# Run release-it.
release-it "${@}"