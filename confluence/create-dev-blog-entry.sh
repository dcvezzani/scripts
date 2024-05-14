#!/bin/bash

# JSESSIONID=BDEFA134019AF7F3CCC32485C64D90A6
# developersBlogPageId=35653536
# space=PCP

# ====================================================
# get confluence config

function loadConfig() {
local confluenceConfig=$(cat ~/.confluence.json)

space=$(echo "$confluenceConfig" | jq -r '.space')
JSESSIONID=$(echo "$confluenceConfig" | jq -r '.JSESSIONID')
MRHSession=$(echo "$confluenceConfig" | jq -r '.MRHSession')
developersBlogPageId=$(echo "$confluenceConfig" | jq -r '.["developers-blog"].pageId')

CMD=$(cat << EOL
#createBlogEntryDraft
space=$space
JSESSIONID=$JSESSIONID
MRHSession=$MRHSession
developersBlogPageId=$developersBlogPageId
EOL
)
if [[ $DEBUG == 'true' ]]; then echo "$CMD" >&2; fi
}

# ====================================================
# create a new draft

function createBlogEntryDraft() {
CMD=$(cat << EOL
#createBlogEntryDraft
space=$space
JSESSIONID=$JSESSIONID
developersBlogPageId=$developersBlogPageId
EOL
)
if [[ $DEBUG == 'true' ]]; then echo "$CMD" >&2; fi

CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/pages/createpage.action?spaceKey=${space}&fromPageId=${developersBlogPageId}&src=quick-create' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: mywork.tab.tasks=false; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}; notice_behavior=implied|us; at_check=true; PFpreferredHomepage=COJC; mbox=session#f6b12b6ee003420799aaf9edb2ee01e7#1692896211|PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756139151; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=llpcpz0k&sl=4&tt=3pb&bcn=%2F%2F17de4c15.akstat.io%2F&ul=17r8x&hd=17r9j"' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${developersBlogPageId}' \
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

if [[ $DEBUG == 'true' ]]; then
eval "$CMD"
else
eval "$CMD" 2> /dev/null
fi
}

# ====================================================
# save a new entry with markdown controls

function saveBlogEntry() {
local draftInfo="$1"

local pageId=$(echo "$draftInfo" | jq -r '.draftId')
local draftShareId=$(echo "$draftInfo" | jq -r '.draftShareId')
local title="$2"

# pageId=163874302
# draftShareId='5623727c-0179-4903-bd23-b2b205689ab8'
# title='Arp Current Use Of Church Account Service'

CMD=$(cat << EOL
#saveBlogEntry
draftInfo="$draftInfo"
space="$space"
JSESSIONID="$JSESSIONID"
developersBlogPageId="$developersBlogPageId"
pageId="$pageId"
draftShareId="$draftShareId"
title="$title"
EOL
)
if [[ $DEBUG == 'true' ]]; then echo "$CMD" >&2; fi

CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/rest/api/content/${pageId}?status=draft' \\
  -X 'PUT' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/json; charset=UTF-8' \\
  -H 'cookie: mywork.tab.tasks=false; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}; notice_behavior=implied|us; at_check=true; PFpreferredHomepage=COJC; mbox=session#f6b12b6ee003420799aaf9edb2ee01e7#1692896211|PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756139151; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=llpcpz0k&sl=4&tt=3pb&bcn=%2F%2F17de4c15.akstat.io%2F&ul=17r8x&hd=17r9j"' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/resumedraft.action?draftId=${pageId}&draftShareId=${draftShareId}&' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: empty' \\
  -H 'sec-fetch-mode: cors' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw $'{"status":"current","title":"${title}","space":{"key":"${space}"},"body":{"editor":{"value":"<p class=\\\\\"auto-cursor-target\\\\\"><br /></p><table class=\\\\\"wysiwyg-macro\\\\\" style=\\\\\"background-image: url(\'https://confluence.churchofjesuschrist.org/plugins/servlet/confluence/placeholder/macro-heading?definition=e21hcmtkb3dufQ&amp;locale=en_US&amp;version=2\'); background-repeat: no-repeat;\\\\\" data-macro-name=\\\\\"markdown\\\\\" data-macro-schema-version=\\\\\"1\\\\\" data-macro-body-type=\\\\\"PLAIN_TEXT\\\\\" data-mce-resize=\\\\\"false\\\\\"><tbody><tr><td class=\\\\\"wysiwyg-macro-body\\\\\"><pre>xxx</pre></td></tr></tbody></table><p><br /></p>","representation":"editor","content":{"id":"${pageId}"}}},"id":"${pageId}","type":"page","version":{"number":1,"minorEdit":true,"syncRev":"0.aBZ1yG2qRzpzWmVX0gCPFkE.5"},"ancestors":[{"id":"${developersBlogPageId}","type":"page"}]}' \\
  --compressed
EOL
)

if [[ $DEBUG == 'true' ]]; then
  eval "$CMD"
else
  eval "$CMD" >/dev/null 2>&1
fi
}


# ====================================================
# get details for next draft (in prep for editing)

function getNextBlogEntryDraftDetails() {
local draftInfo="$1"

local pageId=$(echo "$draftInfo" | jq -r '.draftId')

CMD=$(cat << EOL
#getNextBlogEntryDraftDetails
draftInfo="$draftInfo"
space="$space"
JSESSIONID="$JSESSIONID"
developersBlogPageId="$developersBlogPageId"
pageId="$pageId"
EOL
)
if [[ $DEBUG == 'true' ]]; then echo "$CMD" >&2; fi

CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/plugins/editor-loader/editor.action?parentPageId=${developersBlogPageId}&pageId=${pageId}&spaceKey=${space}' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: */*' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: mywork.tab.tasks=false; BIGipServerpool_confluence.churchofjesuschrist.org_HTTP=728251658.37151.0000; JSESSIONID=${JSESSIONID}; notice_behavior=implied|us; at_check=true; PFpreferredHomepage=COJC; mbox=session#f6b12b6ee003420799aaf9edb2ee01e7#1692896211|PC#f6b12b6ee003420799aaf9edb2ee01e7.35_0#1756139151; RT="z=1&dm=churchofjesuschrist.org&si=26dd1207-2d96-4696-9f76-f8faf968a566&ss=llpcpz0k&sl=4&tt=3pb&bcn=%2F%2F17de4c15.akstat.io%2F&ul=17r8x&hd=17r9j"' \\
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
  --compressed
EOL
)

if [[ $DEBUG == 'true' ]]; then
eval "$CMD"
else
eval "$CMD" 2> /dev/null
fi
}

# ====================================================
# open blog entry in edit mode (in browser)

function editBlogEntry() {
local draftInfo="$1"

local draftId=$(echo "$draftInfo" | jq -r '.draftId')
local draftShareId=$(echo "$draftInfo" | jq -r '.draftShareId')

CMD=$(cat << EOL
#editBlogEntry
draftInfo="$draftInfo"
draftShareId="$draftShareId"
draftId="$draftId"
EOL
)
if [[ $DEBUG == 'true' ]]; then echo "$CMD" >&2; fi

open "https://confluence.churchofjesuschrist.org/pages/resumedraft.action?draftId=${draftId}&draftShareId=${draftShareId}"
}

function createAndEditNewBlogEntry() {
local title="$1"

loadConfig
local draftInfo=$(createBlogEntryDraft | ~/scripts/confluence/get-atlassian-token.js 'draftId:draftShareId')
if [[ $DEBUG == 'true' ]]; then jq -n "$draftInfo" >&2; fi

saveBlogEntry "$draftInfo" "$title"
local draftInfo_02=$(getNextBlogEntryDraftDetails "$draftInfo" | ~/scripts/confluence/get-atlassian-token.js 'draftId')
if [[ $DEBUG == 'true' ]]; then jq -n "$draftInfo_02" >&2; fi

local draftInfo_03=$(jq -n "${draftInfo} * ${draftInfo_02}")
if [[ $DEBUG == 'true' ]]; then jq -n "$draftInfo_03" >&2; fi

editBlogEntry "$draftInfo_03"
}

