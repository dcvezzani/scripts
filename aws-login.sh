#!/bin/bash

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

nvm use 16.16.0

PUPPETEER_EXECUTABLE_PATH=/Users/dcvezzani/.nvm/versions/node/v16.16.0/./lib/node_modules/puppeteer/.local-chromium/mac-1022525/chrome-mac/Chromium.app/Contents/MacOS/Chromium aws-azure-login --mode=gui --profile icsAws
