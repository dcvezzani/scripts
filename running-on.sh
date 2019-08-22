#!/bin/bash

if [ "$1" == "" ]; then
  echo "Usage: ./running-on.sh 1337"
  exit 1
fi

# echo "running: 'lsof -t -i :$1'"
# lsof -t -i :$1
lsof -i TCP:$1 | grep LISTEN
