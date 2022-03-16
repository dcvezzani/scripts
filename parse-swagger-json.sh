#!/bin/bash

payload="$1"
# jsonPath="$2"

# payload='{"meta":{},"items":[{"type":"dictionary","id":"english-eng","name":"english","terms":{"broadcast-search-title":"Broadcasts","errorTitle401":"Access Denied","errorMessage500":"Something went wrong","seminary-manuals-search-placeholder":"Search Seminary Manuals","lds-org-facet":"ChurchofJesusChrist.org","teaserHeader":"About","institute-search-placeholder":"Search Institute","errorMessage401":"Please login using your Church Account to verify access to this content!","search-button-text":"Search","manuals-facet":"Course Materials","search-all-results":"Search Results","institute-manuals-search-placeholder":"Search Institute Manuals","institute-search-title":"Institute Search Results","broadcasts-facet":"Broadcasts","si-facet":"Seminary and Institute","no-results-found":"No results found","seminary-search-placeholder":"Search Seminary","church-education-facet":"Church Educational System","seminary-search-title":"Seminary Search Results","seminary-facet":"Seminary","errorTitle500":"Internal Server Error","church-education-search-placeholder":"Search Church Education","seminary-manuals-search-title":"Seminary Manuals","broadcast-search-placeholder":"Search Broadcasts","error-page-title":"Error page","institute-manuals-search-title":"Institute Manuals","si-search-placeholder":"Search Seminary and Institute","search-page-title":"Search Results","institute-facet":"Institute","related-content":"Related Content","search-metaTitle":"Search"}}]}'

# payload='{ "count": 15, "entries": [ { "lang": "eng", "uri": "/published/missionary-referral/logs/2021/12/28/2021-12-28T17:13:10-86895463298867357040-eng.json", "last-modified": "2021-12-28T17:13:10Z", "entry": { "dateTime": "2021-12-28T17:13:10.015832Z", "message": { "body": { "sourceId": 15452, "lastName": "Vezzani", "note": "test", "address": "132 S Dry Creek Lane", "languageId": 0, "orgId": 15929, "firstName": "Juventa", "referrerPhone": "2097569688", "areaId": 479146600, "systemSource": "ChurchofJesusChrist.org Referrals Web Form", "phone": "2097569769", "referrerEmail": "dcvezzani@gmail.com", "offerId": 132, "email": "jvezzani@gmail.com", "locId": 251 }, "type": "org.lds.csp.missionaryreferralwebws.productRequest.ProductRequestCreateRequest" } } } ] }'

# jsonPath='.'

# =============================
function requiredSection {
requiredProperties=$(for key in $(echo "$payload" | jq -r "$jsonPath"' | keys | join("\n")'); do printf "\"${key}\", "; done)
requiredProperties=$(echo "$requiredProperties" | perl -p -e 's/, $//')

cat <<- EOL
      "required": [
        $requiredProperties
      ],
EOL
}

# =============================
function xcomma {
_comma=','
if [[ ! $ITER < $(propertiesBlockLength) ]]; then
_comma=''
fi
echo $_comma
}

# =============================
# function parentPath {
# _parentPath="$jsonPath"
# if [ "$jsonPath" = "." ]; then
# _parentPath=''
# fi
# printf "$_parentPath"
# }

# =============================
function propertyType {
local key="$1"

if [ "$key" = "" ]; then
echo "$payload" | jq -r "${jsonPath} | type"
else
echo "$payload" | jq -r "${jsonPath}[\"${key}\"] | type"
fi
}

# =============================
function propertyValue {
local key="$1"

if [[ ! "$_propertyType" = "string" && ! "$_propertyType" = "number" ]]; then
  return
fi

echo "$payload" | jq -r "${jsonPath}[\"${key}\"]"
}

# =============================
function requiredPropertiesEntry {
local key="$1"
local comma=""

if [[ "$2" == "comma:true" ]]; then
  comma=","
fi

_propertyType=$(propertyType $key)

typeComma=','
if [[ ! "$_propertyType" = "string" && ! "$_propertyType" = "number" ]]; then
typeComma=''
fi

cat <<- EOL
        "${key}": {
          "type": "${_propertyType}"${typeComma}
EOL

if [[ "$_propertyType" = "string" ]]; then
cat <<- EOL
          "example": "$(propertyValue $key)"
EOL
fi

if [[ "$_propertyType" = "number" ]]; then
cat <<- EOL
          "example": $(propertyValue $key)
EOL
fi

cat <<- EOL
        }$comma
EOL
}

# =============================
function requiredPropertiesBlock {
ITER=1
local requiredKeys=$(echo "$payload" | jq -r "$jsonPath"' | keys | join(" ")')

eval "requiredKeys=($requiredKeys)"
local length=$((${#requiredKeys[@]}-1))
local requiredKeysExceptLast=${requiredKeys[@]:0:$length}
local requiredKeysLast=${requiredKeys[$length]}

# echo "requiredKeysLast: ${requiredKeysLast}"

# echo "length: ${length}"
# echo "${requiredKeys[@]:0:$length}"
# 
# echo "${requiredKeys[@]}"
# echo "${#requiredKeys[@]}"

for key in $requiredKeysExceptLast; do
requiredPropertiesEntry "$key" "comma:true"
((ITER++))
done

requiredPropertiesEntry "$requiredKeysLast"
}

# requiredKeys=(address areaId email firstName languageId lastName locId note offerId orgId phone referrerEmail referrerPhone sourceId systemSource)

function xrequiredPropertiesBlock {
ITER=1

local requiredKeys=$(echo "$payload" | jq -r "$jsonPath"' | keys | join("\n")')

local length=$(($#-1))
local requiredKeysExceptLast=${requiredKeys:1:$length}

for key in $requiredKeysExceptLast; do
requiredPropertiesEntry "$key"
((ITER++))
done
}


# =============================
function propertiesBlockLength {
echo "$payload" | jq -r "$jsonPath"' | keys | length'
}

# =============================
function parseObject {
cat <<- EOL
{
      "type": "$(propertyType)",
$(requiredSection)
      "properties": {
$(requiredPropertiesBlock)
      }
    }
EOL
}

# =============================
function parse {
if [ "$jsonPath" = "" ]; then
jsonPath='.'
fi

propertyType=$(echo "$payload" | jq -r "$jsonPath"' | type')

if [ "$propertyType" = "object" ]; then parseObject "$jsonPath"
elif [ "$propertyType" = "array" ]; then parseArray "$jsonPath"
elif [ "$propertyType" = "string" ]; then parseString "$jsonPath"
fi

}

# =============================
# parse "$2"
for jsonPath in "${@: 2}"; do
  # echo ">>> $jsonPath"
  parseObject
  # requiredPropertiesBlock
done
# requiredSection .
# propertiesBlockLength

# propertyValue "site-context"
