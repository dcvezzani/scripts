#!/bin/bash

children=$(cat < /dev/stdin)

getInfo() {
local url=$(echo -n "$children" | grep -E '^\{' | jq -r '._links.base + ._links.webui') 
local retCode=$?

if [[ $retCode == 0 ]]; then
local documentId=$(echo -n "$children" | grep -E '^\{' | jq -r '.id') 
local retCode=$?
fi

if [[ $retCode != 0 ]] || [[ $url == 'null' ]] || [[ $documentId == 'null' ]] || [[ -z $documentId ]]; then
echo -n "$children" | grep -E '^\{' | jq -r '{statusCode, message, reason}'
else
echo -n "{\"url\": \"${url}\",\"documentId\":${documentId}}"
fi
}

getInfo
