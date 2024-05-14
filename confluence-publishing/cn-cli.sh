#!/bin/bash

# Usage
usage() {
cat << EOL
Usage: 
[<Cookie>] cn <pageType> <action> [<resource>]
[<Cookie>] cn login
[<Cookie>] cn <pageType> [index]
[<Cookie>] cn <pageType> view|edit|create|publish <resource>
[<Cookie>] cn <pageType> publish

- Cookie: cookie header from browser; should parse JSESSIONID and MRHSession from this
- pageType: dev|developers-blog|stand|standup
- action: open|view|edit|create|publish
- resource: <filename>|<url>|<protocol-less-url>|<number>
- cn is an alias for ~/scripts/confluence-publishing/cn.sh

<resource>
- url: https://confluence.churchofjesuschrist.org/display/PCP/Transform+Basics
- protocol-less-url: //confluence.churchofjesuschrist.org/display/PCP/Transform+Basics
- number: 66025673 (from https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=66025673)
- filename: /Users/dcvezzani/Dropbox/journal/current/20230426-deseret-trust-deployment-instructions-vi.md

Login example
cn login

Index examples
cn dev
cn dev index

View examples
cn dev open 145851293
cn dev open /Users/dcvezzani/Dropbox/journal/current/20230426-deseret-trust-deployment-instructions-vi.md
cn dev view //confluence.churchofjesuschrist.org/display/PCP/Transform+Basics
cn dev view https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=74941256

Edit examples
cn dev edit 145851293
cn dev edit //confluence.churchofjesuschrist.org/display/PCP/Transform+Basics
cn dev edit https://confluence.churchofjesuschrist.org/pages/viewpage.action?pageId=74941256

Create examples (only works for pageType: dev|developers-blog)
cn dev create "Page Title"

Publish examples
- if the document being published already exists, it will be opened for editing
cn dev publish /Users/dcvezzani/Dropbox/journal/current/20230426-deseret-trust-deployment-instructions-vi.md
cn stand publish /Users/dcvezzani/Dropbox/journal/current/standup-2023-04-26-wed.md

Create example (only for dev or developers-blog)
cn dev create "Some title"

Special publish features for pageType "stand" ("standup")

Publish today's standup
cn stand publish

Publish standup for specified datestamp
cn stand publish 2023-04-27
EOL
exit 1
}

# Run command
# - DEBUG=true may be used for troubleshooting
runCmd() {
CMD="$1"
if [[ $DEBUG == "true" ]]; then
echo "$CMD" 1>&2
else
eval "$CMD"
fi
}

# Resolve pageType
# - or login to set the Cookie
# - resolve pageType from short cuts
pageType="$1"
Cookie="$2"
if [[ $pageType == "login" ]]; then

CMD=$(cat << EOL
~/scripts/confluence-publishing/confluence-publishing-update-config.sh '$Cookie'
EOL
)
runCmd "$CMD"
exit 0

elif [[ -z $pageType ]]; then
usage
fi

# Resolve action
# - if none, default to "index"
shift; action="$1"
if [[ -z $action ]]; then
action="index"
fi

# Resolve resource
shift; resource="$1"
if [[ -z $resource && $action =~ ^index$ ]]; then

CMD=$(cat << EOL
~/scripts/confluence-publishing/publish-to-confluence.sh $pageType $action
EOL
)
runCmd "$CMD"
exit 0

elif [[ -z $resource && $action =~ ^publish$ ]]; then

filename=$(~/scripts/confluence-publishing/get-standup-note-filename.sh)
# filename=$(~/scripts/confluence-publishing/get-standup-note-filename.sh "$input_target_date")
  
CMD=$(cat << EOL
~/scripts/confluence-publishing/publish-to-confluence.sh $pageType $filename
EOL
)
runCmd "$CMD"
exit 0

elif [[ -z $resource ]]; then
usage
fi

# Perform the action
# - open or view resource
if [[ $action =~ ^(view|open)$ ]]; then
CMD=$(cat << EOL
VIEW_ONLY=true ~/scripts/confluence-publishing/publish-to-confluence.sh $pageType $resource
EOL
)

echo "$CMD"

# -create dev resource
elif ( [[ $pageType =~ ^(dev|developers-blog)$ ]] && [[ $action =~ ^(create)$ ]] ); then
title="$1"

CMD=$(cat << EOL
source ~/scripts/confluence/create-dev-blog-entry.sh
createAndEditNewBlogEntry "$title"
EOL
)

# -edit or publish resource
elif [[ $action =~ ^(edit|publish)$ ]]; then
CMD=$(cat << EOL
~/scripts/confluence-publishing/publish-to-confluence.sh $pageType $resource
EOL
)

else
cat << EOL
pageType="$pageType"
action="$action"
title="$1"
EOL

usage
fi
runCmd "$CMD"

