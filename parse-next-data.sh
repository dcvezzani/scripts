#!/bin/bash

function run() {
local input="$1"
local output="$2"

if [[ $input == "" ]]; then
cat << EOL
Usage: ~/scripts/parse-next-data.sh <input> <output>
E.g.,: ~/scripts/parse-next-data.sh next-data.text next-data.json
EOL
  return
fi

if [[ $output == "" ]]; then
  local output="next-data.json"
fi

cat "$input" | perl -ne '/__NEXT_DATA__/ && print' | perl -pe 's/^.*__NEXT_DATA__[^\{]+(.*)/$1/; s/(.*)<\/script>.*$/$1/' | jq '.' > "$output"
sleep 1
cat "$output" | jq '.'
cat << EOL >&2
File created/updated: $output
EOL
}

run "$1" "$2"

NOTES=$(cat << EOL
~/scripts/parse-next-data.sh /Users/dcvezzani/Dropbox/journal/current/20230131-next-data.txt
EOL
)
