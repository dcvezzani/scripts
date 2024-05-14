#!/bin/bash

# =================================== #
# 
# Get Team One standups page
# - uses config from ~/.confluence.json
# 
# Input
# pageId; number: id of confluence document (daily standup note)
# targetTitle; string: name of destination document to where the target document should be moved
# 
# Output
# string; json: should indicate whether the move was successful

function getStandupsPage() {
local confluenceConfig=$(cat ~/.confluence.json)

local space=$(echo "$confluenceConfig" | jq -r '.space')
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local pageId=$(echo "$confluenceConfig" | jq -r '.standup.pageId')

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/display/${space}/Standups?src=breadcrumbs-expanded' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: mywork.tab.tasks=false; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}&moved=true' \\
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

function getStandupPage() {
local confluenceConfig=$(cat ~/.confluence.json)

local space=$(echo "$confluenceConfig" | jq -r '.space')
local JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
local parentPageId=$(echo "$confluenceConfig" | jq -r '.standup.pageId')
local pageId="$1"

cat << EOL >&2
Configuration:
space=$space
JSESSIONID=$JSESSIONID
parentPageId=$parentPageId
pageId=$pageId
EOL

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/plugins/editor-loader/editor.action?parentPageId=${parentPageId}&pageId=${pageId}&spaceKey=${space}&atl_after_login_redirect=%2Fpages%2Fviewpage.action&timeout=12000&_=1693596164850' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: */*' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: mywork.tab.tasks=false; PFpreferredHomepage=COJC; newMenusToast=hide; at_check=true; AMCVS_66C5485451E56AAE0A490D45%40AdobeOrg=1; s_cc=true; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; s_sq=%5B%5BB%5D%5D; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=lm0o6apv&sl=0&tt=0&ul=1cfvvy&hd=1cfw4m"; JSESSIONID=${JSESSIONID}; AMCV_66C5485451E56AAE0A490D45%40AdobeOrg=179643557%7CMCIDTS%7C19602%7CMCMID%7C52005780135888792762068795509062624616%7CMCAAMLH-1694190007%7C9%7CMCAAMB-1694190007%7CRKhpRz8krg2tLO6pguXWp5olkAcUniQYPHaMWWgdJ3xzPWQmdj0y%7CMCOPTOUT-1693592407s%7CNONE%7CvVersion%7C5.5.0; mbox=PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756830853|session#20c5e339a0534a9696c3686e5095d9fa#1693587913; s_ips=1926; s_tp=3429; s_ppv=desert%2520industries%2520home%257Cleaf%2520table%2520(product)%2C56%2C56%2C56%2C1926%2C2%2C1; adcloud={%22_les_v%22:%22y%2Cchurchofjesuschrist.org%2C1693587852%22}; s_plt=16.61; s_pltp=desert%20industries%20home%7Cleaf%20table%20(product)' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}&moved=true' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: empty' \\
  -H 'sec-fetch-mode: cors' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --compressed
EOL
)

eval "$CMD"
}


# =================================== #
# 
# Get atlassian-token
# - by navigating to and scraping the standups page
# - must first have an active JSESSIONID (use cn login '{cookie}')
# 
# Output
# string; json: should indicate whether the move was successful

# function getAtlassianToken() {
#   getStandupsPage 2> /dev/null | ~/scripts/confluence/get-atlassian-token.js
# }

function getAtlassianToken() {
  getStandupPage "$1" 2> /dev/null | ~/scripts/confluence/wrap-with-html-root.js | ~/scripts/confluence/get-atlassian-token.js 'atl_token'
}


getAtlassianToken "$1"
