#!/bin/zsh

# if can't shut down iTerm to pick up new environment settings
# simply reload, but try to be smart about it
# which livedown >/dev/null 2>&1
# if [ $? -ne 0 ]; then
#   source ~/.zshrc
# fi

# filter file types; else uses default handler
if [ ! -z "$1" ]; then

  mvim=/usr/local/bin/mvim

  # open with vim
  if echo "$1" | grep '.*\.\(md\|markdown\|txt\)$' >/dev/null ; then
    zsh -i -c "$mvim $1"

  elif echo "$1" | grep '.*\.\(erl\|js\|ts\|c\|json\|hrl\)$' >/dev/null ; then
    if [ ! -z "$2" ]; then
      zsh -i -c "$ITERM_EDITOR -g $1:$2"
    else
      zsh -i -c "$ITERM_EDITOR $1"
    fi

  # default
  else
    zsh -i -c "/usr/bin/open $1"
  fi
fi

