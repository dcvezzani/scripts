#!/bin/bash

filename=$1

if [[ $filename == "help" ]]; then
cat << EOL
Usage [<JSESSIONID>] ~/scripts/confluence-publishing/developer-notes.sh [<filename>]

E.g., 
~/scripts/confluence-publishing/developer-notes.sh /Users/dcvezzani/asdf.md
JSESSIONID=B87A60EBF55B57F7F3AF42563024FB0D ~/scripts/confluence-publishing/developer-notes.sh /Users/dcvezzani/asdf.md
EOL
exit 0
fi

JSESSIONID="$JSESSIONID" ~/scripts/confluence-publishing/publish-to-confluence.sh developers-blog "$filename"
