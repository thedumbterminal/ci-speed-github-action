#!/usr/bin/env bash

#upload test xml to ci-speed

set -e

ACTION=$1
PROJECT_NAME=$2
BUILD_REF=$3
COMMIT=$4
RESULTS=$5

DEFAULT_HOST=https://ci-speed.herokuapp.com
HOST=${CI_SPEED_HOST:-$DEFAULT_HOST}

function upload () {
  echo "Upload..."
  for RESULT in ${RESULTS}; do
    if [ -f "${RESULT}" ]; then
      echo "Uploading '${RESULT}' ..."
      curl --fail-with-body -X "POST" \
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
}

function start () {
  echo "start..."
  curl --fail-with-body -X "POST" \
    "${HOST}/api/waypoints/" \
    -H "accept: application/json" \
    -H "Authentication-Token: ${CI_SPEED_AUTH_TOKEN}" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "project_name=${PROJECT_NAME}" \
    -d "build_ref=${BUILD_REF}" \
    -d "commit_sha=${COMMIT}&waypoint=start"
}

function finish () {
  echo "finish..."
  curl --fail-with-body -X "POST" \
    "${HOST}/api/waypoints/" \
    -H "accept: application/json" \
    -H "Authentication-Token: ${CI_SPEED_AUTH_TOKEN}" \
    -H "Content-Type: application/x-www-form-urlencoded'" \
    -d "project_name=${PROJECT_NAME}" \
    -d "build_ref=${BUILD_REF}" \
    -d "commit_sha=${COMMIT}" \
    -d "waypoint=finish"
}


echo "Action: ${ACTION} Project: ${PROJECT_NAME} Build: ${BUILD_REF}"

echo "Using host: ${HOST}"

case $ACTION in
  upload)
    upload
    ;;
  start)
    start
    ;;
  finish)
    finish
    ;;
  *)
    echo "Error: unknown action"
    exit 2
    ;;
esac
