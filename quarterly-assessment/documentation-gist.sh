#!/bin/bash

year="$1"
quarter="$2"

if [[ -z $quarter ]]; then
cat << EOL
Gather gist documentation for a given quarter

Usage: ~/scripts/quarterly-assessment/documentation-gist.sh 2023 1
EOL
exit 1
fi

JOURNAL_DIR='/Users/dcvezzani/Dropbox/journal/current'
filename="${JOURNAL_DIR}/${year}-q${quarter}-assessment-documentation-gist.md"
if [[ -f $filename ]]; then
cat << EOL
File already exists ("$filename")

Remove/rename existing file and try again.
EOL
exit 1
fi

echo '' > "$filename"

createLink() {
local children=$(cat < /dev/stdin)
local uuid="$1"
echo "- [${children}](https://gist.github.com/dcvezzani-church/${uuid})"
}

# TODO: gather together uuid values for documents touched within the last 3 months

start_month=$(printf "%02d" $(((quarter * 3) - 3 + 1)))
start_date="${year}-${start_month}-01"

CMD=$(cat << EOL
gh gist list --limit 100 | grep -E "$(date -jf '%Y-%m-%d' $start_date "+%Y-%m")|$(date -v +1m -jf '%Y-%m-%d' $start_date "+%Y-%m")|$(date -v +2m -jf '%Y-%m-%d' $start_date "+%Y-%m")"
EOL
)
json=$(eval "$CMD" | ~/scripts/quarterly-assessment/documentation-gist.js)

# echo "$json" | jq '.'
uuids=$(echo "$json" | jq -r '.|map(.uuid)|join(" ")')

for uuid in $(echo "$uuids"); do

# echo "$uuid" >&2
link=$(gh gist view $uuid | perl -ne 'print if /^#/ && ++$count == 1' | perl -pe 's/^#+ *(.*)/\1/' | createLink $uuid)
echo "$link" >&2
echo "$link"
done >> "$filename"

echo
cat << EOL
Results written to: $filename
EOL
