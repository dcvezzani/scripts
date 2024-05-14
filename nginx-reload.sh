#!/bin/bash

os=$(./scripts/detect-os.sh)

if [[ $os == 'windows' ]]; then
  npm run nginx:reload:windows
else
  echo "Reloading nginx..."
  npm run nginx:reload:unixish
fi

