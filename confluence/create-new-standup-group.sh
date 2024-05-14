#!/bin/zsh

source ~/scripts/colors.sh

# =================================== #
# 
# Create draft document
# - first step in creating a document
# 
# Input
# none
# 
# Output
# string; json: values for draftId and draftShareId

function createDraftDocument() {
echo "Creating new draft document..." >&2
  
local confluenceConfig=$(cat ~/.confluence.json)

local space=$(echo "$confluenceConfig" | jq -r '.space')
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local parentPageId=$(echo "$confluenceConfig" | jq -r '.standup.pageId')
# local atl_token=$(~/scripts/confluence/get-atlassian-token.sh $pageId | jq -r '.atl_token')
# atl_token=$atl_token
cat <<EOL >&2
${COLOR_LIGHT_BLUE}
Configuration:
JSESSIONID=$JSESSIONID
parentPageId=$parentPageId
space=$space
${COLOR_NONE}
EOL
  
local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/pages/createpage.action?spaceKey=${space}&fromPageId=${parentPageId}&src=quick-create' \
  -H 'authority: confluence.churchofjesuschrist.org' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'cookie: mywork.tab.tasks=false; PFpreferredHomepage=COJC; newMenusToast=hide; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; s_cc=true; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; s_sq=%5B%5BB%5D%5D; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=lm0o6apv&sl=0&tt=0&ul=1cfvvy&hd=1cfw4m"; JSESSIONID=${JSESSIONID}; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19602%7CMCMID%7C52005780135888792762068795509062624616%7CMCAAMLH-1694190007%7C9%7CMCAAMB-1694190007%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1693592407s%7CNONE%7CvVersion%7C5.5.0; mbox=PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756830853|session#20c5e339a0534a9696c3686e5095d9fa#1693587913; s_ips=1926; s_tp=3429; s_ppv=desert%2520industries%2520home%257Cleaf%2520table%2520(product)%2C56%2C56%2C56%2C1926%2C2%2C1; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1693587852%22}; s_plt=16.61; s_pltp=desert%20industries%20home%7Cleaf%20table%20(product)' \
  -H 'pragma: no-cache' \
  -H 'referer: https://confluence.churchofjesuschrist.org/display/${space}/Standups' \
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \
  --compressed
EOL
)

HTML=$(eval "$CMD" 2> /dev/null)

echo "$HTML" | ~/scripts/confluence/get-atlassian-token.js 'draftId:draftShareId'

# draftId:draftShareId

#   getStandupPage "$1" 2> /dev/null | ~/scripts/confluence/wrap-with-html-root.js | ~/scripts/confluence/get-atlassian-token.js 'atl_token'

    # <input id="draftId" type="hidden" name="draftId" value="163876984">
    # <input id="draftShareId" type="hidden" name="draftShareId" value="c714195d-e3a8-407c-b9ca-f3dee5405f48">
}

# =================================== #
# 
# Show usage for createStandupGroup
# 
# Input
# none
# 
# Output
# string: help documentation

function createStandupGroup_usage() {
cat << 'EOL'
${COLOR_YELLOW}
Usage: createStandupGroup <pageTitle>

E.g., 
pageTitle='Standups+2023-09'
configJson='{"draftId":"163877089","draftShareId":"368abf77-5739-42c9-907c-3c7e2a8e5020"}'
createStandupGroup "$pageTitle" "$configJson"

or

createDraftDocument | createStandupGroup "$pageTitle"
${COLOR_NONE}
EOL
}

# =================================== #
# 
# Create new standup group
# 
# Input
# pageTitle; string: name of standup group; typically of the format, 'Standups 2023-09'
# configJson; string (json): draftId and draftShareId values scraped from #createDraftDocument
# 
# Output
# string (json): results of attempting to create new document

function createStandupGroup() {
local pageTitle="$1"
local configJson="$2"

if [[ -z $pageTitle ]]; then
  createStandupGroup_usage
  return
fi

if [[ -z $configJson ]]; then
  read configJson
fi

cat << EOL >&2
${COLOR_LIGHT_CYAN}
Inputs:
pageTitle=$pageTitle
configJson=$configJson
${COLOR_NONE}
EOL

if [[ -z $configJson ]]; then
  createStandupGroup_usage
  return
fi

echo "Creating new standups group: '$pageTitle'..." >&2
  
local confluenceConfig=$(cat ~/.confluence.json)

local space=$(echo "$confluenceConfig" | jq -r '.space')
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local parentPageId=$(echo "$confluenceConfig" | jq -r '.standup.pageId')

local draftId=$(echo "$configJson" | jq -r '.draftId')
local draftShareId=$(echo "$configJson" | jq -r '.draftShareId')

# local atl_token=$(~/scripts/confluence/get-atlassian-token.sh $pageId | jq -r '.atl_token')

cat << EOL >&2
${COLOR_LIGHT_BLUE}
Configuration:
JSESSIONID=$JSESSIONID
parentPageId=$parentPageId
space=$space
draftId=$draftId
draftShareId=$draftShareId
pageTitle=$pageTitle
${COLOR_NONE}
EOL
  

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/rest/api/content/${draftId}?status=draft' \\
  -X 'PUT' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/json; charset=UTF-8' \\
  -H 'cookie: mywork.tab.tasks=false; PFpreferredHomepage=COJC; newMenusToast=hide; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; s_cc=true; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; s_sq=%5B%5BB%5D%5D; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=lm0o6apv&sl=0&tt=0&ul=1cfvvy&hd=1cfw4m"; JSESSIONID=${JSESSIONID}; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19602%7CMCMID%7C52005780135888792762068795509062624616%7CMCAAMLH-1694190007%7C9%7CMCAAMB-1694190007%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1693592407s%7CNONE%7CvVersion%7C5.5.0; mbox=PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756830853|session#20c5e339a0534a9696c3686e5095d9fa#1693587913; s_ips=1926; s_tp=3429; s_ppv=desert%2520industries%2520home%257Cleaf%2520table%2520(product)%2C56%2C56%2C56%2C1926%2C2%2C1; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1693587852%22}; s_plt=16.61; s_pltp=desert%20industries%20home%7Cleaf%20table%20(product)' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/resumedraft.action?draftId=${draftId}&draftShareId=${draftShareId}&' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: empty' \\
  -H 'sec-fetch-mode: cors' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw '{"status":"current","title":"${pageTitle}","space":{"key":"${space}"},"body":{"editor":{"value":"<p><img class=\"editor-inline-macro\" src=\"https://confluence.churchofjesuschrist.org/plugins/servlet/confluence/placeholder/macro?definition=e2NoaWxkcmVufQ&amp;locale=en_US&amp;version=2\" data-macro-name=\"children\" data-macro-schema-version=\"2\" /></p>","representation":"editor","content":{"id":"${draftId}"}}},"id":"${draftId}","type":"page","version":{"number":1,"minorEdit":true,"syncRev":"0.ur5KKFpdh2yqNFs3AdT21Oo.11"},"ancestors":[{"id":"${parentPageId}","type":"page"}]}' \\
  --compressed
EOL
)

# echo "$CMD"
JSON=$(eval "$CMD" 2> /dev/null)
statusCode=$(echo "$JSON" | jq -r '.statusCode')

if ( [[ ! -z $statusCode ]] && [[ $statusCode != 'null' ]] ); then
cat << EOL >&2
${COLOR_RED}
Something went wrong and the requested document was not created
${COLOR_NONE}
EOL
else 
JSON=$(echo "$JSON" | jq -c '. * {"pageUrl":"https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId='"${draftId}"'"}')
pageUrl=$(echo "$JSON" | jq -r '.pageUrl')
cat << EOL >&2
${COLOR_GREEN}
Yay! Document was created
${pageUrl}
${COLOR_NONE}
EOL
fi
}

createDraftDocument | createStandupGroup "$1"








COMMENT=$(cat << EOL

source /Users/dcvezzani/scripts/confluence/create-new-standup-group.sh
createDraftDocument

/Users/dcvezzani/scripts/confluence/create-new-standup-group.sh 'Standups 2024-03'

EOL
)

