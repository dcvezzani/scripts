#!/bin/bash

function _filter() {
  for line in $(ls -atr "$JOURNAL_DIR"/current | grep -vE '(\..*)*\.s[a-z][a-z]' | grep -vE '^.$' | tail -100); do
    echo ""$JOURNAL_DIR"/current/$line"
  done
}

if [[ ! -z "$1" ]]; then
  _filter | xargs grep -rl "$1"
else
  _filter
fi
