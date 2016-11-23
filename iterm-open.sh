#!/bin/zsh

# if can't shut down iTerm to pick up new environment settings
# simply reload, but try to be smart about it
# which livedown >/dev/null 2>&1
# if [ $? -ne 0 ]; then
#   source ~/.zshrc
# fi

# filter file types; else uses default handler
if [ ! -z "$1" ]; then

  # open with vim
  if echo "$1" | grep '.*\.\(md\|markdown\|txt\)$' >/dev/null ; then
    /usr/local/bin/mvim $1

  # open with ruby mine
  elif echo "$1" | grep '.*\.\(rb\|erb\)$' >/dev/null ; then
    if [ ! -z "$2" ]; then
      /usr/local/bin/mine $1:$2
    else
      /usr/local/bin/mine $1
    fi

  # default
  else
    /usr/bin/open $1
  fi
fi

