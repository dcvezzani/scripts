#!/bin/zsh

source ~/scripts/colors.sh

# =================================== #
# 
# Delete document
# 
# Input
# pageId; number: id of confluence document to be deleted
# 
# Output
# string; json: should indicate whether the delete was successful

function deleteDocument() {
read configJson

local pageId=$(echo "$configJson" | jq -r '.pageId')
local pageTitle=$(echo "$configJson" | jq -r '.pageTitle')

cat << EOL >&2
${COLOR_LIGHT_CYAN}
Inputs:
configJson=$configJson
pageId=$pageId
pageTitle=$pageTitle
${COLOR_NONE}
EOL

if [[ -z $pageId ]]; then
cat << 'EOL'
Usage: 
~/scripts/confluence/fetch-document.sh <pageId> | deleteDocument

E.g., 
pageId=150803434
~/scripts/confluence/fetch-document.sh "$pageId" | deleteDocument
EOL
  return
fi

cat << EOL >&2
${COLOR_LIGHT_CYAN}
Inputs:
pageId=$pageId
${COLOR_NONE}
EOL

echo "Deleting $pageId'..." >&2

local confluenceConfig=$(cat ~/.confluence.json)

# local space=$(echo "$confluenceConfig" | jq -r '.space')
# space=$space
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local atl_token=$(echo "$configJson" | jq -r '.atl_token')

cat << EOL >&2
${COLOR_LIGHT_BLUE}
Configuration:
JSESSIONID=$JSESSIONID
atl_token=$atl_token
${COLOR_NONE}
EOL

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/rest/page-hierarchy/delete' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/json' \\
  -H 'cookie: mywork.tab.tasks=false; PFpreferredHomepage=COJC; newMenusToast=hide; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=lm0o6apv&sl=0&tt=0&ul=1cfvvy&hd=1cfw4m"; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19602%7CMCMID%7C52005780135888792762068795509062624616%7CMCAAMLH-1694257151%7C9%7CMCAAMB-1694257151%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1693659551s%7CNONE%7CvVersion%7C5.5.0; s_cc=true; mbox=PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756897219|session#9a0c0ab51fae4711a58f653bb4c8cee9#1693654279; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1693654218%22}; s_ips=1950; s_plt=0.82; s_pltp=desert%20industries%20home%7Cleaf%20table%20(product); s_tp=3046; s_ppv=desert%2520industries%2520home%257Cleaf%2520table%2520(product)%2C64%2C48%2C48%2C1453%2C3%2C1; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/display/PCP/Standups' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: empty' \\
  -H 'sec-fetch-mode: cors' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw '{"deleteHierarchy":false,"targetPageId":"${pageId}","targetIds":[${pageId}],"atl_token":"${atl_token}"}' \\
  --compressed  
EOL
)

echo "$CMD"

cat << EOL >/dev/tty
${COLOR_RED}
This will permanently delete '$pageTitle' ($pageId).  Are you sure? (Ctrl-c to cancel, 'y' to confirm)
${COLOR_NONE}
EOL

unset ans
# read -qs ans
# read -k ans
read ans < /dev/tty

if [[ $ans =~ y\|Y ]]; then
eval "$CMD"

cat << EOL >&2
${COLOR_GREEN}
Document was deleted '$pageTitle' ($pageId).
${COLOR_NONE}
EOL

else
cat << EOL >&2
${COLOR_YELLOW}
User canceled action
${COLOR_NONE}
EOL
  
fi
}

~/scripts/confluence/fetch-document.sh "$1" | deleteDocument





COMMENT=$(cat << EOL

~/scripts/confluence/delete-document.sh 'Standups 2024-06'

for title in "Standups 2023-10" "Standups 2023-11" "Standups 2023-12" "Standups 2024-01" "Standups 2024-02" "Standups 2024-03" "Standups 2024-04" "Standups 2024-05"; do
for title in "Standups 2023-10"; do
for title in "Standups 2023-11" "Standups 2023-12" "Standups 2024-01" "Standups 2024-02" "Standups 2024-03" "Standups 2024-04" "Standups 2024-05"; do
for title in "Standups 2023-12"  "Standups 2024-02" "Standups 2024-04"; do
~/scripts/confluence/delete-document.sh "$title"
sleep 2
done
~/scripts/confluence/delete-document.sh 'Standups 2024-02'

EOL
)

