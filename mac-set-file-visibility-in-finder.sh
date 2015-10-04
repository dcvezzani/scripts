#!/bin/bash

function usage(){
  echo "======================================
Show/Hide hidden files in finder

Usage: 
~/scripts/mac-set-file-visibility-in-finder.sh on
~/scripts/mac-set-file-visibility-in-finder.sh off
"
}

if [ $# -eq 0 ]; then
  usage
  exit 2
fi

visibility=""
msg=""
case "$1" in
on)
  visibility="YES"
  msg="showing hidden files in Finder"
  ;;
off)
  visibility="NO"
  msg="hiding hidden files in Finder"
  ;;
*)
  usage
  exit 2
  ;;
esac

defaults write com.apple.finder AppleShowAllFiles "${visibility}"

sudo killall Finder
#open /System/Library/CoreServices/Finder.app

# echo "
# ${msg}
# ======================
# For the effects to take place...
# Hold the 'Option/alt' key, then right click on the Finder icon in the dock and click Relaunch"

