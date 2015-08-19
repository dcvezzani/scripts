#!/bin/zsh

if [ ! -z "$1" ]; then
  if [ ! -z "$2" ]; then
    /usr/local/bin/mine $1:$2
  else
    /usr/local/bin/mine $1
  fi

else
  /usr/local/bin/mine
fi
