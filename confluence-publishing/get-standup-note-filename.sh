#!/bin/bash

# Gets the standup note for current day
# - or the day specified by date in format, 'yyyy-mm-dd'

input_target_date="$1"

if [[ $input_target_date == "help" ]]; then
cat << EOL
Usage ~/scripts/confluence-publishing/get-standup-note-filename.sh [<datestamp>]

E.g., 
~/scripts/confluence-publishing/publish-standup-notes.sh
~/scripts/confluence-publishing/publish-standup-notes.sh 2023-04-25
JSESSIONID=B87A60EBF55B57F7F3AF42563024FB0D ~/scripts/confluence-publishing/publish-standup-notes.sh 2023-04-25
EOL
exit 0
fi

# If a target date isn't provided, use the current date
if [[ -z $input_target_date ]]; then
  input_target_date=$(date '+%Y-%m-%d')
fi

# Name/location of file to be published
journalPath="/Users/dcvezzani/Dropbox/journal/current"
filename=$(echo "standup-$(date -jf "%Y-%m-%d" "$input_target_date" "+%F-%a" | perl -ne 'print lc').md")

echo -n "$journalPath/$filename"

