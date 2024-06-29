#!/usr/bin/env bash

#upload test xml to ci-speed

set -e

PROJECT_NAME=$1
BUILD_REF=$2
COMMIT=$3
RESULTS=$4

HOST=https://ci-speed.herokuapp.com

echo "Project: ${PROJECT_NAME} Build: ${BUILD_REF}"

for RESULT in ${RESULTS}; do
  if [ -f "${RESULT}" ]; then
    curl --fail -X "POST" \
      "${HOST}/api/test_runs/" \
      -H "accept: application/json" \
      -H "Authentication-Token: ${CI_SPEED_AUTH_TOKEN}" \
      -H "Content-Type: multipart/form-data" \
      -F "file=@${RESULT};type=text/xml" \
      -F "project_name=${PROJECT_NAME}" \
      -F "build_ref=${BUILD_REF}" \
      -F "commit_sha=${COMMIT}"
  else
    echo "Results file '${RESULT}' not found"
  fi
done
