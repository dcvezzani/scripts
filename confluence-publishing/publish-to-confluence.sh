#!/bin/bash

# This utility may be used to publish an existing team standup note.  It will
# treat the file content as Markdown when publishing to Confluence.

JSESSIONID="$JSESSIONID"
page="$1"
filename="$2"

if [[ $page == "dev" ]]; then
  page="developers-blog"
elif [[ $page == "stand" ]]; then
  page="standup"
fi

BASE_URL='https://confluence.churchofjesuschrist.org'
PROTOCOL=$(echo "$BASE_URL" | perl -p -e 's/^(https?:).*/$1/')

# Usage
if [[ -z $filename ]]; then
cat << EOL
Usage ~/scripts/confluence-publishing/publish-to-confluence.sh <page> <filename>

E.g., 
~/scripts/confluence-publishing/publish-to-confluence.sh developers-blog asdf.md
~/scripts/confluence-publishing/publish-to-confluence.sh standup asdf.md
EOL
fi

if [[ -z $JSESSIONID ]]; then
  JSESSIONID=$(cat ~/.confluence.json | jq -r '.JSESSIONID')
fi

# Missing JSESSIONID
if [[ -z $JSESSIONID ]]; then
cat << EOL
Unable to find value for JSESSIONID.  

Make sure you have created ~/.confluence.json and provide the necessary values:

{
  "space": "PCP",
  "standup": {
    "pageId": "142972888"
  },
  "developers-blog": {
    "pageId": "35653536"
  },
  "JSESSIONID": ""
}

Try updating config:
~/scripts/confluence-publishing/confluence-publishing-update-config.sh
EOL
exit 1
fi

# Pull these values from config
space=$(cat ~/.confluence.json | jq -r '.space')
pageId=$(cat ~/.confluence.json | jq -r '.["'"$page"'"].pageId')

# These values should always be the same for Team One standup documents
referrerPath="/Developers+Blog"

# Verify a JESSIONID was provided
if [[ -z $JSESSIONID ]]; then
cat << EOL
Usage: ~/scripts/confluence-publishing/publish-standup-notes.sh <jsessionid> [<yyyy-mm-dd>]
aka:   publish-standup <jsessionid> [<yyyy-mm-dd>]

Note: get JSESSIONID Session cookie from browser after signing in and provide
  as argument

E.g., 
~/scripts/confluence-publishing/publish-standup.sh 8AB227BF6E3993AC033BECB62452B864
~/scripts/confluence-publishing/publish-standup.sh 8AB227BF6E3993AC033BECB62452B864 2023-04-18
EOL
  exit 1

fi

# If a target date isn't provided, use the current date
if [[ -z $input_target_date ]]; then
  input_target_date=$(date '+%Y-%m-%d')
fi

preCreateDocument() {
# Get content id representing document that will be authored
# - reminds me of a CSRF token
local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/pages/createpage.action?spaceKey=${space}&fromPageId=${pageId}&src=quick-create' \\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Cookie: JSESSIONID=${JSESSIONID}' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://confluence.churchofjesuschrist.org/display/${space}${referrerPath}' \\
  -H 'Sec-Fetch-Dest: document' \\
  -H 'Sec-Fetch-Mode: navigate' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'Sec-Fetch-User: ?1' \\
  -H 'Upgrade-Insecure-Requests: 1' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \\
  -H 'sec-ch-ua: "Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  --compressed | /Users/dcvezzani/scripts/confluence-publishing/parse-pre-create-document.js '${BASE_URL}' | jq -r '.contentId'
EOL
)

if [[ $DEBUG == "true" || $DEBUG_TARGET == "pre-create" ]]; then
echo "$CMD" 1>&2
else
eval "$CMD"
fi
}

getContentId() {
local contentId=$(preCreateDocument)

cat << EOL >&2
contentId: $contentId
EOL
  
echo -n "$contentId"
}

viewIndex() {
local title="$1"
local lastLine=$(cat << EOL
  --compressed | /Users/dcvezzani/scripts/confluence-publishing/parse-view-index.js '${BASE_URL}' | jq -r '.'
EOL
)

if [[ ! -z $title ]]; then
local lastLine=$(cat << EOL
  --compressed | /Users/dcvezzani/scripts/confluence-publishing/parse-view-index.js '${BASE_URL}' '${title}' | jq -r '.[0].fullUrl'
EOL
)
fi

local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}' \\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Cookie: JSESSIONID=${JSESSIONID}' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://confluence.churchofjesuschrist.org/display/PCP/Asdf' \\
  -H 'Sec-Fetch-Dest: document' \\
  -H 'Sec-Fetch-Mode: navigate' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'Sec-Fetch-User: ?1' \\
  -H 'Upgrade-Insecure-Requests: 1' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \\
  -H 'sec-ch-ua: "Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
${lastLine}  
EOL
)

if [[ $DEBUG == "true" || $DEBUG_TARGET == "index" ]]; then
echo "$CMD" 1>&2
else
eval "$CMD"
fi
}

editDocument() {
local title="$1"

if [[ $filenameIsUrl == "true" ]]; then
local documentUrl=$filename
else
local documentUrl=$(viewIndex "$title")
fi

local CMD=$(cat << EOL
curl '${documentUrl}' \\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Cookie: JSESSIONID=${JSESSIONID}' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=${pageId}' \\
  -H 'Sec-Fetch-Dest: document' \\
  -H 'Sec-Fetch-Mode: navigate' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'Sec-Fetch-User: ?1' \\
  -H 'Upgrade-Insecure-Requests: 1' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \\
  -H 'sec-ch-ua: "Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  --compressed | /Users/dcvezzani/scripts/confluence-publishing/parse-view-document.js '${BASE_URL}' | jq -r '.editLinkUrl.fullUrl'
EOL
)

if [[ $DEBUG == "true" || $DEBUG_TARGET == "edit" ]]; then
echo "$CMD" 1>&2
else
eval "$CMD"
fi
}

viewDocument() {
local title="$1"

if [[ $filenameIsUrl == "true" ]]; then
local documentUrl=$filename
else
local documentUrl=$(viewIndex "$title")
fi

echo "$documentUrl"
}

createDocument() {
local title="$1"
local body="$2"
local contentId=$3

# Copied over from inspector, copy curl
# - double escaped double quotes for values inside JSON object "value" property (two layers down)
# - removed '$' in front of value for --data-raw
# - only JSESSIONID is needed in Cookie header
local CMD=$(cat << EOL
curl 'https://confluence.churchofjesuschrist.org/rest/api/content?status=draft' \\
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \\
  -H 'Accept-Language: en-US,en;q=0.9,pt;q=0.8,es;q=0.7' \\
  -H 'Cache-Control: no-cache' \\
  -H 'Connection: keep-alive' \\
  -H 'Content-Type: application/json; charset=UTF-8' \\
  -H 'Cookie: JSESSIONID=${JSESSIONID}' \\
  -H 'Origin: https://confluence.churchofjesuschrist.org' \\
  -H 'Pragma: no-cache' \\
  -H 'Referer: https://confluence.churchofjesuschrist.org/pages/createpage.action?spaceKey=${space}&fromPageId=${pageId}' \\
  -H 'Sec-Fetch-Dest: empty' \\
  -H 'Sec-Fetch-Mode: cors' \\
  -H 'Sec-Fetch-Site: same-origin' \\
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \\
  -H 'X-Requested-With: XMLHttpRequest' \\
  -H 'sec-ch-ua: "Chromium";v="112", "Google Chrome";v="112", "Not:A-Brand";v="99"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  --data-raw '{"status":"current","title":"${title}","space":{"key":"${space}"},"body":{"editor":{"value":"<table class=\\\\"wysiwyg-macro\\\\" style=\\\\"background-image: url(\\'https://confluence.churchofjesuschrist.org/plugins/servlet/confluence/placeholder/macro-heading?definition=e21hcmtkb3dufQ&amp;locale=en_US&amp;version=2\\'); background-repeat: no-repeat;\\\\" data-macro-name=\\\\"markdown\\\\" data-macro-schema-version=\\\\"1\\\\" data-macro-body-type=\\\\"PLAIN_TEXT\\\\" data-mce-resize=\\\\"false\\\\"><tbody><tr><td class=\\\\"wysiwyg-macro-body\\\\"><pre>${body}</pre></td></tr></tbody></table>","representation":"editor","content":{"id":"${contentId}"}}},"id":"${contentId}","type":"page","ancestors":[{"id":"${pageId}","type":"page"}]}' \\
  --compressed
EOL
)

# Include '$' before '...'; it causes escape sequences to be interpreted
# Also including escaped apostrophe and double quotes now that HEREDOC command has been compiled
CMD=$(echo "$CMD" | perl -p -e 's/--data-raw /--data-raw \$/; s/__dbl_quotes__/\\\\\"/g; s/__single_quote__/\\'"'"'/g; s/__escaped_seq__/\\\\\\\\/g;')

if [[ $DEBUG == "true" || $DEBUG_TARGET == "create" ]]; then
echo "$CMD" 1>&2
else
eval "$CMD"
fi
}

prepareBody() {
local body="$1"

# Get body of standup notes
declare -a processedLines=()
local i=0
local inblock=false
local titleFound=false

# reading file in row mode, insert each line into array
while IFS= read -r line; do
  local chk=$(echo "$line" | grep -E '^```')

  if [[ $? == 0 ]]; then
    if [[ $inblock == "true" ]]; then inblock=false; else inblock=true; fi
  fi

  if [[ $inblock == "true" ]]; then
    local line=$(echo "$line" | perl -p -e 's/</&lt;/g')
  fi

  if [[ $titleFound == "false" ]]; then
    local chk=$(echo $line | grep -E '^#+ ')
    if [[ $? == 0 ]]; then
      printf '%s' 'T' 1>&2
      local titleFound=true
    else
      printf '%s' '-' 1>&2
    fi
  else
      printf '%s' '.' 1>&2
    processedLines[i]=$line
  fi
  
  let "i++"

done < "$filename"
echo 1>&2

# return body
printf '%s\n' "${processedLines[@]}" | perl -p -e 's/\"/__dbl_quotes__/g; s/'"'"'/__single_quote__/g; s/(\\)([nstbdwWD])/__escaped_seq__$2/g; s/^[\r\n]+// if 1 .. 1; s/\n/<br \/>/g'
}

publishDocument() {
local title="$1"
local body=$(prepareBody "$2")
local contentId=$(getContentId)

createDocument "$title" "$body" $contentId
}

process() {
if [[ $filename == "index" ]]; then
  viewIndex
  exit 1
fi


  
# Check to see if provided filename is a url, relative or full
if [[ $filename =~ ^https?:\/\/|^\/\/ ]]; then
  filenameIsUrl=true
  if [[ $filename =~ ^\/\/ ]]; then
    filename="${PROTOCOL}${filename}"
  fi

# Check to see if provided filename is a number
elif [[ $filename =~ ^\d+$ ]]; then
  filenameIsUrl=true
  filename="${BASE_URL}/pages/viewpage.action?pageId=${filename}"

# Check to see if provided filename is a datestamp
elif [[ $filename =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  filename=$(~/scripts/confluence-publishing/get-standup-note-filename.sh "$filename")
fi

# Verify file is available to be published
if [[ ! -e "$filename" && $filenameIsUrl != "true" ]]; then
cat << EOL
Unable to publish since file does not exist: "$filename"
EOL
  exit 1
fi
  
# Extract title from document
# - looks for first line that begins with '#'
local title=$(cat "$filename" | perl -ne 'print if /^#+ / && ++$count == 1' | perl -p -e 's/^#+ *//; s/^/ /; s/\s(\w+)/ \u$1/g; s/^ //')

if [[ $VIEW_ONLY == "true" ]]; then
  viewDocument "$title" | xargs open 
  exit 1
fi

if [[ $filenameIsUrl == "true" ]]; then
  local documentUrl="$filename"
else
  
  # Check if file exists
  local documentUrl=$(viewIndex "$title")
fi

# cat << EOL
# title: $title
# body: $(echo "$body" | wc)
# documentUrl: $documentUrl
# EOL

# If file does not exist, create it
# - else open the file in browser for editing
if [[ $documentUrl == 'null' ]]; then
  publishedUrl=$(publishDocument "$title" "$body" | ~/scripts/confluence-publishing/get-url.sh | jq -r '.url')
  echo "${publishedUrl} - Document has published for $page, '$title'" >&2
else
  editingUrl=$(editDocument "$title")
  open $editingUrl
  echo "${editingUrl} - Document has already been published for $page, '$title'. Editing document..." >&2
fi
}

process
# viewIndex 'Standup 2023-04-26 (Wed)'

# Archive
#
# Get body of standup notes
# body=$(cat "$filename" | /Users/dcvezzani/scripts/confluence-publishing/developer-notes-parse-md.js | perl -p -e 's/\\([stn])/\\\\$1/g; s/\"/__dbl_quotes__/g; s/'"'"'/__single_quote__/g; s/\n/<br \/>/g')
# body=$(cat "$filename" | /Users/dcvezzani/scripts/confluence-publishing/developer-notes-parse-md.js | perl -p -e 's/\n/<br \/>/g')

# # Extract title from standup notes
# title=$(cat "$filename" | perl -ne 'print if /^#+ / && ++$count == 1' | perl -p -e 's/\"/__dbl_quotes__/g; s/'"'"'/__single_quote__/g; s/^#+ *//; s/^/ /; s/\s(\w+)/ \u$1/g; s/^ //')

# # Get body of standup notes
# body=$(cat "$filename" | perl -p -e 's/\\s/\\\\s/g; s/\"/__dbl_quotes__/g; s/'"'"'/__single_quote__/g; s/\n/<br \/>/g')
# 
#
# printf '%s\n' "${body}"

# title=asdf
# body=qwer

# echo "$body"

# Create and execute method
# CMD=$(cat << EOL
# # publishDocument '{"title":"${title}","body":"${body}"}'
# publishDocument "${title}" "${body}"
# EOL
# )
# 
# CMD=$(cat << EOL
# publishDocument '{"title":"xxx","body":"xxx"}'
# EOL
# )



# echo "$CMD"
# eval $CMD
# 
# body=$(printf '%s\n' "${processedLines[@]}" | perl -p -e 's/\"/__dbl_quotes__/g; s/'"'"'/__single_quote__/g; s/\\n/__new_line__/g; s/\\t/__tab__/g; s/\\w/__word__/g; s/\\s/__space__/g; s/\\d/__number__/g; s/\\b/__boundary__/g; s/\n/<br \/>/g')
# 
#
# echo "$documentBodyValue"

# createDocCmd=$(echo "$createDocCmd" | perl -p -e 's/\{documentBodyValue\}/'"$documentBodyValue"'/')

# Simply publishing; does not use Markdown
# --data-raw $'{"status":"current","title":"${title}","space":{"key":"${space}"},"body":{"editor":{"value":"${documentBodyValue}","representation":"editor","content":{"id":"${contentId}"}}},"id":"${contentId}","type":"page","ancestors":[{"id":"${pageId}","type":"page"}]}' \
# 
