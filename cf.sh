#!/bin/bash

# =======================================
function cfSupportedTargets () {
  cat /Users/dcvezzani/scripts/config/cf.json | jq -r '. | keys | join(", ")'
}

# =======================================
function cflogin () {
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

  referrals | si | arp | cha | temples | memcache | thrasher)
    _org=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.org')
    _space=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.space')
    _app=$(cat /Users/dcvezzani/scripts/config/cf.json | jq -r '.'"$target"'.lanes.'"$lane"'.'"$tier"'.app')
    ;;

  *)
    echo "{\"error\":true,\"message\":\"Invalid target: ${$target}\"}"
    return
    ;;
esac

echo "{\"org\":\"$_org\",\"space\":\"$_space\",\"target\":\"$_app\"}"
}

# =======================================
function cftarget () {
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

echo "cfcli util has been loaded"
echo "supported targets: $(cfSupportedTargets)"
# grep -r "function" ~/scripts/cf.sh
