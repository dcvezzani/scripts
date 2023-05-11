#!/bin/bash

cat << EOL
open https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=65996021
EOL

echo -n "JSESSIONID: "
read JSESSIONID

echo "$(cd "$(dirname -- "$1")" >/dev/null; pwd -P)/$(basename -- "$1")"


echo "$JSESSIONID" | /Users/dcvezzani/scripts/confluence-publishing/confluence-publishing-update-config.js $(eval "cd ~; pwd")


