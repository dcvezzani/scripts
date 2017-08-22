#!/bin/zsh

if [ -z "$1" ]; then
  echo "Usage: todos-for.sh api/src/call.erl"
  exit 1
fi

if [ ! -e "$1" ]; then
  echo "File does not exist"
  echo "Usage: todos-for.sh api/src/call.erl"
  exit 1
fi

grep -rn TODO "$1" | sed 's/\([^:]*:[^:]*\):\(.*\)/\1 \2/g'

