#!/bin/bash

# =================================== #
# 
# Move standup notes to monthly archive
# 
# Input
# pageId; number: id of confluence document (daily standup note)
# targetTitle; string: name of destination document to where the target document should be moved
# 
# Output
# string; json: should indicate whether the move was successful

function moveDocument() {
local pageId="$1"
local targetTitle="$2"
echo "Moving $pageId to '$targetTitle'..." >&2
  
local confluenceConfig=$(cat ~/.confluence.json)

local space=$(echo "$confluenceConfig" | jq -r '.space')
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local atl_token=$(~/scripts/confluence/get-atlassian-token.sh $pageId | jq -r '.atl_token')
cat << EOL >&2
Configuration:
JSESSIONID=$JSESSIONID
atl_token=$atl_token
space=$space
EOL
  

if [[ -z $targetTitle ]]; then
cat << 'EOL'
Usage: moveDocument <pageId> <targetTitle>

E.g., 
targetTitle='Standups+2023-07'
pageId=150803434
moveDocument "$pageId" "$targetTitle"
EOL
  return
fi

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/pages/movepage.action' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \\
  -H 'cookie: mywork.tab.tasks=false; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: empty' \\
  -H 'sec-fetch-mode: cors' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw 'pageId=${pageId}&spaceKey=${space}&targetTitle=${targetTitle}&position=append&mode=ASYNC&atl_token=${atl_token}' \\
  --compressed
EOL
)

eval "$CMD"
}

moveDocument "$1" "$2"

COMMENT=$(cat << EOL
console.log(Array.from(document.querySelectorAll('#main-content > ul > li > a')).filter(entry => {
return entry.getAttribute('href').startsWith('/pages')
&& entry.innerText.startsWith('Standup 2023-08')
}).map(entry => JSON.stringify({
name: entry.innerText, 
href: entry.getAttribute('href'),
id: entry.getAttribute('href').match(/\d+$/),
})).join("\n"))

console.log(Array.from(document.querySelectorAll('#main-content > ul > li > a')).filter(entry => {
return entry.getAttribute('href').startsWith('/pages')
&& entry.innerText.startsWith('Standup 2023-08')
}).map(entry => entry.getAttribute('href').match(/\d+$/)).join(" "))

for pageId in 160957429 160957445 161906732 161907016 161907552 161907553 161908003 161908789 161908841 161909144 161909988 161910037 163873239 163873255 163873988 163874068 163874466 163875474 163875475 163876199 163876440; do
~/scripts/confluence/move-document.sh "$pageId" "Standups 2023-08"
done

~/scripts/confluence/move-document.sh 161906732 "Standups 2023-08"

~/scripts/confluence/get-atlassian-token.sh 160957429

EOL)

