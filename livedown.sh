#!/bin/bash

filename="$1"

if [[ -z $filename ]]; then
cat << EOL
Usage: ~/scripts/livedown README.md
EOL
fi

try=$(livedown stop)

CMD=$(cat << EOL
livedown start $filename --port 1337 &
sleep 1
open http://localhost:1337/
EOL
)

eval "$CMD"
