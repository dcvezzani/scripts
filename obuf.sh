#!/bin/bash

offset=0

if [ "$1" != '' ]; then
  offset="$1"
fi

today=$(date +%s)
dateIdentifier=$(date -r $(($today - (60*60*24*$offset))) +%Y%m%d)
# echo "$dateIdentifier"

mvim "/Users/davidvezzani/Dropbox/journal/current/fbuf-$dateIdentifier.md"
