#!/bin/bash

#==============================

function getAppGuid() {
local appname="$1"
if [[ ! $appname ]]; then
cat << 'EOL' >&2
Usage: getAppGuid "recovery-fe-test"
EOL
return 1
fi

local CMD=$(cat << EOL
cf app "$appname" --guid | xargs
EOL
)

if [[ $DRYRUN == 'y' ]]; then
echo -e "$CMD" >&2
else
eval "$CMD"
fi
}


#==============================

function getPublishedMetadataAnnotation() {
local guid="$1"
if [[ ! $guid ]]; then
cat << 'EOL' >&2
Usage: getPublishedMetadataAnnotation "6aa472f3-64b2-4aca-b141-a39ba18530f3"
EOL
return 1
fi

local CMD=$(cat << EOL
cf curl v3/apps/$guid
EOL
)

if [[ $DRYRUN == 'y' ]]; then
echo -e "$CMD" >&2
else
  local json=$(eval "$CMD")
  echo "$json" | jq -r '.metadata.annotations["ics.application-service"]'
fi
}


#==============================

function verifyFile() {
local file="$1"
if [[ ! $file ]]; then
cat << 'EOL' >&2
Usage: verifyFile "manifests/manifest-stage.yml"
EOL
return 1
fi

local lane=$(echo "$file" | perl -pe 's#^manifests\/manifest-([^\.]+).*#$1#g')
local CMD_appName=$(cat << EOL
cat manifests/manifest-${lane}.yml | yq -o=json | jq -r '.applications[0].name'
EOL
)
local appName=$(eval "$CMD_appName")

case "$lane" in
  dev | test | stage | prod)
    cf target -o "${org}" -s "${spacePrefix}-${lane}" >&2
    ;;
  *)
    echo "Unknown lane: ${lane}" >&2
    return 1
    ;;
esac

if [[ $? > 0 ]]; then
  return 1
fi

local appGuid=$(getAppname "${appName}")
local snNameFromCf=$(getPublishedMetadataAnnotation "$appGuid")
local snNameFromRepo=$(cat "$file" | yq -o=json | jq -r '.applications[0].metadata.annotations["ics.application-service"]')

cat << EOL
{
  "snNameFromCf__": "$snNameFromCf",
  "snNameFromRepo": "$snNameFromRepo"
}
EOL
}


#==============================

function verifyFiles() {
json="$1"
if [[ ! $json ]]; then
cat << 'EOL' >&2
Usage: verifyFile '{"org":"Communication Services","spacePrefix":"missionary"}'
EOL
return 1
fi

local org=$(echo "$json" | jq -r '.org')
local spacePrefix=$(echo "$json" | jq -r '.spacePrefix')
for file in $(find manifests -name 'manifest-*.yml'); do

verifyFile "$file"

done
}



getAppGuid
getPublishedMetadataAnnotation
verifyFile
verifyFiles
