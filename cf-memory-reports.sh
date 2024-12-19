#!/bin/bash

MEMORY_REPORTS_DIR='/Users/dcvezzani/Dropbox/journal/current/memory-reports'
DATESTAMP=$(date '+%Y-%m-%d')

# ==========================
fun gatherReportForApp() {
local projDir='/Users/dcvezzani/projects'

local json="$1"
local appSlug=$(echo "$json" | jq -r '.appSlug')
local cfAppName=$(echo "$json" | jq -r '.cfAppName')
local repoName=$(echo "$json" | jq -r '.repoName')

cat << EOL 1>&2
appSlug: $appSlug
cfAppName: $cfAppName
repoName: $repoName
EOL

if [[ -z $appSlug ]] || [[ -z $repoName ]]; then
cat << EOL
Usage e.g.: gatherReportForApp '{"appSlug": "cha", "repoName": "church-history-specialist-fe"}'

cfAppName: optional if target value exists in cfcli config
EOL
return
fi

local appInfo=$(cftarget "$appSlug" test fe)
local cfTarget=$(echo "$appInfo" | jq -r '.target')

cat << EOL 1>&2
cfTarget: $cfTarget
EOL

if [[ ! -z $cfTarget ]]; then
local cfAppName="$cfTarget"
elif [[ -z $cfAppName ]]; then
cat << EOL
Error: cfAppName or target from cfcli config is required
EOL
return
fi

cd "${projDir}/${repoName}" >/dev/null 2>&1
local manifestMemory=$(yq -o=json manifests/manifest-test.yml | jq -r '.applications | map(select(.name == "'$cfAppName'"))[0].memory')

# cf ssh "$cfAppName" -c 'less /proc/meminfo' | /Users/dcvezzani/scripts/parse-proc-meminfo.js | jq -r '.|map(select(.name == "MemFree"))[0].mbytes'

local jqScript=$(cat << EOL
[{"application": "${cfAppName}"} + ${appInfo}] + . + [{"name": "manifestMemory (Mbs)", "value": "$manifestMemory"}]
EOL
)
# echo "$jqScript"

cf ssh "$cfAppName" -c 'less /proc/meminfo' | /Users/dcvezzani/scripts/parse-proc-meminfo.js | jq "$jqScript" | tee "${MEMORY_REPORTS_DIR}/${DATESTAMP}-${cfAppName}.json" | jq
}

# ==========================
fun gatherReportForApps() {
gatherReportForApp  '{"appSlug": "cha", "repoName": "church-history-specialist-fe"}'
gatherReportForApp  '{"appSlug": "di", "repoName": "deseret-industries-fe"}'
gatherReportForApp  '{"appSlug": "planning", "repoName": "missionary-planning-fe"}'
gatherReportForApp  '{"appSlug": "referrals", "repoName": "missionary-referral-fe"}'
gatherReportForApp  '{"appSlug": "records", "repoName": "records-keeping-fe"}'
gatherReportForApp  '{"appSlug": "arp", "repoName": "recovery-fe"}'
gatherReportForApp  '{"appSlug": "si", "repoName": "seminary-and-institute-fe"}'
gatherReportForApp  '{"appSlug": "temples", "repoName": "temples-fe"}'
gatherReportForApp  '{"appSlug": "thrasher", "repoName": "thrasher-fe"}'

cd "${MEMORY_REPORTS_DIR}"

local CMD=$(cat << EOL
jq -s 'map(. as \$all | \$all | map(select((.name | tostring | (startswith("manifestMemory") or startswith("MemFree"))) or (.application))) | {application: .[0].application, memoryFreeNum: (.[1].mbytes | tonumber), memoryFree: (.[1].mbytes + " Mb"), memoryManifest: .[2].value} ) | sort_by(.memoryFreeNum)' $DATESTAMP-*.json
EOL
)

echo "$CMD"
eval "$CMD"
}

cat << EOL
Usage:

gatherReportForApp  '{"appSlug": "cha", "repoName": "church-history-specialist-fe"}'
gatherReportForApps

Reports will be written to: $MEMORY_REPORTS_DIR
EOL
