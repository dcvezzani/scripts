#/bin/bash

lineNumber="$1"

if [ "$lineNumber" == "" ]; then
  echo "Usage: e.g., ./remove-ssh-key.sh 32"
  exit 1
fi

sed -i.bak -e "${lineNumber}d" /Users/dcvezzani/.ssh/known_hosts

