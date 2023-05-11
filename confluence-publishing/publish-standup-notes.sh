#!/bin/bash

# This utility may be used to publish an existing team standup note.  It will
# treat the file content as Markdown when publishing to Confluence.

JSESSIONID="$JSESSIONID"
input_target_date="$1"

filename=$(~/scripts/confluence-publishing/get-standup-note-filename.sh "$input_target_date")

JSESSIONID="$JSESSIONID" ~/scripts/confluence-publishing/publish-to-confluence.sh standup "$filename"

