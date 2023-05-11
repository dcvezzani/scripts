#!/bin/bash

offset=0

if [[ ! -z $TARGET_DATE ]]; then
target_date="$TARGET_DATE"

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
  
dateIdentifier=$(target_date +%F-%a | perl -ne 'print lc')

else

if [ "$1" != '' ]; then
  offset="$1"
fi

today=$(date +%s)
dateIdentifier=$(date -r $(($today - (60*60*24*$offset))) '+%Y-%m-%d')
dateIdentifier=$(date -jf '%Y-%m-%d' "$dateIdentifier" "+%F-%a" | perl -ne 'print lc')
  
fi


# echo "$dateIdentifier"

filename="$JOURNAL_DIR/current/fbuf-$dateIdentifier.md"

if [[ -z $DONT_OPEN ]]; then 
  mvim "$filename"
else 
  echo "$filename"
fi

