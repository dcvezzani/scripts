#!/bin/bash

target_date="$1"

function target_date() {
  date_format="$1"
  if [[ -z $date_format ]]; then
    date_format="+%F-%a"
  fi

  if [[ -z $target_date ]]; then
    target_date=$(date '+%Y-%m-%d')
  fi

  # CMD=$(cat << EOL
# date -jf '%Y-%m-%d' $TARGET_DATE $date_format
# EOL
# )
  # echo "$CMD"
  
  date -jf '%Y-%m-%d' "$target_date" "$date_format"
};

journalPath="/Users/dcvezzani/Dropbox/journal/current"
filename=$(echo "work-notes-$(target_date +%F-%a | perl -ne 'print lc').md")
datestamp=$(target_date "+%F (%a)")

if [[ -e "$journalPath/$filename" ]]; then
  if [[ -z $DONT_OPEN ]]; then 
    echo "work-notes already exists!  Not overwriting"
    mvim "$journalPath/$filename"
  else 
    echo "$journalPath/$filename"
  fi
  exit 0
fi

cat /Users/dcvezzani/scripts/work-notes.md | perl -pe 's#\{date\}#'"$datestamp"'#' > "$journalPath/$filename"
# mvim -c "startinsert" -c "let curPos = getpos('.')" -c "call setpos('.', [curPos[0], 9, strlen(getline('.')), curPos[3]])" "$journalPath/$filename"

if [[ -z $DONT_OPEN ]]; then mvim "$journalPath/$filename"; 
else echo "$journalPath/$filename"
fi

# let curPos = getpos('.')call setpos('.', [curPos[0], curPos[1]+1, curPos[2], curPos[3]])

