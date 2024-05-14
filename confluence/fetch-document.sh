#!/bin/zsh

source ~/scripts/colors.sh

# =================================== #
# 
# Fetch document
# 
# Input
# pageId; number: id of confluence document to be fetched
# 
# Output
# string; json: should indicate whether the fetch was successful

function fetchDocument() {
local configJson="$1"

if [[ -z $configJson ]]; then
cat << 'EOL'
Usage: fetchDocument <configJson>

E.g., 
configJson='{"pageId":"150803434"}'
configJson='{"pageTitle":"Standups 2024-06"}'
fetchDocument "$configJson"
EOL
  return
fi

if [[ ! $configJson =~ ^\{ ]]; then
  if [[ $configJson =~ ^\d+$ ]]; then
    configJson="{\"pageId\":${configJson}}"
  else
    configJson="{\"pageTitle\":\"${configJson}\"}"
  fi
fi

local pageId=$(echo "$configJson" | jq -r '.pageId')
local pageTitle=$(echo "$configJson" | jq -r '.pageTitle' | jq -Rr @uri)

local argType=pageId
if [[ ! -z $pageTitle ]]; then
local argType=pageTitle
fi

cat << EOL >&2
${COLOR_LIGHT_CYAN}
Inputs:
configJson=$configJson
pageId=$pageId
pageTitle=$pageTitle
argType=$argType
${COLOR_NONE}
EOL

if [[ $argType == 'pageId' ]]; then
echo "Fetching $pageId..." >&2
else
echo "Fetching $pageTitle..." >&2
fi
  
local confluenceConfig=$(cat ~/.confluence.json)

# local space=$(echo "$confluenceConfig" | jq -r '.space')
# space=$space
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
# local atl_token=$(~/scripts/confluence/get-atlassian-token.sh $pageId | jq -r '.atl_token')
# atl_token=$atl_token

cat << EOL >&2
${COLOR_LIGHT_BLUE}
Configuration:
JSESSIONID=$JSESSIONID
${COLOR_NONE}
EOL

if [[ $argType == 'pageId' ]]; then
local url="https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}"
else
local url="https://confluence.churchofjesuschrist.org/display/PCP/${pageTitle}"
fi

local CMD=$(cat << EOL
curl '${url}' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: mywork.tab.tasks=false; PFpreferredHomepage=COJC; newMenusToast=hide; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=lm0o6apv&sl=0&tt=0&ul=1cfvvy&hd=1cfw4m"; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19602%7CMCMID%7C52005780135888792762068795509062624616%7CMCAAMLH-1694257151%7C9%7CMCAAMB-1694257151%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1693659551s%7CNONE%7CvVersion%7C5.5.0; s_cc=true; mbox=PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756897219|session#9a0c0ab51fae4711a58f653bb4c8cee9#1693654279; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1693654218%22}; s_ips=1950; s_plt=0.82; s_pltp=desert%20industries%20home%7Cleaf%20table%20(product); s_tp=3046; s_ppv=desert%2520industries%2520home%257Cleaf%2520table%2520(product)%2C64%2C48%2C48%2C1453%2C3%2C1; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/display/PCP/Standups' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: document' \\
  -H 'sec-fetch-mode: navigate' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'sec-fetch-user: ?1' \\
  -H 'upgrade-insecure-requests: 1' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  --compressed
EOL
)

eval "$CMD"
}

fetchDocument "$1" 2> /dev/null | ~/scripts/confluence/get-atlassian-token.js 'atl_token:pageId'




COMMENT=$(cat << EOL

/Users/dcvezzani/scripts/confluence/fetch-document.sh 'Standups 2024-06'

EOL
)


