# =========================================
# Join array into a string using the provided separator string
# E.g., myString=$(joinByString '\|' Moe Larry Curly)
joinByString() {
  local separator="$1"
  shift
  local first="$1"
  shift
  printf "%s" "$first" "${@/#/$separator}"
}

# =========================================
# Split string into an array using the optional separator string
# (separator defaults to ',')
# E.g., myArray=($(splitByString 'Moe,Larry,Curly'))
splitByString() {
  str="$1"
  separator="$2"

  if [[ $separator == "" ]]; then
    local separator=','
  fi

  echo "$str" | tr "$separator" "\n"
}

# =========================================
# Get ServiceNow (Mapping Application Service) name for the given application name
# requires the following cli apps: yq, jq
# parses yaml, converts to json, fetch json property value
function get_service_now_name() {
  local appname="$1"
  for dir in $(ls-projects ws,fe | grep -v 'recovery-ws'); do
    grep -rl "$appname" $dir/manifests | xargs yq -o=json '.' | jq -r '.applications[0].metadata.annotations["ics.application-service"]'
  done
}

# =========================================
# Get published CF application properties using manifests/manifest-${env}.yml
# Get values for org, space and app
function get_cf_target() {
local env="$1"
local json=$(yq -o=json "manifests/manifest-${env}.yml")

chk=$(echo "$json" | jq -r '.properties' 2> /dev/null)
local responseCode=$?

# echo "chk: ${chk}, ${responseCode}"

if [[ $responseCode == 0 ]] && [[ "$chk" != "" ]] && [[ "$chk" != "null" ]]; then
local org=$(echo "$json" | jq -r '.properties["anthill-cf-org"]')
local space=$(echo "$json" | jq -r '.properties["anthill-cf-space"]')
else
local org=$(echo "$json" | jq -r '.["anthill-cf-org"]')
local space=$(echo "$json" | jq -r '.["anthill-cf-space"]')
fi

local app=$(echo "$json" | jq -r '.applications[0].name')

get_target "$env" "$org" "$space" "$app"
}

# =========================================
# Get published CF application properties using devops/memcached.yml
# Get values for org, space and app
function get_pipeline_target() {
local env="$1"
local json=$(yq -o=json "devops/memcached.yml")

targetBlock=$(echo "$json" | jq -r '.stages | map(select(.parameters.cfSpace | contains("'"$env"'"))) | first' 2> /dev/null)
# local responseCode=$?

local org=$(echo "$targetBlock" | jq -r '.parameters.cfOrg')
local space=$(echo "$targetBlock" | jq -r '.parameters.cfSpace')
local app=$(echo "$targetBlock" | jq -r '.parameters.appName')

get_target "$env" "$org" "$space" "$app"
};

# =========================================
# Utility function to get published CF application properties
# after getting org, space, and app information from a CF source (manifests,
# pipeline template)
# 
# Options
# WRITE_THIS: set to 'n' to skip writing to a file; just show in the terminal
function get_target() {
local env="$1"
local org="$2"
local space="$3"
local app="$4"

# echo ">>> get_target; $env $org $space $app"

cf target -o "$org" -s "$space" 2>&1 >/dev/null
# cf apps | grep "$app"

local guid=$(cf app "$app" --guid | xargs)

unset responseCode
# echo "${app}" | grep "\-${env}" >&2
echo "${app}" | grep "\-${env}" 2>&1 >/dev/null
local responseCode=$?

appname="$app"
if [[ $responseCode > 0 ]]; then
appname="${app}-${env}"
fi

echo "guid: ${guid}: ${appname}" >&2

if [ "$WRITE_THIS" = "n" ]; then
cf curl "/v3/apps/$guid"
else
cf curl "/v3/apps/$guid" > "${CF_SERVICE_NOW_PATH}/cf-service-now-${appname}.json"
fi
};

# Gather all projects that have CF manifest yaml files.
# # =========================================
# PROJECT_SRC_DIRS=$(cat << EOL
# /Users/dcvezzani/projects/church-history-adviser-ws
# /Users/dcvezzani/projects/church-history-specialist-fe
# /Users/dcvezzani/projects/deseret-industries-fe
# /Users/dcvezzani/projects/missionary-planning-fe
# /Users/dcvezzani/projects/missionary-planning-ws
# /Users/dcvezzani/projects/missionary-referral-fe
# /Users/dcvezzani/projects/missionary-referral-ws
# /Users/dcvezzani/projects/records-keeping-fe
# /Users/dcvezzani/projects/recovery-fe
# /Users/dcvezzani/projects/refugees-fe
# /Users/dcvezzani/projects/rootstech-fe
# /Users/dcvezzani/projects/seminary-and-institute-fe
# /Users/dcvezzani/projects/seminary-and-institute-ws
# /Users/dcvezzani/projects/temples-fe
# /Users/dcvezzani/projects/temples-ws
# /Users/dcvezzani/projects/thrasher-fe
# /Users/dcvezzani/projects/thrasher-ws
# EOL
# )

# =========================================
# Fetch JSON response payload for all environments for a given project
# application
# Uses manifest-${env}.yml as source.
function get_app_info_from_manifest() {
for dir in $(echo "$PROJECT_SRC_DIRS" | xargs); do

if [[ "$dir" =~ recovery-blt ]] then
else
cd "$dir" 2>&1 >/dev/null

get_cf_target dev
get_cf_target test
get_cf_target stage
get_cf_target prod
echo

fi

done
};

# Gather all projects that have memcached pipeline templates.
# # =========================================
# PROJECT_SRC_DIRS=$(cat << EOL
# /Users/dcvezzani/projects/thrasher-ws
# /Users/dcvezzani/projects/church-history-adviser-ws
# /Users/dcvezzani/projects/temples-ws
# /Users/dcvezzani/projects/missionary-referral-ws
# EOL
# )

# =========================================
# Fetch JSON response payload for all environments for a given project
# application
# Uses manifest-${env}.yml as source.
function get_app_info_from_pipeline() {
for dir in $(echo "$PROJECT_SRC_DIRS" | xargs); do

cd "$dir" 2>&1 >/dev/null

get_pipeline_target test
get_pipeline_target stage
get_pipeline_target prod
echo

done
};

# =========================================
# Colorize output
function cecho() {
color="$1"
message="$2"

local RED="\033[1;31m"
local GREEN="\033[1;32m"
local YELLOW="\033[1;33m"
local NOCOLOR="\033[0m"

CMD=$(cat << EOL
echo -e "\${$color}\${message}\${NOCOLOR}"
EOL
)

eval "$CMD"
};

function cecho_v1() {
    local RED="\033[0;31m"
    local GREEN="\033[0;32m"
    local YELLOW="\033[1;33m"
    # ... ADD MORE COLORS
    local NC="\033[0m" # No Color

    local _shell=$(echo "$0")

    printf "${(P)1}${2} ${NC}\n"

    # if [[ "$_shell" =~ zsh ]]; then
    #   # ZSH
    #   printf "${(P)1}${2} ${NC}\n"
    # else
    #   # Bash
    #   # printf "${!1}${2} ${NC}\n"
    # fi
};


# =========================================
# Get value of given JSON file and path
# Return status code > 0 if not successful
function get_path_value() {
local _file="$1"
local _path="$2"

local chk=$(cat "$_file" | jq "$_path")
#  2>&1 >/dev/null
local responseCode="$?"

# echo ">>> responseCode; $responseCode $chk"

if [[ $responseCode == 0 ]] && [[ "$chk" != "null" ]]; then
cat "$_file" | jq "$_path"
else
return 1
fi
};

# =========================================
# Get value of given JSON file and path
# Return status code > 0 if not successful
# 
# Options
# SUMMARY_MODE=metadata get_summary
# REPORT_FILTER=test,stage SUMMARY_MODE=report get_summary
# 
# Default: SUMMARY_MODE=report
# get_summary
#
# get_summary [filename-filter]
# E.g., get_summary memcache
function get_summary() {
# for file in $(ls -1); do
# echo -e "$file"
# done

filenameFilter="$1"

FIND_CMD='ls *.json'
if [[ $filenameFilter ]]; then
FIND_CMD=$(cat << EOL
$FIND_CMD | grep "$filenameFilter"
EOL
)
fi

if [[ $CF_SERVICE_NOW_PATH ]]; then
  cd "$CF_SERVICE_NOW_PATH"
fi

if [[ $SUMMARY_MODE == "metadata" ]]; then
  (for file in $(eval "$FIND_CMD"); do
  echo -e "\n================\n$file"
  cat "$file" | jq '.metadata'
  done)
fi

if [[ $SUMMARY_MODE == "" ]] || [[ $SUMMARY_MODE == "report" ]]; then
  (for file in $(eval "$FIND_CMD"); do
  local guid=$(get_path_value $file '.guid')
  local name=$(get_path_value $file '.name')

  local pattern='__disabled__'
  if [[ $REPORT_FILTER ]]; then
    local reportFilters=($(splitByString "$REPORT_FILTER"))
    local pattern=$(joinByString '\|' "${reportFilters[@]}")
  fi

  CMD=$(cat << EOL
  if [[ \$name == "" ]]; then
    continue
  fi

  if [[ "$pattern" != "__disabled__" ]] && [[ ! \$file =~ $pattern ]]; then
    continue
  fi
EOL
)
  # echo "CMD: $CMD"
  eval "$CMD"

  (get_path_value $file '.metadata.annotations["ics.application-service"]' 2>&1 >/dev/null)
  local responseCode=$?

  if [[ $responseCode == 0 ]]; then
  cecho "GREEN" "- [x] guid: ${guid}: ${name}: ${file}"
  else
  echo "- [ ] guid: ${guid}: ${name}: ${file}"
  fi
  done)
fi
};

# =========================================
# Get all application names for the provided environment
# - dev, test, stage, prod
function get_app_names() {
local env="$1"

local appnames=()
for dir in $(ls-projects ws,fe | grep -v 'recovery-ws'); do
    local manifest=$(cat $dir/manifests/manifest-${env}.yml | yq -o=json '.' | jq '.')
    local appname=$(echo "$manifest" | jq '.applications[0].name')
    local nextIndex=$((${#appnames[@]} + 1))
    appnames[$nextIndex]="$appname"
done
echo "${appnames[@]}"
}

# =========================================
# Gather CF metadata for given application
# - sources: manifests/manifest-dev.yml, cf cli (guid)
function get_service_now_meta() {
  local appname="$1"

  for dir in $(ls-projects ws,fe | grep -v 'recovery-ws'); do
    local manifest=$(grep -rlE "${appname}$" $dir/manifests | grep -v swp | xargs yq -o=json '.' | jq '.')

    local serviceNow=$(echo "$manifest" | jq '.applications[0].metadata.annotations["ics.application-service"]' | perl -p -e 's/\n+/ /g')
    local org=$(echo "$manifest" | jq 'if (. | has("properties")) then (.properties["anthill-cf-org"]) else (.["anthill-cf-org"]) end' | perl -p -e 's/\n+/ /g')
    local space=$(echo "$manifest" | jq 'if (. | has("properties")) then (.properties["anthill-cf-space"]) else (.["anthill-cf-space"]) end' | perl -p -e 's/\n+/ /g')

    if [[ ! $serviceNow ]]; then
      continue;
    fi

    # echo "+ ${serviceNow}" >&2
    serviceNowNames=()
CMD=$(cat << EOL
  for entry in $serviceNow; do
    local nextIndex=\$((\${#serviceNowNames[@]} + 1))
    serviceNowNames[\$nextIndex]="\$entry"
  
    # echo "- \${entry}" >&2
  done
EOL
)
  # echo -e "$CMD"
  eval "$CMD"

    orgs=()
CMD=$(cat << EOL
  for entry in $org; do
    local nextIndex=\$((\${#orgs[@]} + 1))
    orgs[\$nextIndex]="\$entry"
  
    # echo "- \${entry}" >&2
  done
EOL
)
  # echo -e "$CMD"
  eval "$CMD"

    spaces=()
CMD=$(cat << EOL
  for entry in $space; do
    local nextIndex=\$((\${#spaces[@]} + 1))
    spaces[\$nextIndex]="\$entry"
  
    # echo "- \${entry}" >&2
  done
EOL
)
  # echo -e "$CMD"
  eval "$CMD"

  local guid=$(
  cd "$dir" >&2
  cf target -o "${orgs[1]}" -s "${spaces[1]}" >&2
  cf app "$appname" --guid | xargs
  )

  local serviceNowName=$(echo "${serviceNowNames[1]}")

  # Format serialized record
  cat << EOL
{ "appName":"$appname", "snName":"${serviceNowNames[1]}", "guid":"$guid", "org":"${orgs[1]}", "space":"${spaces[1]}", "dir":"$dir" }
EOL

return 0
  done
};

# =========================================
# Prepare SN metadata annotations
# - target environment
# - serialize to file
# - consider reviewing before running #apply_sn_metadata_annotations
# E.g., prepare_sn_metadata_annotations dev "/Users/dcvezzani/Dropbox/journal/current/20220519-cf-development.json"
function prepare_sn_metadata_annotations() {
local env="$1"
local filepath="$2"

local records=()
for entry in $(get_app_names "$env"); do
  # echo "====================== $entry"

  local record=$(get_service_now_meta $(echo $entry | perl -p -e 's/\"//g') | perl -p -e 's/\"/\\\"/g')
chk=$(cat << EOL
  echo "$record" | jq -c '.'
EOL
)
  # echo -e "$chk"
  eval "${chk}"

  local nextIndex=$((${#records[@]} + 1))
  records[$nextIndex]="$(echo $record | perl -p -e 's/\"/\\\"/g')"
done

joinByString ',' "${records[@]}" | perl -p -e 's/\\//g; s/^/\[/; s/$/\]/' | jq '. | map(select(.guid != "FAILED"))' > "$filepath"
}

# ====================================================
# Apply metadata annotations for provided record
function apply_sn_metadata_annotations_for() {
local record="$1"

local CMD=$(cat << EOL
local org=\$(echo -e "$record" | jq -r '.org')
local space=\$(echo -e "$record" | jq -r '.space')
local snname=\$(echo -e "$record" | jq -r '.snName')
local guid=\$(echo -e "$record" | jq -r '.guid')
EOL
)
# echo -e "$CMD"
eval "$CMD"

# echo "org: $org, space: $space"

local CMD=$(cat << EOL
cf target -o '$org' -s '$space'
cf curl v3/apps/$guid \
-X PATCH \
-d '{ "metadata": { "annotations": { "ics.application-service": "$snname" } } }'
EOL
)

echo -e "$CMD"

if [[ ! $DRYRUN ]] || [[ $DRYRUN != 'y' ]]; then
eval "$CMD"
fi
}

# ====================================================
# Clear metadata annotations for provided record
function clear_sn_metadata_annotations_for() {
local record="$1"

local CMD=$(cat << EOL
local org=\$(echo -e "$record" | jq -r '.org')
local space=\$(echo -e "$record" | jq -r '.space')
local snname=\$(echo -e "$record" | jq -r '.snName')
local guid=\$(echo -e "$record" | jq -r '.guid')
EOL
)
# echo -e "$CMD"
eval "$CMD"

# echo "org: $org, space: $space"

local CMD=$(cat << EOL
cf target -o '$org' -s '$space'
cf curl v3/apps/$guid \
-X PATCH \
-d '{ "metadata": {"annotations": {"ics.application-service": null } } }'
EOL
)

echo -e "$CMD"

if [[ ! $DRYRUN ]] || [[ $DRYRUN != 'y' ]]; then
eval "$CMD"
fi
}

# ====================================================
# Apply metadata annotations for all records in provided file
function apply_sn_metadata_annotations() {
local filepath="$1"

# Load records from file
local records=$(cat "$filepath" | jq -c '.')
local recordsLength=$(($(echo "$records" | jq '. | length')))
# recordsLength=1

# Loop through each record
local cnt=0
while [ $cnt -lt $recordsLength ]; do
apply_sn_metadata_annotations_for "$(echo "$records" | jq -c '.['"$(($cnt))"']' | perl -p -e 's/\"/\\\"/g')"
local cnt=$(($cnt + 1))
done
}


# =========================================
cat << 'EOF'
===============================================================
# CF manifest functions have been loaded; ready to report!
# - make sure to define a valid path for 'CF_SERVICE_NOW_PATH'
===============================================================

* GATHER REPORT

Usage example:

CF_SERVICE_NOW_PATH=/Users/dcvezzani/Dropbox/journal/current/cf-service-now

cf login --sso -a api.pvu.cf.churchofjesuschrist.org -u "$username"

PROJECT_SRC_DIRS=$(cat << EOL
/Users/dcvezzani/projects/church-history-adviser-ws
/Users/dcvezzani/projects/church-history-specialist-fe
/Users/dcvezzani/projects/deseret-industries-fe
/Users/dcvezzani/projects/missionary-planning-fe
/Users/dcvezzani/projects/missionary-planning-ws
/Users/dcvezzani/projects/missionary-referral-fe
/Users/dcvezzani/projects/missionary-referral-ws
/Users/dcvezzani/projects/records-keeping-fe
/Users/dcvezzani/projects/recovery-fe
/Users/dcvezzani/projects/recovery-ws
/Users/dcvezzani/projects/refugees-fe
/Users/dcvezzani/projects/rootstech-fe
/Users/dcvezzani/projects/seminary-and-institute-fe
/Users/dcvezzani/projects/seminary-and-institute-ws
/Users/dcvezzani/projects/temples-fe
/Users/dcvezzani/projects/temples-ws
/Users/dcvezzani/projects/thrasher-fe
/Users/dcvezzani/projects/thrasher-ws
EOL
) && get_app_info_from_manifest

PROJECT_SRC_DIRS=$(cat << EOL
/Users/dcvezzani/projects/thrasher-ws
/Users/dcvezzani/projects/church-history-adviser-ws
/Users/dcvezzani/projects/temples-ws
/Users/dcvezzani/projects/missionary-referral-ws
EOL
) && get_app_info_from_pipeline

get_summary



* MANUALLY APPLY METADATA

prepare_sn_metadata_annotations prod "/Users/dcvezzani/Dropbox/journal/current/20220519-cf-production.json"
apply_sn_metadata_annotations "/Users/dcvezzani/Dropbox/journal/current/20220519-cf-development.json"

EOF

