#!/bin/bash

# ========================================
REPORT_BASE_PATH="/Users/dcvezzani/Dropbox/journal/current/project-payload/reports"

if [ ! -d $REPORT_BASE_PATH ]; then
mkdir -p $REPORT_BASE_PATH
fi

if [ ! "$SHOW_HELP" = "n" ]; then
cat << EOL
___________________________________________
Loading project payload report functions...

Functions loaded:
- getCookie()
- isJson()
- reportPath()
- writeReport()
- renderReport()
- renderReports()

Constants loaded:
- REPORT_BASE_PATH: $REPORT_BASE_PATH
EOL

cat << 'EOL1'

Usage:

Case 1:

cookie='xxx'
renderReport 'https://addictionrecovery.churchofjesuschrist.org/admin/meetings?lang=eng' "$cookie"
(ls ${REPORT_BASE_PATH}/*.json ${REPORT_BASE_PATH}/*.html)

renderReport 'https://addictionrecovery.churchofjesuschrist.org/?lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1' "$cookie"
(ls ${REPORT_BASE_PATH}/*.json ${REPORT_BASE_PATH}/*.html)

Case 2:

cookie='xxx'
urls=$(cat << EOL
https://addictionrecovery.churchofjesuschrist.org/?lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1
https://addictionrecovery.churchofjesuschrist.org/api/subnav?lang=eng
https://addictionrecovery.churchofjesuschrist.org/api/meetingsMap?clientTimezone=America/Denver&lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual
https://addictionrecovery.churchofjesuschrist.org/api/meetingsMap?clientTimezone=America/Denver&lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&lat=40.521893&lng=-111.9391023&search=Riverton,%20UT,%20USA
https://addictionrecovery.churchofjesuschrist.org/api/meetings?clientTimezone=America/Denver&ids=528359,528459,528909,528937,529085,529283,529345,529397,529410,529524,529551,529552,530310,530579,530658,531405,531441,531684,531695,531746,532151&lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1&lat=40.521893&lng=-111.9391023&search=Riverton,%20UT,%20USA&applicationContext=public
https://addictionrecovery.churchofjesuschrist.org/api/meetings?clientTimezone=America/Denver&lang=eng&showMap=false&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1&lat=40.521893&lng=-111.9391023&search=Riverton,%20UT,%20USA&applicationContext=public
https://addictionrecovery.churchofjesuschrist.org/api/meetings?clientTimezone=America/Denver&ids=528909,529397,529410,530579,531746,532151&lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1&lat=40.521893&lng=-111.9391023&search=Riverton,%20UT,%20USA&id=467&applicationContext=public
EOL
)

renderReports "$cookie"
(ls ${REPORT_BASE_PATH}/*.json ${REPORT_BASE_PATH}/*.html)
EOL1

fi


# ========================================
DISPLAY_INPUTS=$(cat << 'EOL'
______________________________
Checking for files associated with PROJECT_NAME, $PROJECT_NAME...

Arguments:
- cookie="${cookie:0:150}..."
- cookieSignedIn="${cookieSignedIn:0:150}..."

EOL
)

# ========================================
WARN_CLEANING=$(cat << EOL

Clearing out previous reports...
EOL
)

# ========================================
CLEAN_PROJECT_REPORTS=$(cat << 'EOL'
  
listRelatedFiles
responseCode="$?"

if [[ $responseCode = 0 ]]; then

  echo -e "$WARN_CLEANING"
  
  CMD="rmRelatedFiles"
  echo -e "CMD: $CMD"
  printf "Confirm command [y|n]; default value: 'n': "
  read ans

  if [ $ans = "y" ]; then
    (eval "$CMD")
  fi
fi
EOL
)

# ========================================
RENDER_AND_LIST=$(cat << 'EOL'
echo -e "\nFiles associated with ${PROJECT_NAME}"
listRelatedFiles
EOL
)

# ========================================
function renderAndList() {
  local cookie="$1"

  if [[ ! $cookie ]]; then
    cat << 'EOL'
Unable to renderAndList; cookie is missing
EOL
    return
  fi

  renderReports "$cookie"
  (eval "$RENDER_AND_LIST")
};

# ========================================
function displayInputs() {
  (eval "echo \"$DISPLAY_INPUTS\"")
};

# ========================================
function cleanProjectReports() {
  (eval "$CLEAN_PROJECT_REPORTS")
};

# ========================================
VALIDATE_USAGE=$(cat << 'EOL'
if [[ ! $cookie ]] || [[ ! $cookieSignedIn ]]; then
  echo -e "ERROR: One or more cookie(s) are missing.\n"

  usage
  exit 1
fi
EOL
)
  
# ========================================
function validateUsage() {
  eval "$VALIDATE_USAGE"

};

# ========================================
SAMPLE_CALL=$(cat << 'EOL'
Usage: ./project-payload/${PROJECT_NAME}.sh \\
  /Users/dcvezzani/Dropbox/journal/current/project-payload/cookie.txt \\
  /Users/dcvezzani/Dropbox/journal/current/project-payload/cookieSignedIn.txt

EOL
)

# ========================================
function usage() {
  (eval "echo -e \"$SAMPLE_CALL\"")
};

# ========================================
LIST_RELATED_FILES_GENERAL=$(cat << 'EOL'
${REPORT_BASE_PATH}/${PROJECT_PATH}/*
EOL
)

LIST_RELATED_FILES=$(cat << 'EOL'
${REPORT_BASE_PATH}/${PROJECT_PATH}/*.json ${REPORT_BASE_PATH}/${PROJECT_PATH}/*.html
EOL
)

# ========================================
function listRelatedFiles() {
  (eval "ls $LIST_RELATED_FILES_GENERAL")
};

# ========================================
function rmRelatedFiles() {
  (eval "rm $LIST_RELATED_FILES")
};

# ========================================
function isJson() {
local responsePayload="$1"
echo "$responsePayload" | jq '.' >/dev/null 2>&1
local returnCode="$?"

if [ "$returnCode" = "0" ]; then
echo "true"
else
echo "false"
fi
};

# ========================================
function getCookie() {
local cookiePath="$1"
local contentFileContent=$(cat "$cookiePath" 2> /dev/null)
local resultCode="$?"

if [[ $resultCode == 0 ]]; then
echo "$contentFileContent" | perl -ne '/cookie: /i && print' | perl -pe 's/^.*cookie: //i; s/'"'"'.*$//'
fi
};

# (ls  ${REPORT_BASE_PATH}/*.json)

# ========================================
function reportPath() {
url="$1"
# reportPath 'https://local.churchofjesuschrist.org/referrals/?lang=eng' html
# reportPath 'https://addictionrecovery.churchofjesuschrist.org/?lang=eng' html
# reportPath 'https://addictionrecovery.churchofjesuschrist.org/api/meetings?clientTimezone=America/Denver&ids=528359,528459,528909,528937,529085,529283,529345,529397,529410,529524,529551,529552,530310,530579,530658,531405,531441,531684,531695,531746,532151&lang=eng&showMap=true&meetingTypes=inPerson&genders=menAndWomen,menOnly,womenOnly,ysaMenAndWomen,ysaMenOnly,ysaWomenOnly,couples,wives&groupTypes=individual&page=1&lat=40.521893&lng=-111.9391023&search=Riverton,%20UT,%20USA&applicationContext=public' html
local baseUrl=$(echo "$url" | awk '{split($0, parts, "?"); print parts[1]}' | perl -pe 's/\/$//')
if [[ $DEBUG ]]; then echo -e ">>>baseUrl=\"$baseUrl\""; fi

local domainAndPath=$(echo "$baseUrl" | perl -p -e 's/https?:\/\/(.*)/$1/; s/\/+/ /g')
eval 'domainAndPathParts=($(echo $domainAndPath))' # create array
if [[ $DEBUG ]]; then echo -e ">>>domainAndPath=\"$domainAndPath\""; fi

local domainName=${domainAndPathParts[0]}
eval 'domainAndPathParts=($(echo ${domainAndPathParts[@]:1}))' # shift array
if [[ $DEBUG ]]; then echo -e ">>>domainName=\"$domainName\""; fi

if [[ $DEBUG ]]; then echo -e ">>>USE_PATH=\"$USE_PATH\""; fi
if [ ! "$USE_PATH" = "n" ]; then
local domainName="${domainName}-${domainAndPathParts[0]}"
eval 'local domainAndPathParts=($(echo ${domainAndPathParts[@]:1}))' # shift array
fi

local urlPath=$(echo "${domainAndPathParts[@]}")

if [[ ! $urlPath ]]; then
  urlPath="home"
else
local urlPath=$(echo "$urlPath" | perl -pe 's/ +/-/g')
fi

# local domainName=$(echo "$domainName" | perl -pe 's/[\/\.]+/-/g')
# local urlPath=$(echo "$urlPath" | perl -pe 's/[\/\.]+/-/g')

if [[ $DEBUG ]]; then echo -e ">>>domainName=\"$domainName\""; fi
if [[ $DEBUG ]]; then echo -e ">>>urlPath=\"$urlPath\""; fi

(ls -1 ${REPORT_BASE_PATH}/${domainName}/${urlPath}.* >/dev/null 2>&1)
local returnCode="$?"

if [ ! "$returnCode" = "0" ]; then
local cnt='0'
else
local cnt=$(ls -1 ${REPORT_BASE_PATH}/${domainName}/${urlPath}.* | wc -l | xargs)
fi

local cnt=$(printf "%03d" "$cnt")

if [ ! -d "${REPORT_BASE_PATH}/${domainName}" ]; then
  mkdir -p "${REPORT_BASE_PATH}/${domainName}"
fi

echo "${REPORT_BASE_PATH}/${domainName}/${urlPath}.${cnt}.${extension}"
};

# ========================================
function writeReport() {
local url="$1"
local responsePayload="$2"

if [ "$(isJson "$responsePayload")" = "true" ]; then
local responsePayload=$(echo "$responsePayload" | jq '.')

else
local extension="html"
local writeReportPath=$(reportPath "$url" "$extension")
echo -e "Writing report to: ${writeReportPath}"
echo "$responsePayload" > "$writeReportPath"

local responsePayload=$(echo "$responsePayload" | perl -ne '/__NEXT_DATA__/ && print' | perl -p -e 's/^.*(<script id="__NEXT_DATA__" type="application\/json">|__NEXT_DATA__[ =]+)//; s/(<\/script>|;__NEXT_LOADED_PAGES).*$//' | jq '.')
fi

responsePayloadLength=$(echo "$responsePayload" | perl -pe 's/[\r\n]//g' | wc -c | xargs)
# echo $responsePayloadLength

if [[ $? = 0 ]] && [[ $responsePayloadLength > 0 ]]; then
local extension="json"
local writeReportPath=$(reportPath "$url" "$extension")
echo -e "Writing report to: ${writeReportPath}"
echo "$responsePayload" > "$writeReportPath"
fi
};

# ========================================
function renderReport() {
local url="$1"
local cookie="$2"

echo -e "\nFetching FE endpoint: ${url}"
local cmd=$(cat << EOL
curl '$url' \\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \\
  -H 'Accept-Language: en-US,en;q=0.9' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Cookie: $cookie' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://www.churchofjesuschrist.org' \\
  -H 'Sec-Fetch-Dest: document' \\
  -H 'Sec-Fetch-Mode: navigate' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'Sec-Fetch-User: ?1' \\
  -H 'Upgrade-Insecure-Requests: 1' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.88 Safari/537.36' \\
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="100", "Google Chrome";v="100"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  --compressed
EOL
)

(echo -e "CMD: $cmd")
local responsePayload=$(eval "$cmd")

(writeReport "$url" "$responsePayload")
};

# ========================================
function renderReports() {
local cookie="$1"

(for url in $(echo "$urls" | xargs); do
renderReport "$url" "$cookie"
done)
};

