#!/bin/bash

DEFAULT_SWAGGER_VERSION='5.9.0'
DEFAULT_API_PATH='./swagger'
DEFAULT_API_VERSION='v1'

function promptUser() {
  echo "Continue? (Ctrl-c to quit; any other key to continue)"
  read $ans
}

usage=$(cat << EOL
Usage: 

SWAGGER_VERSION="5.9.0" API_PATH="./swagger" ~/scripts/install-swagger-ui.sh

- CMS: API_PATH="src/main/xquery/sites/missionary-referral/api"; directory is automatically mapped to routes
- WS (nodejs): API_PATH="src/api"; update node express routes to include swagger
- FE (nodejs): API_PATH="src/api"; update node express routes to include swagger
- WS (java spring boot): Use library integration
 
EOL
)

if [[ -z "$SWAGGER_VERSION" ]]; then
cat << EOL
$usage

Since no value for SWAGGER_VERSION was provided, the default will be used

SWAGGER_VERSION=$DEFAULT_SWAGGER_VERSION
EOL
promptUser
  
  SWAGGER_VERSION="$DEFAULT_SWAGGER_VERSION"
fi

if [ "$API_PATH" = "" ]; then
cat << EOL
$usage

Since no value for API_PATH was provided, the default will be used

API_PATH='$DEFAULT_API_PATH'
EOL
promptUser

  API_PATH="$DEFAULT_API_PATH"
fi

if [ "$API_VERSION" = "" ]; then
cat << EOL
$usage

Since no value for API_VERSION was provided, the default will be used

API_VERSION='$DEFAULT_API_VERSION'
EOL
promptUser

  API_VERSION="$DEFAULT_API_VERSION"
fi

if [ -d "${API_PATH}/swagger-ui" ]; then
  echo "Archive current '${API_PATH}/swagger-ui' before running this script"
  exit 1
fi

CMD=$(cat << EOL
curl 'https://codeload.github.com/swagger-api/swagger-ui/zip/refs/tags/v${SWAGGER_VERSION}' \\
  -H 'authority: codeload.github.com' \\
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \\
  -H 'accept-language: en-US,en;q=0.9' \\
  -H 'cache-control: no-cache' \\
  -H 'pragma: no-cache' \\
  -H 'referer: https://github.com/swagger-api/swagger-ui/releases/tag/v${SWAGGER_VERSION}' \\
  -H 'sec-ch-ua: "Chromium";v="118", "Google Chrome";v="118", "Not=A?Brand";v="99"' \\
  -H 'sec-ch-ua-mobile: ?0' \\
  -H 'sec-ch-ua-platform: "macOS"' \\
  -H 'sec-fetch-dest: document' \\
  -H 'sec-fetch-mode: navigate' \\
  -H 'sec-fetch-site: same-site' \\
  -H 'sec-fetch-user: ?1' \\
  -H 'upgrade-insecure-requests: 1' \\
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \\
  --compressed \\
  --output "${API_PATH}/v${SWAGGER_VERSION}.zip"
EOL
)

cmd=$(cat << EOL
SWAGGER_VERSION="$SWAGGER_VERSION"
API_PATH="$API_PATH"
mkdir -p "${API_PATH}/swagger-ui"
mkdir -p "${API_PATH}/${API_VERSION}"

$CMD
sleep 1

unzip -j "${API_PATH}/v${SWAGGER_VERSION}.zip" "swagger-ui-${SWAGGER_VERSION}"/dist/* -d "${API_PATH}/swagger-ui"

cp ~/scripts/swagger.json.sample "${API_PATH}/${API_VERSION}"
)

echo "$cmd"
promptUser

(eval "$cmd")

cat << EOL
Create swagger.json (https://editor.swagger.io/)

Edit ${API_PATH}/swagger-ui/swagger-initializer.js (path may vary)

Update source url for swagger json.  E.g., 

  url: "https://petstore.swagger.io/${API_VERSION}/swagger.json",
  url: window.location.protocol + "//" + window.location.hostname + "/${API_VERSION}/swagger.json",
EOL
