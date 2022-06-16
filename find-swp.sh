#!/bin/bash

# kudos
# https://www.tutorialkart.com/bash-shell-scripting/bash-date-format-options-examples/

targetDate="$1"

if [ "$targetDate" = "" ]; then
  targetDate=$(date +%F)
fi

# echo "$targetDate"

payload=$(
find ~ -type f -maxdepth 1 -name ".sw*" -newerBt "$targetDate"
find /Users/dcvezzani/Dropbox/journal/current /Users/dcvezzani/projects /Users/dcvezzani/Downloads /Users/dcvezzani/personal-projects /Users/dcvezzani /Users/dcvezzani/Documents \( -path /Users/dcvezzani/Library -o -path /Users/dcvezzani/.Trash \) -prune -type f -maxdepth 3 -name ".sw*" -newerBt "$targetDate"
)

echo -e "$payload" | sort -u
