#!/bin/bash

usage=$(cat << EOL
Usage: 

SWAGGER_VERSION="4.18.1" API_PATH="./swagger-docs" ~/scripts/install-swagger-ui.sh

- CMS: API_PATH="src/main/xquery/sites/missionary-referral/api"; directory is automatically mapped to routes
- WS (nodejs): API_PATH="src/api"; update node express routes to include swagger
- FE (nodejs): API_PATH="src/api"; update node express routes to include swagger
- WS (java spring boot): Use library integration
 
EOL
)

if [ "$SWAGGER_VERSION" = "" ]; then
  echo -e "$usage"
  exit 1
fi

if [ "$API_PATH" = "" ]; then
  echo -e "$usage"
  exit 1
fi


if [ -d "${API_PATH}/swagger-ui" ]; then
  echo "Archive current '${API_PATH}/swagger-ui' before running this script"
  exit 1
fi

cmd=$(cat << EOL
 
SWAGGER_VERSION="$SWAGGER_VERSION"
API_PATH="$API_PATH"
mkdir -p "${API_PATH}/swagger-ui"

curl "https://codeload.github.com/swagger-api/swagger-ui/zip/refs/tags/v${SWAGGER_VERSION}" --output "${API_PATH}/v${SWAGGER_VERSION}.zip"
unzip -j "${API_PATH}/v${SWAGGER_VERSION}.zip" "swagger-ui-${SWAGGER_VERSION}"/dist/* -d "${API_PATH}/swagger-ui"
)

cat << EOL
$cmd

Continue? (Ctrl-c to quit; any other key to continue)
EOL

read $ans

(eval "$cmd")

cat << EOL
Create swagger.json (https://editor.swagger.io/)

Edit src/api/swagger-ui/swagger-initializer.js (path may vary)

Update source url for swagger json.  E.g., 

  url: "https://petstore.swagger.io/v2/swagger.json",
  url: window.location.protocol + "//" + window.location.hostname + "/v2/swagger.json",
EOL
