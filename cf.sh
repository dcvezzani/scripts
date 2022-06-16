#!/bin/bash

# =======================================
function cfSupportedTargets () {
  cat /Users/dcvezzani/scripts/config/cf.json | jq -r '. | keys | join(", ")'
}

# =======================================
function cflogin () {
cat << EOL
You can login ahead of time before requesting a one-time password.

https://ui.pvu.cf.churchofjesuschrist.org/#/ApplicationManagement
EOL

cf login --sso -a api.pvu.cf.churchofjesuschrist.org -u dcvezzani
}

# =======================================
function cfresolve () {
target="$1"
lane="$2"
tier="$3"
if [ "$tier" = "" ]; then
  echo "Usage: cfresolve cha test ws"
  return
fi

local _org=""
local _space=""
local _app=""

case "$target" in

  referrals | si | arp | cha | temples | memcache | thrasher | planning)
    _org=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.org')
    _space=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.space')
    _app=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.'"$tier"'.app')
    _appAmId=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.'"$tier"'.applicationManagementId')
    _url="https://ui.pvu.cf.churchofjesuschrist.org/#/Apps?orgId=$(url_encode "$_org")&spaceId=${_space}"
    # _appUrl="https://ui.pvu.cf.churchofjesuschrist.org/#/Apps/${_appAmId}?orgId=$(url_encode "$_org")&spaceId=${_space}#appsection"

    if [ ! "$_appAmId" = "null" ]; then
    _appUrl="https://ui.pvu.cf.churchofjesuschrist.org/#/Apps/${_appAmId}?$(url_encode "orgId=${_org}&spaceId=${_space}#appsection")"
    fi
    ;;

  *)
    echo "{\"error\":true,\"message\":\"Invalid target: ${$target}\"}"
    return
    ;;
esac

payload=("\"org\":\"$_org\",\"space\":\"$_space\",\"target\":\"$_app\",\"url\":\"$_url\"")
if [ ! "$_appAmId" = "null" ]; then
  payload+=(\"appUrl\":\"$_appUrl\")
fi

echo "{$(IFS=,; printf '%s' "${payload[*]}")}"
}

# =======================================
function url_encode() {
  usage=$(cat << EOL
Usage: 
url_encode "Communication Services"
EOL
)

  term="$1"

  if [ "$term" = "" ]; then echo -e "$usage" 1>&2; fi
  
  echo -n "$term" | perl -pe 's/[^a-zA-Z0-9\/_.~-]/sprintf "%%%02x", ord($&)/ge'
};

# =======================================
function cf_target() {
  usage=$(cat << EOL
Usage: 
cf_target
EOL
)

  # if [ "$meta" = "" ]; then echo "$usage"; return; fi

  local payload=$(cf target)

  local org=''
  local space=''
  local url=''

  local org=$(echo "$payload" | grep -E '^org:')
  local space=$(echo "$payload" | grep -E '^space:')

  if [ ! "$org" = "" ]; then
    local orgValue=$(echo "$org" | perl -p -e 's/^[^:]+: +(.*)/${1}/')
  fi

  if [ ! "$space" = "" ]; then
    local spaceValue=$(echo "$space" | perl -p -e 's/^[^:]+: +(.*)/${1}/')
  fi

  if ( [ ! "$org" = "" ] && [ ! "$space" = "" ] ); then
    local encodedOrgValue=$(url_encode "$orgValue")
    local urlValue="https://ui.pvu.cf.churchofjesuschrist.org/#/Apps?orgId=${encodedOrgValue}&spaceId=${spaceValue}"
  fi

  echo "{\"org\":\"$orgValue\",\"space\":\"$spaceValue\",\"url\":\"$urlValue\"}"
  
  # value=$(echo "$line" | awk '{split($0, array); print array[2]}')
  # echo -e "$value"
}

# =======================================
function cftarget () {
  if ( [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] ); then cf_target; return; fi

  target="$1"
  lane="$2"
  tier="$3"

  # echo $(cfresolve "$target")
  local cfconfig=$(cfresolve "$target" "$lane" "$tier")
  local _org=$(echo "$cfconfig" | jq -r '.org')
  local _space=$(echo "$cfconfig" | jq -r '.space')
  local _target=$(echo "$cfconfig" | jq -r '.target')

  cf target -o "$_org" -s "$_space" >/dev/null
  responseCode="$?"

  if [[ $responseCode > 0 ]]; then
    echo "Unable to change to target: ${cfconfig}" >&2
    return
  fi

  echo "$cfconfig"
}

# =======================================
function cfcli () {
local cmd="$4"
if [ "$cmd" = "" ]; then
  echo "Usage: cfcli {target} {lane} {tier} {command}"
  echo "E.g., cfcli cha test ws logs"
  return
fi

# remove command at the end from the list of arguments
set -- ${@: 1:3}

local _target=$(cftarget "$@" | jq -r '.target')
local _cmd="cf ${cmd} ${_target}"

eval "$_cmd"
responseCode="$?"

if [[ $responseCode > 0 ]]; then
  echo "Unable to run command: ${_cmd}" >&2
fi
}

# =======================================
function cflogs () {
local _target=$(cftarget "$@" | jq -r '.target')
cf logs "$_target"
}

# =======================================
function cfenv () {
local _target=$(cftarget "$@" | jq -r '.target')
cf env "$_target"
}

# =======================================
function cfssh () {
local _target=$(cftarget "$@" | jq -r '.target')
cf ssh "$_target"
}

# =======================================
function remove_memcached_service() {
usage=$(cat << EOL
Usage: remove_memcached_service "missionary-referral-web-ws-dev" "missionary-referral-memcache"
EOL
)

appName="$1"
serviceName="$2"

unset dryrun
if [ -z "$DRYRUN" ]; then
dryrun="yes"
fi

if [ -z "$appName" ] || [ -z "$serviceName" ]; then
echo -e "$usage"
return
fi

CMD=$(cat << EOL
cf unbind-service "$appName" "$serviceName"
EOL
)

unset ans
cat << EOL

CMD: $CMD
Are you sure? (Ctrl-c to cancel; anything else, continue)
EOL

read ans

if [ -z "$dryrun" ]; then
echo "DRYRUN: $CMD"
else
(eval "$CMD")
fi

CMD=$(cat << EOL
cf delete-service "$serviceName"
EOL
)

unset ans
cat << EOL

CMD: $CMD
Are you sure? (Ctrl-c to cancel; anything else, continue)
EOL

read ans

if [ -z "$dryrun" ]; then
echo "DRYRUN: $CMD"
else
(eval "$CMD")
fi

};

# =======================================
function restart_app() {
usage=$(cat << EOL
Usage: restart_app "missionary-referral-web-ws-dev"
EOL
)

appName="$1"

unset dryrun
if [ -z "$DRYRUN" ]; then
dryrun="yes"
fi

if [ -z "$appName" ]; then
echo -e "$usage"
return
fi

CMD=$(cat << EOL
cf restart "$appName"
cf apps | grep "$appName"
EOL
)

unset ans
cat << EOL

CMD: 
$CMD

Are you sure? (Ctrl-c to cancel; anything else, continue)
EOL

read ans

if [ -z "$dryrun" ]; then
echo "DRYRUN: $CMD"
else
(eval "$CMD")
fi
};


# =======================================
cat << EOL
cfcli util has been loaded
supported targets: $(cfSupportedTargets)

Other functions:
$(remove_memcached_service)
$(restart_app)
EOL
