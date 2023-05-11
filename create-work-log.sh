#!/bin/bash

target_date="$1"

if [[ $target_date == 'yesterday' ]]; then
  target_date=$(date -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'tomorrow' ]]; then
  target_date=$(date -v +1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

if [[ $target_date == 'last-friday' ]]; then
  target_date=$(date -v -Sat -v -1d -jf '%Y-%m-%d' $(date '+%Y-%m-%d') "+%Y-%m-%d")
fi

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
filename=$(echo "work-log-$(target_date +%F-%a | perl -ne 'print lc').md")
datestamp=$(target_date "+%F (%a)")

workNotesFilename=$(DONT_OPEN=true "$(dirname -- "$0")/create-work-notes.sh" "$target_date")
obufFilename=$(DONT_OPEN=true TARGET_DATE="$target_date" "$(dirname -- "$0")/obuf.sh")
DONT_OPEN=true TARGET_DATE="$target_date" ~/scripts/obuf.sh

if [[ -e "$journalPath/$filename" ]]; then
  echo "work-log already exists!  Not overwriting"
  mvim -c "startinsert" -c "let curPos = getpos('.')" -c "call setpos('.', [curPos[0], 9, strlen(getline('.')), curPos[3]])" -p "$journalPath/$filename" "$workNotesFilename" "$obufFilename"
  exit 0
fi

cat /Users/dcvezzani/scripts/work-log.md | perl -pe 's#\{date\}#'"$datestamp"'#' > "$journalPath/$filename"
mvim -c "startinsert" -c "let curPos = getpos('.')" -c "call setpos('.', [curPos[0], 9, strlen(getline('.')), curPos[3]])" -p "$journalPath/$filename" "$workNotesFilename" "$obufFilename"

# let curPos = getpos('.')call setpos('.', [curPos[0], curPos[1]+1, curPos[2], curPos[3]])
