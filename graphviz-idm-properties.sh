#!/bin/bash

# ===============================================
# ===============================================
# ===============================================
function parseMethods() {
  local topic="$1"
  local content="$2"
  local extra="$3"

  echo "{\"${topic}\": ["
  local cnt=0; echo -e "$content" | while read -r line;
  do
     local methodName=$(echo "$line" | perl -pe 's/^([^, ]+).*/${1}/')
     local methodArgs=''

     if [[ "$line" =~ , ]]; then
       local methodArgs=$(echo "$line" | perl -pe 's/^[^,]+,?(.*)/${1}/; s/[ ;]*$//g')
     fi

     local functionDetails="\"methodName\": \"${methodName}\", \"methodArgs\": \"${methodArgs}\", \"description\": \"Description\""

     if [ "$extra" = "" ]; then
       echo "{$functionDetails}, ";
     else
       echo "{$functionDetails, $extra}, ";
     fi
     ((cnt++))
  done
  echo "{}]}"
};

# ===============================================
function parseConfig() {
  local jqPath="$1"
  local target="$2"

local targetLabel=''
local jqFullPath="$jqPath"
if [ ! "$target" = "" ]; then 
  local jqFullPath="${jqPath}.${target}"
  local targetLabel="${target}."
fi


cmd=$(cat << EOL
cat /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/constants.json | jq 'def targetLabel(prop): prop as \$prop | "$targetLabel"+\$prop; .${jqFullPath} as \$obj | \$obj | keys | map({ name: targetLabel(.), sampleValue: \$obj[.], description: "Description" }) as \$payload | [{key:"$jqPath", value: \$payload}] | from_entries'
EOL
)

(echo -e "${cmd}\n" 1>&2)
eval "$cmd"

}

# ===============================================
function parseConfigCookie() {
  # local head="$1"
  local head="oauth.cookie"

cmd=$(cat << EOL
echo "\$(parseConfig 'oauth.cookie')" | jq 'def includes(token): token as \$token | ["identity", "tokens"] | map(\$token == .) | any | not; .["${head}"] as \$head | \$head | map(.name) | map(select(includes(.))) | (reduce . as \$key ([]; . + (\$head | map(select(.name == "COOKIE_EXPIRATION_OFFSET"))) )) as \$payload | [{key:"${head}",value:\$payload}] | from_entries'
EOL
)



# cmd=$(cat << EOL
# echo "\$(parseConfig 'oauth.cookie')" | jq 'def includes(token): token as \$token | ["identity", "tokens"] | map(\$token == .) | any | not; .["${head}"] as \$head | \$head | keys | map(select(includes(.))) | map({ name: ., sampleValue: \$head[.], description: "Description" })  as \$payload | [{key:"${head}",value:\$payload}] | from_entries'
# EOL
# )



(echo -e "${cmd}\n" 1>&2)
eval "$cmd"
}

# ===============================================
function processMethods() {

usage=$(cat << EOL
Usage: processMethods <groupLabel> <reLineSelector> <filename>

processMethods oauth '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/index.js
processMethods middleware '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/express-middleware/index.js

EOL
)

  local groupLabel="$1"
  local reLineSelector="$2"
  local filename="$3"

  # local groupLabel='oauth'
  # local reLineSelector='^  payload.'
  # local filename='/Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/index.js'

  # local groupLabel='route-helpers'
  # local reLineSelector='^  payload.'
  # local filename='/Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/route-helpers.js'
  
  # local groupLabel='okta'
  # local reLineSelector='^  payload.'
  # local filename='/Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/route-helpers.js'
  
  if [ "$groupLabel" = "" ]; then echo -e "$usage"; return; fi
  if [ "$reLineSelector" = "" ]; then echo -e "$usage"; return; fi
  if [ "$filename" = "" ]; then echo -e "$usage"; return; fi

  local lines=$(cat "$filename" | grep -E "$reLineSelector" | perl -pe "s/$reLineSelector//g")

  local re='s/=>? \(req, res, next\)//g; s/=> \{.*//g; s/require\([^\)]*\)//g; s/ = /,/g'

  local syncFuncs=$(echo -e "$lines" | grep -v async | perl -pe "$re")
  local asyncFuncs=$(echo -e "$lines" | grep async | perl -pe "s/async {0,1}//g; $re")
    
cmd=$(cat << EOL
{"groupLabel": "$groupLabel", "sync": $(parseMethods "$groupLabel" "$syncFuncs" | jq -rc ".[\"${groupLabel}\"]"), "async": $(parseMethods "$groupLabel" "$asyncFuncs" "\"async\": \"true\"" | jq -rc ".[\"${groupLabel}\"]")}
EOL
)

(echo -e "${cmd}\n" 1>&2)

cmd=$(cat << EOL
  echo "$(echo "$cmd" | perl -pe 's/"/\\"/g')" | jq -rc '. as \$input | \$input.sync + \$input.async | map(select(.methodName and .methodName != "")) as \$payload | [{key:\$input.groupLabel,value:\$payload}] | from_entries'
EOL
)

(echo -e "${cmd}\n" 1>&2)
eval "$cmd"

}


# ===============================================
cookie=$(echo "[$(parseConfig 'oauth.cookie' tokens), $(parseConfig 'oauth.cookie' identity), $(parseConfigCookie)]" | jq 'map(.["oauth.cookie"]) | (reduce . as $item ([]; . + $item)) | flatten as $payload | [{key:"oauth.cookie",value:$payload}] | from_entries')

routes=$(echo "[$(parseConfig 'oauth.routes')]" | jq -rc 'map(.["oauth.routes"]) | flatten as $payload | [{key:"oauth.routes",value:$payload}] | from_entries')

resources=$(echo "[$(parseConfig 'oauth.app.resources')]" | perl -pe 's/\\/{escape}/g' | jq -rc 'map(.["oauth.app.resources"]) | flatten as $payload | [{key:"oauth.app.resources",value:$payload}] | from_entries')

config=$(echo "{\"config\": [${cookie}, ${routes}, ${resources}]}")

oauth=$(processMethods oauth '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/index.js)

okta=$(processMethods okta '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/okta.js)
oktaDevTenant=$(processMethods oktaDevTenant '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/oktaDevTenant.js)
forgerock=$(processMethods forgerock '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/forgerock.js)

requests=$(processMethods requests '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/oauth/requests.js)

oauth=$(echo "{\"oauth\": [${oauth}, ${requests}, ${okta}, ${oktaDevTenant}, ${forgerock}]}")

middleware=$(processMethods middleware '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/express-middleware/index.js)

cookies=$(processMethods cookies '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/cookies.js)

routeHelpers=$(processMethods "route-helpers" '^  payload.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/route-helpers.js)

util=$(processMethods "util" '^module.exports.' /Users/dcvezzani/projects/@churchofjesuschrist/idm-oauth/src/util.js)



echo "[${config}, ${oauth}, ${middleware}, ${cookies}, ${routeHelpers}, ${util}]" | jq '(reduce .[] as $item ({}; . + $item))'
