#!/bin/bash

default_dir='~/Desktop'
cur_dir=${default_dir}

trap 'last_status="$?"; echo "error"; do_cleanup failed "$last_status" ; exit' ERR

check_usage () { 
if [ "$#" -eq 0 ]; then
  echo "
==================================
Change the save directory for screenshots (Shift-Cmd-4)

Usage: ~/scripts/change-screenshot-save-dir.sh <dir>

E.g.: ~/scripts/mac-change-screenshot-save-dir.sh $HOME_DIR/Documents/journal/tmp
"
  exit 2
fi
}

check_directory () {
  if [ ! -d "$1" ]; then
    echo "Directory doesn't exist" >&2
    return 1
  fi
}

save_current_save_location () {
  cur_dir=$(defaults read com.apple.screencapture location)

  if [ "$?" -ne 0  ]; then
    echo "Unable to get current save location for screencaptures" >&2
    return 1
  fi
}

do_cleanup () { echo "$1 (status $2) $(date)"; }

check_usage "$@"
check_directory "$1"
cur_dir=$(save_current_save_location)

do_cleanup () {
  defaults write com.apple.screencapture location $cur_dir
  echo "$1 $(date)"; 
}

defaults write com.apple.screencapture location $1
killall SystemUIServer



# do_cleanup () { 
#   case "$2" in
#     2)
#       echo "$1 (status $2) $(date)";
#       ;;
#     *)
#       echo "$1 (status $2) $(date)";
#   esac
# }

