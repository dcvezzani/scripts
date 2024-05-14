#!/bin/bash

# This file is meant to be sourced from the terminal command line
# - functions should then be available in the terminal session
# - and called individually as needed

# ====================== #
#
# Gets token from [/members resource](https://github.com/orgs/ICSEng/teams/csp-church-education/members)
#   - there may be multiple instances of this token in the html body
#   - I'm guessing each protected action on the page has it's own associated token

# Input
# team; string: GitHub team name (e.g., 'csp-temples')

# Output
# authenticity_token; string: necessary to perform the POST action (i.e., adding a new team member)

function getAuthenticityToken() {
local team="$1"

local CMD=$(cat << EOL
curl 'https://github.com/orgs/ICSEng/teams/${team}/members' \\
  -H 'authority: github.com' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: ${cookie}' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://github.com/orgs/ICSEng/teams/${team}' \\
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

local html=$(eval "$CMD" 2> /dev/null)
echo "$html" > get-members.html
echo "$html" | ~/scripts/github/scrape-authenticity-token.js
}

# ====================== #
#
# Adds user to team
#
# Input
# team; string: GitHub team name (e.g., 'csp-temples')
# member; string: GitHub username associated with the new team member being added
# authenticity_token; string: necessary to perform *this* POST action
#
# Output
# - html output indicates something went wrong
# - if nothing is echoed to the terminal, the call was successful

function addMember() {
local team="$1"
local member="$2"
local authenticity_token="$3"

local CMD=$(cat << EOL
curl 'https://github.com/orgs/ICSEng/teams/${team}/members' \\
  -H 'authority: github.com' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/x-www-form-urlencoded' \\
  -H 'cookie: ${cookie}' \\
  -H 'origin: https://github.com' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://github.com/orgs/ICSEng/teams/${team}' \\
  -H 'sec-ch-ua: "Chromium";v="116", "Not)A;Brand";v="24", "Google Chrome";v="116"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: document' \\
  -H 'sec-fetch-mode: navigate' \\
  -H 'sec-fetch-site: same-origin' \\
  -H 'sec-fetch-user: ?1' \\
  -H 'upgrade-insecure-requests: 1' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36' \\
  --data-raw 'authenticity_token=${authenticity_token}&member=${member}' \\
  --compressed
EOL
)

eval "$CMD"
}
#
