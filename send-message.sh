#!/bin/bash

phone="$1"
msg="$2"

if (( $# < 2 )) ; then
  read msg
fi

if [[ -z $msg ]]; then
cat << EOL
Usages:

~/scripts/send-message.sh +12097569688 "this is a test"

cat << EOL | /Users/dcvezzani/scripts/send-message.sh +12097569688
this is a test
multiple lines
 EOL

EOL
  exit 1
fi

echo 'disabled: true'
# osascript ~/scripts/sendMessage.applescript "$phone" "$msg"

