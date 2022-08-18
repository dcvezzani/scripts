# ======================================

function patchManifestAnnotations() {

local usage=$(cat << EOL
.
Usage: patchManifestAnnotations '{"guid": <guid>, "serviceName": <>, "lane": <lane>, "tier": <tier>}'
E.g.,
  patchManifestAnnotations "{\"guid\":\"$guid\", \"serviceName\":\"$serviceName\", \"org\":\"$org\", \"space\":\"$space\"}"
EOL
)

local json="$1"
if [[ ! $json ]]; then
echo -e "$usage"
return 1
fi

local guid=$(echo "$json" | jq -r '.guid')
local serviceName=$(echo "$json" | jq -r '.serviceName')
local lane=$(echo "$json" | jq -r '.lane')
local tier=$(echo "$json" | jq -r '.tier')

if [[ ! $guid ]] || [[ ! $serviceName ]] || [[ ! $lane ]] || [[ ! $tier ]]; then
echo -e "$usage"
return 1
fi

CMD=$(cat << EOL
cf curl v3/apps/$guid -X PATCH -d '{ "metadata": { "annotations": { "ics.application-service": "$serviceName" } } }'
EOL
)

cat << EOL
Do this?

Inputs
org: $org
space: $space
guid: $guid
serviceName: $serviceName

Current manifest annotations value
$(cf curl v3/apps/$guid | jq '.metadata')

With this?
$CMD
EOL
unset ans
read ans

# if [[ $ans != 'y' ]]; then
# echo "Action canceled by user"
# return 1
# fi

eval "$CMD" >/dev/null 2>&1

cat << EOL
Updated manifest annotations value
$(cf curl v3/apps/$guid | jq '.metadata')
EOL

}

# ======================================

function updateManifestAnnotations() {

local usage=$(cat << EOL
.
Usage: updateManifestAnnotations <projectDir>
E.g.,
  updateManifestAnnotations "/Users/dcvezzani/projects/temples-ws"
  VALIDATE=true updateManifestAnnotations "/Users/dcvezzani/projects/temples-ws"
Notes:
- VALIDATE: don't mutate anything; just fetch the latest published metadata annotations from Cloud Foundry  

EOL
)

local projectDir="$1"
if [[ ! $projectDir ]]; then
echo -e "$usage"
return 1
fi

for file in $(ls -1 $projectDir/manifests/manifest-*.yml); do
echo -e "\n>>> $file"
org=$(cat "$file" | yq -o=json | jq -r '.properties["anthill-cf-org"]')
space=$(cat "$file" | yq -o=json | jq -r '.properties["anthill-cf-space"]')
appName=$(cat "$file" | yq -o=json | jq -r '.applications[0].name')
serviceName=$(cat "$file" | yq -o=json | jq -r '.applications[0].metadata.annotations["ics.application-service"]')

cf target -o "$org" -s "$space"
guid=$(getAppGuid "$appName")
if [[ $guid == 'FAILED' ]]; then
  echo ">>>skipping"
  continue
fi

if [[ $VALIDATE == 'true' ]]; then
  cat << EOL
$(cf curl v3/apps/$guid | jq '.metadata')
EOL
else
  patchManifestAnnotations "{\"guid\":\"$guid\", \"serviceName\":\"$serviceName\", \"org\":\"$org\", \"space\":\"$space\"}"
fi
done
}

# ======================================

cat << EOL
===========================================
>>> Update Metadata Annotations Utility <<<

This utility helps with applying metadata annotations for a given Business Application
- go to service now and identify the Mapped Application Service names for the targeted Business Application
- update metadata-*.yml files in project with the desired and names for each corresponding lane
- provide fullpath reference to each project to #updateManifestAnnotations
- #patchManifestAnnotations should be called by #updateManifestAnnotations if VALIDATE != 'true'
EOL

patchManifestAnnotations
updateManifestAnnotations
