#!/bin/bash

profile="$1"
action="$2"

# === string: usage statement ==================
usage=$(cat << EOL
Usage: . ~/scripts/load-awscli.sh <profile> [<action>]
Usage: load-awscli <profile> [<action>]

<profile> is required, ['power', 'icsAws', 'local']
- power: sandbox account
- icsAws: enterprise accounts

If <action> is provided, you should be presented a Chromium browser window to
signin and then set environment variables.

Else, simply assign environment variables so applications may use the
credentials there.  
EOL
)

# === function: show_summary ==================
function show_summary() {
cat << EOL
$usage
AWS Profile: $profile

Make sure that you have signed in recently and have a valid set of temporary
accessKeyId and secretAccessKey values, along with the sessionToken, of course.

The following environment variables should now be set:

- AWS_TARGET_PROFILE=$profile
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN
- AWS_REGION: $AWS_REGION
- AWS_ENDPOINT: $AWS_ENDPOINT
EOL
};

if [[ "$profile" == "" ]]; then
  echo "$usage"
  return 0 2>/dev/null
  exit 0
fi


# === clear/reset environment ==================
CMD2=$(cat << EOL
unset AWS_TARGET_PROFILE
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_REGION
unset AWS_ENDPOINT
unset DYNAMODB_STORE_DEBUG
EOL
)

if [[ ! $VERBOSE == "" ]]; then
  echo "# ======= Clearing environment variables... ======="
  echo "$CMD2\n"
fi
eval "$CMD2"


# === profile: local ==================
if [[ $profile == 'local' ]]; then

CMD3=$(cat << EOL
export AWS_TARGET_PROFILE=$profile
export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
export AWS_ENDPOINT=http://localhost:8000
export DYNAMODB_STORE_DEBUG=true
EOL
)

if [[ $VERBOSE != "" ]]; then 
  echo "\n# ======= Setting environment variables for [$profile]... ======="
  echo "$CMD3\n"
fi
eval "$CMD3"

show_summary

return 0 2>/dev/null
exit 0
fi

# === action: signin ==================
if [[ "$action" == "signin" ]]; then
CMD=$(cat << EOL
echo "# ======= Prompting user to sign in to AWS... ======="

PUPPETEER_EXECUTABLE_PATH=/Users/dcvezzani/.nvm/versions/node/v16.16.0/./lib/node_modules/puppeteer/.local-chromium/mac-1022525/chrome-mac/Chromium.app/Contents/MacOS/Chromium aws-azure-login --mode=gui --profile $profile

echo "Waiting for credentials file to be written..."
sleep 2
EOL
)

if [[ ! $VERBOSE == "" ]]; then echo "$CMD\n"; fi
eval "$CMD"
fi


# === profile|action: clear ==================
if [[ $profile == 'clear' || $action == 'clear' ]]; then
  echo "AWS related environment variables should now be cleared"

else

# === profile: power, icsAws ==================
CMD3=$(cat << EOL
export AWS_TARGET_PROFILE=$profile
export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | jc --ini | jq -r '.["power"].aws_access_key_id')
export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | jc --ini | jq -r '.["power"].aws_secret_access_key')
export AWS_SESSION_TOKEN=$(cat ~/.aws/credentials | jc --ini | jq -r '.["power"].aws_session_token')
export AWS_REGION=$(cat ~/.aws/config | jc --ini | jq -r '.default.region')
export AWS_ENDPOINT='https://dynamodb.us-east-1.amazonaws.com'
EOL
)

  if [[ $VERBOSE != "" ]]; then 
    echo "\n# ======= Setting environment variables for [$profile]... ======="
    echo "$CMD3\n"
  fi
  eval "$CMD3"
fi


show_summary
