#!/usr/bin/env bash

DOCKER_RELEASE_IT_BASE_TEMPLATE_FILE="${DOCKER_RELEASE_IT_BASE_TEMPLATE_FILE:-/templates/.release-it.json.tpl}"
DOCKER_RELEASE_IT_USE_BASE_TEMPLATE="${DOCKER_RELEASE_IT_USE_BASE_TEMPLATE:-false}"
DOCKER_RELEASE_IT_DO_NOT_MERGE="${DOCKER_RELEASE_IT_DO_NOT_MERGE:-0}"

# Use internal template as a base for the release-it configuration.
if [[ ! -f .release-it.json && "${DOCKER_RELEASE_IT_USE_BASE_TEMPLATE}" = "true" ]]; then
  echo "Using default release-it template."
  cp ${DOCKER_RELEASE_IT_BASE_TEMPLATE_FILE} ${BASE}/.release-it.json
  DOCKER_RELEASE_IT_DO_NOT_MERGE=1
fi

# Merge with the default one.
if [[ "${DOCKER_RELEASE_IT_USE_BASE_TEMPLATE}" = "true" && "${DOCKER_RELEASE_IT_DO_NOT_MERGE}" -eq 0 ]]; then
  echo "Merging with default template."
  jq -s '.[0] * .[1]' ${DOCKER_RELEASE_IT_BASE_TEMPLATE_FILE} .release-it.json > .release-it.json.over
  cp .release-it.json.over .release-it.json
  rm .release-it.json.over
fi