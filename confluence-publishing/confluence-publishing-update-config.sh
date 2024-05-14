#!/bin/bash

cat << EOL
open https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=65996021
EOL

parsedCookies=$(~/scripts/confluence-publishing/parse-cookies.js "$1")

JSESSIONID=$(echo "$parsedCookies" | jq -r '.JSESSIONID')
MRHSession=$(echo "$parsedCookies" | jq -r '.MRHSession')

if [[ -z $JSESSIONID ]]; then
  echo -n "JSESSIONID: "
  read JSESSIONID
fi

if ( [[ -z $MRHSession ]] || [[ "$MRHSession" == "null" ]] ); then
  MRHSession=$(cat ~/.confluence.json| jq -r '.MRHSession')
fi

if [[ -z $MRHSession ]]; then
  echo -n "MRHSession: "
  read MRHSession
fi

# echo "$(cd "$(dirname -- "$1")" >/dev/null; pwd -P)/$(basename -- "$1")"


echo "{\"jsessionid\": \"$JSESSIONID\", \"mrhsession\": \"$MRHSession\"}" | ~/scripts/confluence-publishing/confluence-publishing-update-config.js $(eval "cd ~; pwd")


