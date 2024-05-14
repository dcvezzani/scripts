# ==================================
requestConstants() {
jq -c '.' <<<'
{
  "spaceKey":"PCP",
  "position":"append",
  "mode":"ASYNC"
}'
}

# ==================================
verifyJsessionId() {
usage="$1"

if [[ -z $JSESSIONID ]]; then
cat << EOL 1>&2
$usage

Note: you can also export the environment variable for your terminal session so you don't have to specify it explicitly
export JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60
EOL
return 1
fi
echo "Using JSESSIONID: $JSESSIONID\n"
}

# ==================================
_viewPage() {
echo "Running: _viewPage..." 1>&2
pageId="$1"

local usage=$(cat << EOL
Usage: JSESSIONID=<session-id> viewPage <pageId>
- e.g., JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60 viewPage 142972894
EOL
)

verifyJsessionId "$usage" 1>&2
if [[ $? != 0 ]]; then return; fi

if [[ -z $pageId ]]; then echo "$usage" 1>&2; return 1; fi

local constants=$(requestConstants)
local spaceKey=$(echo -n "$constants" | jq '.spaceKey')

CMD=$(cat << EOL
# view page
curl 'https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=$pageId' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'cache-control: no-cache' \\
  -H 'cookie: JSESSIONID=$JSESSIONID' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/display/PCP/Standups' \\
  -H 'upgrade-insecure-requests: 1' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \\
  --compressed \\
  | perl -n -e '/"atlassian-token"/ && print' | perl -p -e 's/^.*content="//; s/".*//'
EOL
)

if [[ $DEBUG == 'view' ]]; then
  echo "$CMD" 1>&2
  echo "{\"message\":\"Unable to view page ($pageId) and/or extract value for 'atl_token'\",\"code\":1}"
else
  local atl_token=$(eval "$CMD")
  echo -n "{\"atl_token\":\"$atl_token\"}"
fi
}

# ==================================
getAtlToken() {
pageId="$1"

local usage=$(cat << EOL
Usage: JSESSIONID=<session-id> getAtlToken <pageId>
- e.g., JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60 getAtlToken 142972894
EOL
)

verifyJsessionId "$usage" 1>&2
if [[ $? != 0 ]]; then return; fi

if [[ -z $pageId ]]; then echo "$usage" 1>&2; return 1; fi

_viewPage $pageId; return $?
}


# ==================================
_movePage() {
echo "Running: _movePage..." 1>&2
local arguments="$1"

local usage=$(cat << EOL
Usage: JSESSIONID=<session-id> _movePage '{"pageId":<pageId>,"targetTitle":"<targetTitle>","atl_token":"<atl_token>"}'

<pageId> <targetTitle>
- e.g., JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60 _movePage '{"pageId":142972894,"targetTitle":"Standups+2023-04","atl_token":"a373705ce0856e60bd4729f7e722433add53c4d4"}'
EOL
)

verifyJsessionId "$usage" 1>&2
if [[ $? != 0 ]]; then return; fi

if [[ -z $arguments ]]; then echo "$usage" 1>&2; return 1; fi

local pageId=$(echo -n "$arguments" | jq -r '.pageId'); if [[ $? > 0 ]]; then return 1; fi
local targetTitle=$(echo -n "$arguments" | jq -r '.targetTitle'); if [[ $? > 0 ]]; then return 1; fi
local atl_token=$(echo -n "$arguments" | jq -r '.atl_token'); if [[ $? > 0 ]]; then return 1; fi

if [[ -z $pageId ]] || [[ -z $targetTitle ]] || [[ -z $atl_token ]]; then echo "$usage" 1>&2; return 1; fi

local constants=$(requestConstants)
local spaceKey=$(echo -n "$constants" | jq -r '.spaceKey'); if [[ $? > 0 ]]; then return 1; fi
local position=$(echo -n "$constants" | jq -r '.position'); if [[ $? > 0 ]]; then return 1; fi
local mode=$(echo -n "$constants" | jq -r '.mode'); if [[ $? > 0 ]]; then return 1; fi

CMD=$(cat << EOL
# move page to new location
curl 'https://confluence.churchofjesuschrist.org/pages/movepage.action' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \\
  -H 'cookie: JSESSIONID=$JSESSIONID' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=$pageId' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw 'pageId=$pageId&spaceKey=$spaceKey&targetTitle=$targetTitle&position=$position&mode=$mode&atl_token=$atl_token' \\
  --compressed
  # --output move-page-$pageId.json
EOL
)

if [[ $DEBUG == 'move' ]]; then
  echo "$CMD" 1>&2
  echo "{\"code\":1}"
  echo "{\"message\":\"Unable to move page ($pageId) to parent, '$targetTitle'\",\"code\":1}"
else
  local responsePayload=$(eval "$CMD")
  echo "$responsePayload" | jq -c '.'
fi
}


# ==================================
movePage() {
local pageId="$1"
local targetTitle="$2"

local usage=$(cat << EOL
Usage: JSESSIONID=<session-id> movePage <pageId> <targetTitle>
- e.g., JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60 movePage 142972894 Standups+2023-04
EOL
)

verifyJsessionId "$usage" 1>&2
if [[ $? != 0 ]]; then return; fi

if [[ -z $pageId ]] || [[ -z $targetTitle ]]; then echo "$usage" 1>&2; return 1; fi

local responsePayload=$(getAtlToken $pageId)
local responseCode=$(echo "$responsePayload" | jq '.code')
if [[ $responseCode != 'null' ]] && [[ $responseCode > 0 ]]; then return $responseCode; fi

local atl_token=$(echo "$responsePayload" | jq -r '.atl_token'); if [[ $? > 0 ]]; then return $?; fi

echo $atl_token

if [[ -z $atl_token ]]; then echo "'atl_token' is required; did #viewPage return expected content?" 1>&2; return 1; fi
 
local movePageArgs=$(cat << EOL
{"pageId":$pageId,"targetTitle":"$targetTitle","atl_token":"$atl_token"}
EOL
)

_movePage "$movePageArgs"
# local responsePayload=$(_movePage "$movePageArgs")
# local responseCode=$(echo "$responsePayload" | jq '.code')
# if [[ $responseCode != 'null' ]] && [[ $responseCode > 0 ]]; then return $responseCode; fi
}


# ==================================
cat << EOL
Utilities to move files in Confluence

Usage:
source ~/scripts/confluence-publishing/load-move-file-functions.sh
export JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60

Available functions:
- getAtlToken
- movePage

Options
- DEBUG=view
- DEBUG=move

EOL


# ==================================
# ==================================

hidden=$(cat << 'EOL'
JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60
pageId=142972890
spaceKey=PCP
targetTitle=Standups+2023-04
position=append
mode=ASYNC
atl_token=a373705ce0856e60bd4729f7e722433add53c4d4

CMD=$(cat << EOL2
# move page to new location
curl 'https://confluence.churchofjesuschrist.org/pages/movepage.action' \\
  -H 'authority: confluence.churchofjesuschrist.org' \\
  -H 'accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'accept-language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'cache-control: no-cache' \\
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \\
  -H 'cookie: JSESSIONID=$JSESSIONID' \\
  -H 'origin: https://confluence.churchofjesuschrist.org' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=$pageId' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36' \\
  -H 'x-requested-with: XMLHttpRequest' \\
  --data-raw 'pageId=$pageId&spaceKey=$spaceKey&targetTitle=$targetTitle&position=$position&mode=$mode&atl_token=$atl_token' \\
  --compressed \\
  --output move-page-$pageId.json
EOL2
)

eval "$CMD"

atl_token=$(eval "$CMD")

cat << EOL2
atl_token=$atl_token
EOL2
  


JSESSIONID=98AC0CF5FCD3E28FE88602C1B05D5C60 
pageId=142973472

EOL
)
