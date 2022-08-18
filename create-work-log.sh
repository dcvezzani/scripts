#!/bin/bash

journalPath="/Users/dcvezzani/Dropbox/journal/current"
filename=$(echo "work-log-$(date +%F-%a | perl -ne 'print lc').md")
datestamp=$(date "+%F (%a)")

if [[ -e "$journalPath/$filename" ]]; then
  echo "File already exists!  Not overwriting"
  mvim "$journalPath/$filename"
  exit 0
fi

cat /Users/dcvezzani/scripts/work-log.md | perl -pe 's#\{date\}#'"$datestamp"'#' > "$journalPath/$filename"
mvim -c "startinsert" -c "let curPos = getpos('.')" -c "call setpos('.', [curPos[0], 9, strlen(getline('.')), curPos[3]])" "$journalPath/$filename"

# let curPos = getpos('.')call setpos('.', [curPos[0], curPos[1]+1, curPos[2], curPos[3]])
