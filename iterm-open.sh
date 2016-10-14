#!/bin/zsh

# if can't shut down iTerm to pick up new environment settings
# simply reload, but try to be smart about it
which livedown >/dev/null 2>&1
if [ $? -ne 0 ]; then
  source ~/.zshrc
fi

if [ ! -z "$1" ]; then
  if [[ $1 == *.md ]]; then
    /usr/local/bin/mvim $1

  elif echo "$1" | grep '.*\.\(rb\|erb\)$' >/dev/null ; then
    if [ ! -z "$2" ]; then
      /usr/local/bin/mine $1:$2
    else
      /usr/local/bin/mine $1
    fi

  else
    /usr/bin/open $1
  fi
fi

