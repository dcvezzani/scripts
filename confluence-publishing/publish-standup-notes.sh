#!/bin/bash

# This utility may be used to publish an existing team standup note.  It will
# treat the file content as Markdown when publishing to Confluence.

# Verify a JESSIONID was provided
if ( [[ -z $JSESSIONID ]] || [[ -z $MRHSession ]] ); then
cat << EOL
Usage: JSESSIONID=<jsessionid> MRHSession=<mrhsession> ~/scripts/confluence-publishing/publish-standup-notes.sh [<yyyy-mm-dd>]
aka:   JSESSIONID=<jsessionid> MRHSession=<mrhsession> publish-standup [<yyyy-mm-dd>]

Note: get JSESSIONID Session cookie from browser after signing in and provide
  as argument

E.g., 
JSESSIONID=8AB227BF6E3993AC033BECB62452B864 MRHSession=b0006a351b7df6f219cbf122c055bc73 ~/scripts/confluence-publishing/publish-standup-notes.sh
JSESSIONID=8AB227BF6E3993AC033BECB62452B864 MRHSession=b0006a351b7df6f219cbf122c055bc73 ~/scripts/confluence-publishing/publish-standup-notes.sh 2023-04-18
EOL
  exit 1

fi

JSESSIONID="$JSESSIONID"
MRHSession="$MRHSession"
input_target_date="$1"

# If a target date isn't provided, use the current date
if [[ -z $input_target_date ]]; then
  input_target_date=$(date '+%Y-%m-%d')
fi

filename=$(~/scripts/confluence-publishing/get-standup-note-filename.sh "$input_target_date")

JSESSIONID="$JSESSIONID" MRHSession="$MRHSession" ~/scripts/confluence-publishing/publish-to-confluence.sh standup "$filename"

