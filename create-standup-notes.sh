#!/bin/bash

input_target_date="$1"

if [[ $input_target_date == 'yesterday' ]]; then
  input_target_date=$(date -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $input_target_date == 'tomorrow' ]]; then
  input_target_date=$(date -v +1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $input_target_date == 'last-friday' ]]; then
  input_target_date=$(date -v -Sat -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ -z $input_target_date ]]; then
  input_target_date=$(date '+%Y-%m-%d')
fi

journalPath="/Users/dcvezzani/Dropbox/journal/current"
filename=$(echo "standup-$(date -jf "%Y-%m-%d" "$input_target_date" "+%F-%a" | perl -ne 'print lc').md")
datestamp=$(date -jf "%Y-%m-%d" "$input_target_date" "+%F (%a)")
# datestamp=$(date "+%F (%a)")

if [[ -e "$journalPath/$filename" ]]; then
  echo "File already exists!  Not overwriting; just opening."
  mvim "$journalPath/$filename"
  exit 0
fi

cat /Users/dcvezzani/scripts/standup-template.md | perl -pe 's#\{date\}#'"$datestamp"'#' > "$journalPath/$filename"
mvim -c "startinsert" -c "let curPos = getpos('.')" -c "call setpos('.', [curPos[0], 9, strlen(getline('.')), curPos[3]])" "$journalPath/$filename"

# let curPos = getpos('.')call setpos('.', [curPos[0], curPos[1]+1, curPos[2], curPos[3]])

