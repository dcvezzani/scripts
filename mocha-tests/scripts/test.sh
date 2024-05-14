#!/bin/bash

fileCount=$#

WORK_PATH=$(dirname "$0")/..
cd "$WORK_PATH"

if [[ $# == 0 ]]; then
  # echo "run-all: {NODE_ENV: $NODE_ENV, NODE_TLS_REJECT_UNAUTHORIZED: $NODE_TLS_REJECT_UNAUTHORIZED}"
  # npm run test:pre && npm run test:base ./test/temples
  find test -name "*.test.js" | grep -ve 'config\|pre\.test' | xargs npm run test:base ./test/pre.test.js
else
  # echo "run-selected: {NODE_ENV: $NODE_ENV, NODE_TLS_REJECT_UNAUTHORIZED: $NODE_TLS_REJECT_UNAUTHORIZED, fileCount: $fileCount}"
  # npm run test:pre && npm run test:base $*
  npm run test:base ./test/pre.test.js $*
fi
